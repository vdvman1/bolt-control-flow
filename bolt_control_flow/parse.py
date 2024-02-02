from collections.abc import Generator
from dataclasses import dataclass
from bolt.ast import AstExpressionBinary
@dataclass(eq=False)
class Codegen(Dispatcher[Any]):
    @rule(AstExpressionBinary, operator="and")
    @rule(AstExpressionBinary, operator="or")
    def binary_logical(
        self, node: AstExpressionBinary, acc: Accumulator
    ) -> Generator[AstNode, Optional[list[str]], Optional[list[str]]]:
        left = yield from visit_single(node.left, required=True)
        lazy_right = acc.make_variable()
        with acc.function(lazy_right):
            right = yield from visit_single(node.right, required=True)
            acc.statement(f"return {right}")

        value = acc.helper(
            f"operator_{node.operator}", "_bolt_runtime", left, lazy_right
        )
        acc.statement(f"{left} = {value}")
        return [left]
