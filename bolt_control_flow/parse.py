from collections.abc import Generator
from typing import Optional
from bolt import Accumulator, visit_single
from mecha import AstNode, rule
from bolt.ast import AstExpressionBinary


@rule(AstExpressionBinary, operator="and")
@rule(AstExpressionBinary, operator="or")
def binary_logical(
    node: AstExpressionBinary, acc: Accumulator
) -> Generator[AstNode, Optional[list[str]], Optional[list[str]]]:
    left = yield from visit_single(node.left, required=True)
    lazy_right = acc.make_variable()
    with acc.function(lazy_right):
        right = yield from visit_single(node.right, required=True)
        acc.statement(f"return {right}")

    value = acc.helper(f"operator_{node.operator}", "_bolt_runtime", left, lazy_right)
    acc.statement(f"{left} = {value}")
    return [left]
