from functools import partial
from bolt import Runtime

from bolt_control_flow.types import (
    BinaryLogicalFallback,
)


def get_runtime_helpers() -> dict[str, Any]:
    return {
        "operator_and": partial(binary_logical, "and"),
        "operator_or": partial(binary_logical, "or"),
    }


def call_branch(condition: Any, runtime: Runtime) -> AbstractContextManager[Any]:
    return runtime.helpers["branch"](condition)


def call_not(condition: Any, runtime: Runtime) -> Any:
    return runtime.helpers["operator_not"](condition)


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
    condition = call_not(left, runtime) if op == "or" else left
    dup = runtime.helpers["get_dup"](left)
    if dup is not None:
        left = dup()

    with call_branch(condition, runtime) as _bolt_condition:
        if _bolt_condition:
            right_value = right()

            if dup is not None:
                _bolt_rebind = runtime.helpers["get_rebind"](left)
                left = right_value
                if _bolt_rebind is not None:
                    left = _bolt_rebind(left)
            else:
                left = right_value

    return left
