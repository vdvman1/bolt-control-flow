from contextlib import contextmanager
from typing import Generator
from typing_extensions import Self, Callable, Any, Literal

indent = 0
def log_say(msg: str) -> None:
    indented_msg = ("  " * indent) + msg
    say indented_msg
    print(indented_msg)

@contextmanager
def log_block(name: str) -> Generator[None, Any, None]:
    log_say(f"> {name}")
    global indent
    indent += 1
    yield
    indent -= 1
    log_say(f"< {name}")

class ConditionTest:
    _cond_count: int = ord('A')
    _dup_count: int = 1

    def condition(self) -> "LoggingCondition":
        idx = chr(self._cond_count)
        self._cond_count += 1
        return LoggingCondition(f"cond{idx}", self)
    
    def not_name(self, condition: "LoggingCondition") -> str:
        name = condition.name.removeprefix("cond")
        if name.startswith("not"):
            name = f"N{name[1:]}"
        
        return f"not{name}"

    def dup_name(self) -> str:
        idx = self._dup_count
        self._dup_count += 1
        return f"dup{idx}"

def test(name: str, enabled: bool = True) -> Callable[[Callable[[ConditionTest], Any]], None]:
    def decorator(test: Callable[[ConditionTest], Any]) -> None:
        if enabled:
            with log_block(name):
                test(ConditionTest())
        else:
            log_say(f"{name} (test disabled)")
        
        print()
        raw f" "

    return decorator

# TODO: Use actual condition class as base
class LoggingCondition:
    name: str
    test: ConditionTest

    def __init__(self, name: str, test: ConditionTest) -> None:
        self.name = name
        self.test = test
        log_say(f"{self.name}.__init__")

    def __not__(self) -> Self:
        with log_block(f"{self.name}.__not__"):
            return LoggingCondition(self.test.not_name(self), self.test)

    def __dup__(self) -> Self:
        with log_block(f"{self.name}.__dup__"):
            return LoggingCondition(self.test.dup_name(), self.test)

    def __rebind__(self, other: Self) -> Self:
        with log_block(f"{self.name}.__rebind__({other.name})"):
            return self

    @contextmanager
    def __branch__(self) -> Generator[Literal[True], Any, None]:
        with log_block(f"{self.name}.__branch__"):
            yield True


@test("if")
def just_if(test: ConditionTest):
    if test.condition():
        log_say("true")

@test("if-not")
def if_not(test: ConditionTest):
    if not test.condition():
        log_say("true")

@test("if-else")
def if_else(test: ConditionTest):
    if test.condition():
        log_say("true")
    else:
        log_say("false")

@test("if-not-else")
def if_not_else(test: ConditionTest):
    if not test.condition():
        log_say("true")
    else:
        log_say("false")

@test("if ... if not, same instance")
def if_if_not_same_instance(test: ConditionTest):
    log_say("Should be different from if-else")
    condA = test.condition()
    if condA:
        log_say("true")

    if not condA:
        log_say("false")

@test("if not ... if not, same instance")
def if_not_if_not_same_instance(test: ConditionTest):
    log_say("Should be different from if-not-else")
    condA = not test.condition()
    if condA:
        log_say("true")

    if not condA:
        log_say("false")

@test("if-and")
def if_and(test: ConditionTest):
    if test.condition() and test.condition():
        log_say("true")

@test("if-not-and")
def if_not_and(test: ConditionTest):
    if not (test.condition() and test.condition()):
        log_say("true")

@test("if-and2")
def if_and2(test: ConditionTest):
    if test.condition() and test.condition() and test.condition():
        log_say("true")

@test("if-and-else")
def if_and_else(test: ConditionTest):
    if test.condition() and test.condition():
        log_say("true")
    else:
        log_say("false")

@test("if-and2-else")
def if_and2_else(test: ConditionTest):
    if test.condition() and test.condition() and test.condition():
        log_say("true")
    else:
        log_say("false")

@test("if-and ... if not, same instance")
def if_and_if_not_same_instance(test: ConditionTest):
    log_say("should be different from if-and-else")
    cond = test.condition() and test.condition()
    if cond:
        log_say("true")

    if not cond:
        log_say("false")

@test("if-and2 ... if not, same instance")
def if_and2_if_not_same_instance(test: ConditionTest):
    log_say("should be different from if-and2-else")
    cond = test.condition() and test.condition() and test.condition()
    if cond:
        log_say("true")

    if not cond:
        log_say("false")

@test("if-or")
def if_or(test: ConditionTest):
    if test.condition() or test.condition():
        log_say("true")

@test("if-or2")
def if_or2(test: ConditionTest):
    if test.condition() or test.condition() or test.condition():
        log_say("true")

@test("if-or-else")
def if_or_else(test: ConditionTest):
    if test.condition() or test.condition():
        log_say("true")
    else:
        log_say("false")

@test("if-or2-else")
def if_or2_else(test: ConditionTest):
    if test.condition() or test.condition() or test.condition():
        log_say("true")
    else:
        log_say("false")

@test("if-or ... if not, same instance")
def if_or_if_not_same_instance(test: ConditionTest):
    log_say("should be different from if-or-else")
    cond = test.condition() or test.condition()
    if cond:
        log_say("true")

    if not cond:
        log_say("false")

@test("if-or2 ... if not, same instance")
def if_or2_if_not_same_instance(test: ConditionTest):
    log_say("should be different from if-or2-else")
    cond = test.condition() or test.condition() or test.condition()
    if cond:
        log_say("true")

    if not cond:
        log_say("false")
