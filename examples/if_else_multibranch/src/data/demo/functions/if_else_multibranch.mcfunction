from contextlib import contextmanager
from dataclasses import dataclass
from typing import Iterator, Literal

from click import IntRange

from bolt_control_flow import Case, CaseResult, CasePartialResult, BranchInfo, BranchType, WrappedCases

from bolt_control_flow:test/helpers import log_say, log_block, test, IntRange

@dataclass(frozen=True)
class ScoreMatches:
    objective: str
    range: IntRange

    @contextmanager
    def __multibranch__(self, branch_info: BranchInfo) -> Iterator["ScoreCases"]:
        if branch_info.branch_type != BranchType.IF_ELSE:
            yield NotImplemented
            return
        
        parent = branch_info.parent_cases
        if isinstance(parent, WrappedCases):
            yield ScoreCases(self)
        else:
            execute function ctx.generate.format(~/ + "/if_else_{incr}"):
                yield ScoreCases(self)
    
    @contextmanager
    def __branch__(self) -> Iterator[Literal[True]]:
        # Could use self.range.to_tuple() instead of f"{self.range}", but the later will look nicer in the command
        if score @s self.objective matches f"{self.range}":
            yield True

    def __str__(self) -> str:
        return f"{self.objective}={self.range}"

@dataclass(frozen=True)
class ScoreCases(WrappedCases):
    matches: ScoreMatches

    @contextmanager
    def __case__(self, case: Case) -> Iterator[CasePartialResult]:
        if not isinstance(case, bool):
            yield NotImplemented
            return
        
        if case:
            # This is a Bolt if condition
            # WARNING: Be careful using Bolt if conditions inside condition implementations
            # In this case, by not using `else` this is reusing the __branch__ without needing to manully call it
            # If else was used, it would trigger infinite recursion
            if self.matches:
                # Would like to avoid this explicit function, but Bolt doesn't currently support implicit `return run`
                execute return run function ctx.generate.format(~/ + "/true_{incr}"):
                    yield CaseResult.maybe()
        else:
            # Condition has already been checked and returned early if it passed
            # So can just emit the false body
            yield CaseResult.maybe()

@test("if-else")
def if_else() -> None:
    if ScoreMatches("a", IntRange((None, 10))):
        say f"@s a matches ..10"
    else:
        say f"@s a doesn't match ..10 (either no value or matches 11..)"

@test("if-elif-else")
def if_elif_else() -> None:
    if ScoreMatches("a", IntRange((None, 10))):
        say f"@s a matches ..10"
    elif ScoreMatches("a", IntRange((11, 20))):
        say f"@s a matches 11..20"
    else:
        say f"@s a doesn't match ..20 (either no value or matches 21..)"