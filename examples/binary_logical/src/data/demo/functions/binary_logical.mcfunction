from collections.abc import Callable, Iterator
from contextlib import contextmanager
from dataclasses import dataclass
from typing import Any, Literal, Optional

from bolt_control_flow.helpers import BinaryLogicalFallback
from bolt_control_flow:test/helpers import log_say, log_block, test

RangeTuple = tuple[Optional[int], Optional[int]]

min_int32 = -(2**31)
max_int32 = (2**31) - 1

@dataclass(frozen=True)
class IntRange:
    min: int
    max: int

    def __init__(self, value: int | RangeTuple) -> None:
        if isinstance(value, int):
            object.__setattr__(self, "min", value)
            object.__setattr__(self, "max", value)
        else:
            min, max = value
            if min is None:
                min = min_int32
            
            if max is None:
                max = max_int32
            object.__setattr__(self, "min", min)
            object.__setattr__(self, "max", max)

    def intersect(self, other: "IntRange") -> Optional["IntRange"]:
        if other.min > self.max or self.min > other.max:
            return None

        return IntRange((max(self.min, other.min), min(self.max, other.max)))

    def to_tuple(self) -> RangeTuple:
        return (self.min, self.max)

    def __str__(self) -> str:
        min = self.min
        max = self.max

        if min == max:
            return str(min)

        if min == min_int32:
            if max == max_int32:
                # Minecraft doesn't allow ".." for omitting both endpoints
                return f"{min}.."
            else:
                return f"..{max}"
        elif max == max_int32:
            return f"{min}.."
        else:
            return f"{min}..{max}"


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
                return MultipleScoresMatch((self, other))
        elif isinstance(other, MultipleScoresMatch):
            # This case could technically be covered by __rlogical_and__ on MultipleScoresMatch
            # However handling this explicitly would be more efficient
            return other.intersect(self)
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
class MultipleScoresMatch:
    # Using a tuple rather than a dict to avoid mutation
    matches: tuple[ScoreMatches, ...]

    def intersect(
        self, other: "ScoreMatches | MultipleScoresMatch"
    ) -> Optional["MultipleScoresMatch"]:
        if isinstance(other, ScoreMatches):
            ranges = {other.objective: other.range}
        else:
            # Function to work around the lack of comprehension support in Bolt
            def range_mapping():
                for match in other.matches:
                    yield (match.objective, match.range)
            ranges = dict(range_mapping())

        def process_matches():
            for match in self.matches:
                range = ranges.get(match.objective)
                if range:
                    new = match.intersect(range)
                    if new:
                        yield new
                    # if intersection was empty, don't yield, i.e. remove from tuple
                else:
                    yield match

        new_ranges = tuple(process_matches())
        if new_ranges:
            return MultipleScoresMatch(new_ranges)
        else:
            return None

    def __logical_and__(self, lazy_other: Callable[[], Any]) -> Any:
        other = lazy_other()
        if isinstance(other, (ScoreMatches, MultipleScoresMatch)):
            return self.intersect(other)
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
            if entity f"@s[scores={self}]":
                yield True

    def __str__(self) -> str:
        # Function to work around the lack of comprehension support in Bolt
        def matches_str() -> Iterator[str]:
            for match in self.matches:
                yield str(match)

        return '{' + ','.join(matches_str()) + '}'


@test("if, and 1, same objective, intersecting ranges")
def and1_same_objective_intersecting_ranges() -> None:
    a = ScoreMatches("test", IntRange((10, None)))
    b = a.with_range(IntRange((None, 20)))
    if a and b:
        say f"`@s test` is in range 10..20"
