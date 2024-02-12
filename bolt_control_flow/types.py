from dataclasses import dataclass, field
from enum import Enum, auto
from types import NotImplementedType
from typing import Any, Optional, TypeAlias


__all__ = [
    "CaseResult",
    "CaseMatchType",
    "CasePartialResult",
    "Case",
    "BranchType",
    "BranchInfo",
    "BinaryLogicalFallback",
    "WrappedCases",
]


class CaseMatchType(Enum):
    """The status of a match"""

    FAILED = auto()
    """The match failed at build time"""

    MATCHED = auto()
    """The match succeeded at build time"""

    MAYBE = auto()
    """Whether the match passed isn't known until runtime"""

    def __bool__(self) -> bool:
        return self != CaseMatchType.FAILED


@dataclass
class CaseResult:
    """Information about a match"""

    match_type: CaseMatchType
    """The match status"""

    bindings: dict[str, Any] = field(default_factory=dict)
    """Any bindings to be assigned in the condition caller's scope

    Must contain all the bindings that the case pattern is expecting, and any extra bindings will be ignored
    
    Note:
        If :py:attr:`match_type` is :py:const:`CaseMatchType.FAILED` these bindings will be ignored
    """

    @staticmethod
    def failed() -> "CaseResult":
        """:python:`yield` this value to indicate that the match failed at build time"""
        return CaseResult(CaseMatchType.FAILED)

    @staticmethod
    def matched(**bindings: Any) -> "CaseResult":
        """:python:`yield` this value to indicate that the match passed at build time and run the body of the condition

        Args:
            **bindings: The bindings to be assigned in the condition caller's scope
        """
        return CaseResult(CaseMatchType.MATCHED, bindings)

    @staticmethod
    def maybe(**bindings: Any) -> "CaseResult":
        """:python:`yield` this value to indicate that the match can't be determined until runtime

        It is expected for the runtime check to wrap the :python:`yield`,
        so that running the body of the condition will be wrapped in the check

        Args:
            **bindings: The bindings to be assigned in the condition caller's scope
        """
        return CaseResult(CaseMatchType.MAYBE, bindings)

    @dataclass
    class Codegen:
        """Helpers for generating code for accessing members of :py:class:`CaseResult`

        Danger:
            This is an internal helper, not meant for public usage
        """

        name: str
        """Name of the variable holding this :py:class:`CaseResult`"""

        @property
        def match_type(self) -> str:
            """Generate code for accessing the :py:attr:`~CaseResult.match_type`"""
            return f"{self.name}.match_type"

        def binding(self, binding: str) -> str:
            """Generate code for accessing the given binding in the :py:attr:`~CaseResult.bindings`"""
            return f'{self.name}.bindings["{binding}"]'


CasePartialResult: TypeAlias = CaseResult | NotImplementedType


# TODO: more specific type for case object when representing match cases
Case: TypeAlias = bool | Any


class BranchType(Enum):
    IF_ELSE = auto()
    MATCH = auto()

    @property
    def helper(self) -> str:
        return f"multibranch_{self.name}"


@dataclass(frozen=True)
class BranchInfo:
    branch_type: BranchType
    parent_cases: Optional[Any]


@dataclass
class BinaryLogicalFallback:
    right: Any


class WrappedCases:
    """Marker class to indicate that it is safe for nested conditions to use return without making new functions

    i.e. there are no commands after the cases that must be run
    """
