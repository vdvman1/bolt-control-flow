from collections.abc import Iterator, Callable
from contextlib import contextmanager
from dataclasses import dataclass
from functools import partial
from typing import Any, Literal

from bolt import Runtime


def get_runtime_helpers() -> dict[str, Any]:
    return {
        "operator_and": partial(binary_logical, "and"),
        "operator_or": partial(binary_logical, "or"),
    }


@dataclass
class BinaryLogicalFallback:
    right: Any


@contextmanager
def single_if_statement(runtime: Runtime, condition: Any) -> Iterator[None]:
    """
    Reimplementation of the code that plain-bolt generates for an `if` statement

    See: bolt.codegen.Accumulator.if_statement
    """
    branch = runtime.helpers["branch"](condition)
    with branch as _bolt_condition:
        if _bolt_condition:
            yield


def binary_logical(
    op: Literal["and", "or"], runtime: Runtime, left: Any, right: Callable[[], Any]
) -> Any:
    ltype = type(left)
    if func := getattr(ltype, f"__logical_{op}__", None):
        match func(left, right):
            case BinaryLogicalFallback(fallback_right_value):
                # Matching standard Python behaviour for "reflected (swapped)" operators
                # For operands of the same type, it is assumed that if the non-reflected method fails then the overall operation is not supported, which is why the reflected method is not called.
                rtype = type(fallback_right_value)
                if ltype != rtype:
                    if func := getattr(rtype, f"__rlogical_{op}__", None):
                        match func(fallback_right_value, left):
                            case BinaryLogicalFallback():
                                # Avoid calling the original right function again
                                # Reuse existing value instead
                                right = lambda: fallback_right_value
                            case res:
                                return res
            case res:
                return res

    # Can only safely use __rlogical_{op}__ if left has __logical_{op}__
    # Otherwise short circuiting rules would be broken for standard Python values

    # Reimplementation of the code that plain-bolt generates for an `and` or `or` expression
    #
    # See: bolt.codegen.Codegen.binary_logical
    # TODO: Determine if there's a good way to wrap this such that __multibranch__ can still be utilised
    condition = runtime.helpers["operator_not"](left) if op == "or" else left
    dup = runtime.helpers["get_dup"](left)
    if dup is not None:
        left = dup()

    with single_if_statement(runtime, condition):
        right_value = right()

        if dup is not None:
            _bolt_rebind = runtime.helpers["get_rebind"](left)
            left = right_value
            if _bolt_rebind is not None:
                left = _bolt_rebind(left)
        else:
            left = right_value

    return left
