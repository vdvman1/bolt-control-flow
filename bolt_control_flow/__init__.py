__version__ = "0.0.0"


from beet import Context
from beet.contrib.load import load


def beet_default(ctx: Context):
    ctx.require(
        load(
            data_pack={
                "data/bolt_control_flow/modules": "@bolt_control_flow/modules",
            },
        ),
    )
