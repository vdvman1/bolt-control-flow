__version__ = "0.0.0"


from beet import Context
from beet.contrib.load import load
from bolt import Runtime
from mecha import Rule

from bolt_control_flow.helpers import get_runtime_helpers
import bolt_control_flow.parse as parsers


def beet_default(ctx: Context):
    ctx.require(
        load(
            data_pack={
                "data/bolt_control_flow/modules": "@bolt_control_flow/modules",
            },
        ),
    )

    runtime = ctx.inject(Runtime)
    runtime.helpers.update(get_runtime_helpers())
    runtime.modules.codegen.extend(
        value
        for name in dir(parsers)
        if isinstance(value := getattr(parsers, name), Rule)
    )
