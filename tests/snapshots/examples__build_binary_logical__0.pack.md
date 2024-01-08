# Lectern snapshot

## Data pack

`@data_pack pack.mcmeta`

```json
{
  "pack": {
    "pack_format": 18,
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
 
```
