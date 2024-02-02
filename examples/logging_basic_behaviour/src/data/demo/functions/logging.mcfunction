from contextlib import contextmanager
from typing import Generator
from typing_extensions import Any, Literal

from bolt_control_flow:test/helpers import log_say, log_block, test


class ConditionTest:
    _cond_count: int = ord("A")
    _dup_count: int = 1

    def condition(self) -> "LoggingCondition":
        idx = chr(self._cond_count)
        self._cond_count += 1
        return LoggingCondition(f"cond{idx}", self)

    def not_name(self, condition: "LoggingCondition") -> str:
        name = condition.name
        if name.startswith("cond"):
            name = name[len("cond") :]
        else:
            start = name[0].upper()
            name = start + name[1:]

        return f"not{name}"

    def dup_name(self) -> str:
        idx = self._dup_count
        self._dup_count += 1
        return f"dup{idx}"


# TODO: Use actual condition class as base
class LoggingCondition:
    name: str
    test: ConditionTest

    def __init__(self, name: str, test: ConditionTest) -> None:
        self.name = name
        self.test = test
        log_say(f"{self.name}.__init__")

    def __not__(self) -> "LoggingCondition":
        with log_block(f"{self.name}.__not__"):
            return LoggingCondition(self.test.not_name(self), self.test)

    def __dup__(self) -> "LoggingCondition":
        with log_block(f"{self.name}.__dup__"):
            return LoggingCondition(self.test.dup_name(), self.test)

    def __rebind__(self, other: "LoggingCondition", /) -> "LoggingCondition":
        log_say(f"{self.name}.__rebind__({other.name})")
        return self

    @contextmanager
    def __branch__(self) -> Generator[Literal[True], Any, None]:
        with log_block(f"{self.name}.__branch__"):
            yield True


@test("if", enabled=True)
def just_if():
    test = ConditionTest()
    if test.condition():
        log_say("true")

    if False:
        # Simplified codegen
        condA = test.condition()
        with condA.__branch__() as success:
            if success:
                log_say("true")


@test("if-not", enabled=True)
def if_not():
    test = ConditionTest()
    if not test.condition():
        log_say("true")

    if False:
        # Simplified codegen
        condA = test.condition()
        notA = condA.__not__()

        with notA.__branch__() as success:
            if success:
                log_say("true")


@test("if-else", enabled=True)
def if_else():
    test = ConditionTest()
    if test.condition():
        log_say("true")
    else:
        log_say("false")

    if False:
        # Simplified codegen
        condA = test.condition()
        notA = condA.__not__()
        with condA.__branch__() as success:
            if success:
                log_say("true")

        with notA.__branch__() as success:
            if success:
                log_say("false")


@test("if-not-else", enabled=True)
def if_not_else():
    test = ConditionTest()
    if not test.condition():
        log_say("true")
    else:
        log_say("false")

    if False:
        # Simplified codegen
        condA = test.condition()
        notA = condA.__not__()
        notNotA = notA.__not__()

        with notA.__branch__() as success:
            if success:
                log_say("true")

        with notNotA.__branch__() as success:
            if success:
                log_say("false")


@test("if ... if not, same instance", enabled=True)
def if_if_not_same_instance():
    test = ConditionTest()
    log_say("Should be different from if-else")
    condA = test.condition()
    if condA:
        log_say("true")

    if not condA:
        log_say("false")

    if False:
        # Simplified codegen
        condA = test.condition()
        with condA.__branch__() as success:
            if success:
                log_say("true")

        notA = condA.__not__()
        with notA.__branch__() as success:
            if success:
                log_say("false")


@test("if not ... if not, same instance", enabled=True)
def if_not_if_not_same_instance():
    test = ConditionTest()
    log_say("Should be different from if-not-else")
    condA = not test.condition()
    if condA:
        log_say("true")

    if not condA:
        log_say("false")

    if False:
        # Simplified codegen
        condA = test.condition()
        notA = condA.__not__()

        with notA.__branch__() as success:
            if success:
                log_say("true")

        notNotA = notA.__not__()
        with notNotA.__branch__() as success:
            if success:
                log_say("false")


@test("if-and", enabled=True)
def if_and():
    test = ConditionTest()
    if test.condition() and test.condition():
        log_say("true")

    if False:
        # Simplified codegen
        condA = test.condition()
        dup1 = condA.__dup__()
        with condA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        with dup1.__branch__() as success:
            if success:
                log_say("true")


@test("if-not-and", enabled=True)
def if_not_and():
    test = ConditionTest()
    if not (test.condition() and test.condition()):
        log_say("true")

    if False:
        # Simplified codegen
        condA = test.condition()
        dup1 = condA.__dup__()

        with condA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        notDup1 = dup1.__not__()
        with notDup1.__branch__() as success:
            if success:
                log_say("true")


@test("if-and-else", enabled=True)
def if_and_else():
    test = ConditionTest()
    if test.condition() and test.condition():
        log_say("true")
    else:
        log_say("false")

    if False:
        # Simplified codegen
        condA = test.condition()
        dup1 = condA.__dup__()

        with condA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        notDup1 = dup1.__not__()
        with dup1.__branch__() as success:
            if success:
                log_say("true")

        with notDup1.__branch__() as success:
            if success:
                log_say("false")


@test("if-not-and-else", enabled=True)
def if_not_and_else():
    test = ConditionTest()
    if not (test.condition() and test.condition()):
        log_say("true")
    else:
        log_say("false")

    if False:
        # Simplified codegen
        condA = test.condition()
        dup1 = condA.__dup__()

        with condA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        notDup1 = dup1.__not__()
        notNotDup1 = notDup1.__not__()
        with notDup1.__branch__() as success:
            if success:
                log_say("true")

        with notNotDup1.__branch__() as success:
            if success:
                log_say("false")


@test("if-and ... if not, same instance", enabled=True)
def if_and_if_not_same_instance():
    test = ConditionTest()
    log_say("should be different from if-and-else")
    cond = test.condition() and test.condition()
    if cond:
        log_say("true")

    if not cond:
        log_say("false")

    if False:
        # Simplified codegen
        condA = test.condition()
        dup1 = condA.__dup__()

        with condA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        with dup1.__branch__() as success:
            if success:
                log_say("true")

        notDup1 = dup1.__not__()
        with notDup1.__branch__() as success:
            if success:
                log_say("false")


@test("if not and ... if not, same instance", enabled=True)
def if_not_and_if_not_same_instance():
    test = ConditionTest()
    log_say("Should be different from if-not-and-else")
    condA = not (test.condition() and test.condition())
    if condA:
        log_say("true")

    if not condA:
        log_say("false")

    if False:
        # Simplified codegen
        condA = test.condition()
        dup1 = condA.__dup__()

        with condA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        notDup1 = dup1.__not__()
        with notDup1.__branch__() as success:
            if success:
                log_say("true")

        notNotDup1 = notDup1.__not__()
        with notNotDup1.__branch__() as success:
            if success:
                log_say("false")


@test("if-and2", enabled=True)
def if_and2():
    test = ConditionTest()
    if test.condition() and test.condition() and test.condition():
        log_say("true")

    if False:
        # Simplified codegen
        condA = test.condition()
        dup1 = condA.__dup__()
        with condA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        dup2 = dup1.__dup__()
        with dup1.__branch__() as success:
            if success:
                condC = test.condition()
                dup2 = dup2.__rebind__(condC)

        with dup2.__branch__() as success:
            if success:
                log_say("true")


@test("if-not-and2", enabled=True)
def if_not_and2():
    test = ConditionTest()
    if not (test.condition() and test.condition() and test.condition()):
        log_say("true")

    if False:
        # Simplified codegen
        condA = test.condition()
        dup1 = condA.__dup__()

        with condA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        dup2 = dup1.__dup__()
        with dup1.__branch__() as success:
            if success:
                condC = test.condition()
                dup2 = dup2.__rebind__(condC)

        notDup2 = dup2.__not__()
        with notDup2.__branch__() as success:
            if success:
                log_say("true")


@test("if-and2-else", enabled=True)
def if_and2_else():
    test = ConditionTest()
    if test.condition() and test.condition() and test.condition():
        log_say("true")
    else:
        log_say("false")

    if False:
        # Simplified codegen
        condA = test.condition()
        dup1 = condA.__dup__()

        with condA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        dup2 = dup1.__dup__()
        with dup1.__branch__() as success:
            if success:
                condC = test.condition()
                dup2 = dup2.__rebind__(condC)

        notDup2 = dup2.__not__()
        with dup2.__branch__() as success:
            if success:
                log_say("true")

        with notDup2.__branch__() as success:
            if success:
                log_say("false")


@test("if-not-and2-else", enabled=True)
def if_not_and2_else():
    test = ConditionTest()
    if not (test.condition() and test.condition() and test.condition()):
        log_say("true")
    else:
        log_say("false")

    if False:
        # Simplified codegen
        condA = test.condition()
        dup1 = condA.__dup__()

        with condA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        dup2 = dup1.__dup__()
        with dup1.__branch__() as success:
            if success:
                condC = test.condition()
                dup2 = dup2.__rebind__(condC)

        notDup2 = dup2.__not__()
        notNotDup2 = notDup2.__not__()
        with notDup2.__branch__() as success:
            if success:
                log_say("true")

        with notNotDup2.__branch__() as success:
            if success:
                log_say("false")


@test("if-and2 ... if not, same instance", enabled=True)
def if_and2_if_not_same_instance():
    test = ConditionTest()
    log_say("should be different from if-and2-else")
    cond = test.condition() and test.condition() and test.condition()
    if cond:
        log_say("true")

    if not cond:
        log_say("false")

    if False:
        condA = test.condition()
        dup1 = condA.__dup__()

        with condA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        dup2 = dup1.__dup__()
        with dup1.__branch__() as success:
            if success:
                condC = test.condition()
                dup2 = dup2.__rebind__(condC)

        with dup2.__branch__() as success:
            if success:
                log_say("true")

        notDup2 = dup2.__not__()
        with notDup2.__branch__() as success:
            if success:
                log_say("false")


@test("if not and2 ... if not, same instance", enabled=True)
def if_not_and2_if_not_same_instance():
    test = ConditionTest()
    log_say("Should be different from if-not-and2-else")
    condA = not (test.condition() and test.condition() and test.condition())
    if condA:
        log_say("true")

    if not condA:
        log_say("false")

    if False:
        # Simplified codegen
        condA = test.condition()
        dup1 = condA.__dup__()

        with condA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        dup2 = dup1.__dup__()
        with dup1.__branch__() as success:
            if success:
                condC = test.condition()
                dup2 = dup2.__rebind__(condC)

        notDup2 = dup2.__not__()
        with notDup2.__branch__() as success:
            if success:
                log_say("true")

        notNotDup2 = notDup2.__not__()
        with notNotDup2.__branch__() as success:
            if success:
                log_say("false")


@test("if-or", enabled=True)
def if_or():
    test = ConditionTest()
    if test.condition() or test.condition():
        log_say("true")

    if False:
        # Simplified codegen
        condA = test.condition()
        notA = condA.__not__()
        dup1 = condA.__dup__()

        with notA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        with dup1.__branch__() as success:
            if success:
                log_say("true")


@test("if-not-or", enabled=True)
def if_not_or():
    test = ConditionTest()
    if not (test.condition() or test.condition()):
        log_say("true")

    if False:
        # Simplified codegen
        condA = test.condition()
        notA = condA.__not__()
        dup1 = condA.__dup__()

        with notA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        notDup1 = dup1.__not__()
        with notDup1.__branch__() as success:
            if success:
                log_say("true")


@test("if-or-else", enabled=True)
def if_or_else():
    test = ConditionTest()
    if test.condition() or test.condition():
        log_say("true")
    else:
        log_say("false")

    if False:
        # Simplified codegen
        condA = test.condition()
        notA = condA.__not__()
        dup1 = condA.__dup__()

        with notA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        notDup1 = dup1.__not__()
        with dup1.__branch__() as success:
            if success:
                log_say("true")

        with notDup1.__branch__() as success:
            if success:
                log_say("false")


@test("if-not-or-else", enabled=True)
def if_not_or_else():
    test = ConditionTest()
    if not (test.condition() or test.condition()):
        log_say("true")
    else:
        log_say("false")

    if False:
        # Simplified codegen
        condA = test.condition()
        notA = condA.__not__()
        dup1 = condA.__dup__()

        with notA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        notDup1 = dup1.__not__()
        notNotDup1 = notDup1.__not__()
        with notDup1.__branch__() as success:
            if success:
                log_say("true")

        with notNotDup1.__branch__() as success:
            if success:
                log_say("false")


@test("if-or ... if not, same instance", enabled=True)
def if_or_if_not_same_instance():
    test = ConditionTest()
    log_say("should be different from if-or-else")
    cond = test.condition() or test.condition()
    if cond:
        log_say("true")

    if not cond:
        log_say("false")

    if False:
        # Simplified codegen
        condA = test.condition()
        notA = condA.__not__()
        dup1 = condA.__dup__()

        with notA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        with dup1.__branch__() as success:
            if success:
                log_say("true")

        notDup1 = dup1.__not__()
        with notDup1.__branch__() as success:
            if success:
                log_say("false")


@test("if-not-or ... if not, same instance", enabled=True)
def if_not_or_if_not_same_instance():
    test = ConditionTest()
    log_say("should be different from if-not-or-else")
    cond = not (test.condition() or test.condition())
    if cond:
        log_say("true")

    if not cond:
        log_say("false")

    if False:
        # Simplified codegen
        condA = test.condition()
        notA = condA.__not__()
        dup1 = condA.__dup__()

        with notA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        notDup1 = dup1.__not__()
        with notDup1.__branch__() as success:
            if success:
                log_say("true")

        notNotDup1 = notDup1.__not__()
        with notNotDup1.__branch__() as success:
            if success:
                log_say("false")


@test("if-or2", enabled=True)
def if_or2():
    test = ConditionTest()
    if test.condition() or test.condition() or test.condition():
        log_say("true")

    if False:
        # Simplified codegen
        condA = test.condition()
        notA = condA.__not__()
        dup1 = condA.__dup__()

        with notA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        notDup1 = dup1.__not__()
        dup2 = dup1.__dup__()
        with notDup1.__branch__() as success:
            if success:
                condC = test.condition()
                dup2 = dup2.__rebind__(condC)

        with dup2.__branch__() as success:
            if success:
                log_say("true")


@test("if-not-or2", enabled=True)
def if_not_or2():
    test = ConditionTest()
    if not (test.condition() or test.condition() or test.condition()):
        log_say("true")

    if True:
        # Simplified codegen
        condA = test.condition()
        notA = condA.__not__()
        dup1 = condA.__dup__()

        with notA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        notDup1 = dup1.__not__()
        dup2 = dup1.__dup__()
        with notDup1.__branch__() as success:
            if success:
                log_say("true")


@test("if-or2-else", enabled=True)
def if_or2_else():
    test = ConditionTest()
    if test.condition() or test.condition() or test.condition():
        log_say("true")
    else:
        log_say("false")

    if False:
        # Simplified codegen
        condA = test.condition()
        notA = condA.__not__()
        dup1 = condA.__dup__()

        with notA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        notDup1 = dup1.__not__()
        dup2 = dup1.__dup__()
        with notDup1.__branch__() as success:
            if success:
                condC = test.condition()
                dup2 = dup2.__rebind__(condC)

        notDup2 = dup2.__not__()
        with dup2.__branch__() as success:
            if success:
                log_say("true")

        with notDup2.__branch__() as success:
            if success:
                log_say("false")


@test("if-or2 ... if not, same instance", enabled=True)
def if_or2_if_not_same_instance():
    test = ConditionTest()
    log_say("should be different from if-or2-else")
    cond = test.condition() or test.condition() or test.condition()
    if cond:
        log_say("true")

    if not cond:
        log_say("false")

    if False:
        # Simplified codegen
        condA = test.condition()
        notA = condA.__not__()
        dup1 = condA.__dup__()

        with notA.__branch__() as success:
            if success:
                condB = test.condition()
                dup1 = dup1.__rebind__(condB)

        notDup1 = dup1.__not__()
        dup2 = dup1.__dup__()
        with notDup1.__branch__() as success:
            if success:
                condC = test.condition()
                dup2 = dup2.__rebind__(condC)

        with dup2.__branch__() as success:
            if success:
                log_say("true")

        notDup2 = dup2.__not__()
        with notDup2.__branch__() as success:
            if success:
                log_say("false")
