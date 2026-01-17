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

`@function demo:binary_logical`

```mcfunction
say > if, and 1, same objective, intersecting ranges
execute if score @s test matches 10..20 run say `@s test` is in range 10..20
say < if, and 1, same objective, intersecting ranges
 
say > if, and 1, different objectives
execute if entity @s[scores={a=10.., b=..20}] run say @s a matches 10.. and @s b matches ..20
say < if, and 1, different objectives
 
say > if, or 1
execute if function demo:binary_logical/or_0 run say @s a matches 10.. or @s b matches ..20
say < if, or 1
 
say > if, or 2
execute if function demo:binary_logical/or_1 run say @s a matches 10.. or @s b matches ..20 or @s b matches 30
say < if, or 2
 
say > if, (and 1) or 1
execute if function demo:binary_logical/or_2 run say (@s a matches 10.. and @s b matches ..20) or @s b matches 30
say < if, (and 1) or 1
 
say > if, (or 1) and 1
execute if function demo:binary_logical/or_3 if score @s c matches 30 run say (@s a matches 10.. or @s b matches ..20) and @s c matches 30
say < if, (or 1) and 1
 
```

`@function demo:binary_logical/or_0`

```mcfunction
execute if score @s a matches 10.. run return 1
execute if score @s b matches ..20 run return 1
```

`@function demo:binary_logical/or_1`

```mcfunction
execute if score @s a matches 10.. run return 1
execute if score @s b matches ..20 run return 1
execute if score @s b matches 30 run return 1
```

`@function demo:binary_logical/or_2`

```mcfunction
execute if entity @s[scores={a=10.., b=..20}] run return 1
execute if score @s b matches 30 run return 1
```

`@function demo:binary_logical/or_3`

```mcfunction
execute if score @s a matches 10.. run return 1
execute if score @s b matches ..20 run return 1
```
