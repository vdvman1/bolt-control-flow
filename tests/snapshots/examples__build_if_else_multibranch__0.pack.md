# Lectern snapshot

## Data pack

`@data_pack pack.mcmeta`

```json
{
  "pack": {
    "min_format": [
      94,
      1
    ],
    "max_format": [
      94,
      1
    ],
    "description": ""
  }
}
```

### demo

`@function demo:if_else_multibranch`

```mcfunction
say > if-else
function demo:if_else_multibranch/if_else_0
say < if-else
 
say > if-elif-else
function demo:if_else_multibranch/if_else_1
say < if-elif-else
 
```

`@function demo:if_else_multibranch/if_else_0/true_0`

```mcfunction
say @s a matches ..10
```

`@function demo:if_else_multibranch/if_else_0`

```mcfunction
execute if score @s a matches ..10 run return run function demo:if_else_multibranch/if_else_0/true_0
say @s a doesn't match ..10 (either no value or matches 11..)
```

`@function demo:if_else_multibranch/if_else_1/true_0`

```mcfunction
say @s a matches ..10
```

`@function demo:if_else_multibranch/if_else_1/true_1`

```mcfunction
say @s a matches 11..20
```

`@function demo:if_else_multibranch/if_else_1`

```mcfunction
execute if score @s a matches ..10 run return run function demo:if_else_multibranch/if_else_1/true_0
execute if score @s a matches 11..20 run return run function demo:if_else_multibranch/if_else_1/true_1
say @s a doesn't match ..20 (either no value or matches 21..)
```
