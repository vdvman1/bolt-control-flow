from collections.abc import Callable, Iterator
from contextlib import contextmanager
from dataclasses import dataclass
from typing import Any, Literal, Optional

from mecha import Mecha

from bolt_control_flow import BinaryLogicalFallback
from bolt_control_flow:test/helpers import log_say, log_block, test, IntRange

mc: Mecha = ctx.inject(Mecha)


@dataclass(frozen=True)
class ScoreMatches:
    objective: str
    range: IntRange

    def intersect(self, range: IntRange) -> Optional["ScoreMatches"]:
        new_range = range.intersect(self.range)
        if new_range:
            return ScoreMatches(self.objective, new_range)
        else:
            return None

    def with_range(self, range: IntRange) -> "ScoreMatches":
        return ScoreMatches(self.objective, range)

    def __logical_and__(self, lazy_other: Callable[[], Any]) -> Any:
        other = lazy_other()
        if isinstance(other, ScoreMatches):
            if other.objective == self.objective:
                return self.intersect(other.range)
            else:
                return ScoresAnd((self, other))
        elif isinstance(other, ScoresAnd):
            # This case could technically be covered by __rlogical_and__ on ScoresAnd
            # However handling this explicitly would be more efficient
            return other.intersect(self)
        elif isinstance(other, ScoresOr):
            return ScoresAnd((self, other))
        else:
            return BinaryLogicalFallback(other)
    
    def __logical_or__(self, lazy_other: Callable[[], Any]) -> Any:
        other = lazy_other()
        if isinstance(other, (ScoreMatches, ScoresAnd)):
            return ScoresOr((self, other))
        else:
            return BinaryLogicalFallback(other)

    @contextmanager
    def __branch__(self) -> Iterator[Literal[True]]:
        # Could use self.range.to_tuple() instead of f"{self.range}", but the later will look nicer in the command
        if score @s self.objective matches f"{self.range}":
            yield True

    def __str__(self) -> str:
        return f"{self.objective}={self.range}"


@dataclass(frozen=True)
class ScoresAnd:
    # Using a tuple rather than a dict to avoid mutation
    matches: tuple["ScoreMatches | ScoresOr", ...]

    def intersect(
        self, other: "ScoreMatches | ScoresAnd"
    ) -> Optional["ScoresAnd"]:
        if isinstance(other, ScoreMatches):
            ranges = {other.objective: other.range}
        else:
            # Function to work around the lack of comprehension support in Bolt
            def range_mapping():
                for match in other.matches:
                    if isinstance(match, ScoreMatches):
                        yield (match.objective, match.range)
            ranges = dict(range_mapping())

        new_matches: list[ScoreMatches | ScoresOr] = []

        for match in self.matches:
            if isinstance(match, ScoresOr):
                new_matches.append(match)
                continue

            range = ranges.get(match.objective)
            if range:
                new = match.intersect(range)
                if new:
                    new_matches.append(new)
                else:
                    # If the intersection was empty, then the result is guaranteed to be false
                    return None
            else:
                new_matches.append(match)

        return ScoresAnd(tuple(new_matches))

    def __logical_and__(self, lazy_other: Callable[[], Any]) -> Any:
        other = lazy_other()
        if isinstance(other, (ScoreMatches, ScoresAnd)):
            return self.intersect(other)
        elif isinstance(other, ScoresOr):
            return ScoresAnd(self.matches + (other,))
        else:
            return BinaryLogicalFallback(other)
    
    def __logical_or__(self, lazy_other: Callable[[], Any]) -> Any:
        other = lazy_other()
        if isinstance(other, (ScoreMatches, ScoresAnd)):
            return ScoresOr((self, other))
        else:
            return BinaryLogicalFallback(other)

    @contextmanager
    def __branch__(self) -> Iterator[bool]:
        count = len(self.matches)

        if count == 0:
            yield False
        elif count == 1:
            # Manually forward to ScoreMatches.__branch__ to avoid duplicating logic
            with self.matches[0].__branch__() as success:
                yield success
        else:
            scores_and: list[ScoreMatches] = []

            # TODO: Create general helper for running nested conditions recursively
            @contextmanager
            def recurse(i: int) -> Iterator[bool]:
                scores_and.clear()
                while i < len(self.matches):
                    score_matches = self.matches[i]

                    if isinstance(score_matches, ScoreMatches):
                        scores_and.append(score_matches)
                        i += 1
                    else:
                        break
                
                count = len(scores_and)
                if count == 1:
                    with scores_and[0].__branch__() as success:
                        yield success
                elif count > 1:
                    # function to work around the lack of comprehensions in Bolt
                    def str_scores() -> Iterator[str]:
                        for score_matches in scores_and:
                            yield str(score_matches)

                    if entity mc.parse("@s[scores={" + ','.join(str_scores()) + "}]", using="selector"):
                        with recurse(i) as success:
                            yield success
                elif i < len(self.matches):
                    scores_or = self.matches[i]
                    if not isinstance(scores_or, ScoresOr):
                        raise TypeError("scores_or must be a ScoresOr")
                    
                    with scores_or.__branch__() as success:
                        if success:
                            with recurse(i + 1) as nested_success:
                                yield nested_success
                        else:
                            yield False
                else:
                    yield True
            
            with recurse(0) as success:
                yield success

@dataclass(frozen=True)
class ScoresOr:
    # Using a tuple rather than a list to avoid mutation
    matches: tuple[ScoreMatches | ScoresAnd, ...]

    def __logical_and__(self, lazy_other: Callable[[], Any]) -> Any:
        other = lazy_other()
        if isinstance(other, (ScoreMatches, ScoresOr)):
            return ScoresAnd((self, other))
        elif isinstance(other, ScoresAnd):
            # This case could technically be covered by __rlogical_and__ on ScoresAnd
            # However handling this explicitly would be more efficient
            return ScoresAnd((self,) + other.matches)
        else:
            return BinaryLogicalFallback(other)
        
    def __logical_or__(self, lazy_other: Callable[[], Any]) -> Any:
        other = lazy_other()
        if isinstance(other, (ScoreMatches, ScoresAnd)):
            return ScoresOr(self.matches + (other,))
        elif isinstance(other, ScoresOr):
            return ScoresOr(self.matches + other.matches)
        else:
            return BinaryLogicalFallback(other)

    def __rlogical_or__(self, other: Any) -> Any:
        if isinstance(other, (ScoreMatches, ScoresAnd)):
            # Would be more efficient to handle this in ScoreMatches and MultipleScoresMatch
            # But doing it here to show how __rlogical_or__ is used
            # This also avoids code repetition and keeps the OR logic contained to ScoresOr
            return ScoresOr((other, ) + self.matches)
        else:
            return BinaryLogicalFallback(other)

    @contextmanager
    def __branch__(self) -> Iterator[bool]:
        count = len(self.matches)

        if count == 0:
            yield True
        elif count == 1:
            # Manually forward to avoid duplicating logic
            with self.matches[0].__branch__() as success:
                yield success
        else:
            name = ctx.generate.format(~/ + "/or_{incr}")
            function name:
                for condition in self.matches:
                    # This is a Bolt if check
                    if condition:
                        execute return 1
            
            if function name:
                yield True

@test("if, and 1, same objective, intersecting ranges")
def and1_same_objective_intersecting_ranges() -> None:
    a = ScoreMatches("test", IntRange((10, None)))
    if a and a.with_range(IntRange((None, 20))):
        say f"`@s test` is in range 10..20"


@test("if, and 1, different objectives")
def and1_different_objectives() -> None:
    if ScoreMatches("a", IntRange((10, None))) and ScoreMatches("b", IntRange((None, 20))):
        say f"@s a matches 10.. and @s b matches ..20"

@test("if, or 1")
def or1() -> None:
    if ScoreMatches("a", IntRange((10, None))) or ScoreMatches("b", IntRange((None, 20))):
        say f"@s a matches 10.. or @s b matches ..20"

@test("if, or 2")
def or2() -> None:
    if ScoreMatches("a", IntRange((10, None))) or ScoreMatches("b", IntRange((None, 20))) or ScoreMatches("b", IntRange(30)):
        say f"@s a matches 10.. or @s b matches ..20 or @s b matches 30"

@test("if, (and 1) or 1")
def and1_or1() -> None:
    if (ScoreMatches("a", IntRange((10, None))) and ScoreMatches("b", IntRange((None, 20)))) or ScoreMatches("b", IntRange(30)):
        say f"(@s a matches 10.. and @s b matches ..20) or @s b matches 30"

@test("if, (or 1) and 1")
def or1_and1() -> None:
    if (ScoreMatches("a", IntRange((10, None))) or ScoreMatches("b", IntRange((None, 20)))) and ScoreMatches("c", IntRange(30)):
        say f"(@s a matches 10.. or @s b matches ..20) and @s c matches 30"