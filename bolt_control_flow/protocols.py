"""Protocols for documenting the multibranch case interface, and for optional static analysis to help ensure types implement the interface appropriately"""

from contextlib import AbstractContextManager
from typing import Any, Protocol


class CaseProtocol(Protocol):
    pass


class InverseProtocol(Protocol):
    def __not__(self) -> Any:
        """
        Get the inverse of a value, i.e. `not value`

        Should be a truthy value, falsy value, or AnyBranchProtocol value, representing the inverse of self
        """
        ...


class BranchProtocol(InverseProtocol, Protocol):
    """
    The plain-bolt protocol for overriding branching behaviour.

    This is used as a fallback when the MultiBranchProtocol isn't implemented for a given value
    """

    def __branch__(self) -> AbstractContextManager[Any]:
        """
        Context manager for overriding the behaviour of conditions.

        Should wrap the body with a runtime condition. Yield a truthy value to run the body, and yield a falsy value to prevent the body from running.
        """
        ...


class MultiBranchProtocol(InverseProtocol, Protocol):
    def __multibranch__(self) -> AbstractContextManager[CaseProtocol]:
        """
        Context manager for handling a condition with multiple cases.

        This will be called for `if ... else` and for `match`, but not for `if` without an `else`
        """
        ...

    def __branch__(self) -> AbstractContextManager[Any]:
        """
        Context manager for handling a condition with a single case.

        This will be called for `if` without an `else`
        """
        ...


AnyBranchProtocol = BranchProtocol | MultiBranchProtocol
