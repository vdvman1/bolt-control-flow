This document describes the pattern that will be used to actually implement `if ... else`

```hs
function <whole-condition>
```

`@function <whole-condition>`
```hs
execute <conditions> run return run function <true>
return run function <false>
```

Although the functions for `<true>` and `<false>` would only be generated if there's multiple commands, if there's only one it just uses that command directly in the `return run`. And of course, if there is no `else` case it will also bypass the `<whole-condition>` function and just emit:
```hs
execute <conditions> run function <true>
```

This design doesn't mess with commands in the containing function, and allows for return values from the true/false cases to be forwarded through

"AND" conditions would just be chained as normal (or when possible, multiple conditions combined into a single selector)

"OR" conditions would be converted to `if function` with a command for each of the checks (or when possible, a predicate may be used):
```hs
execute <condition1> run return 1
execute <condition2> run return 1
...
```

A "NOT" on a single condition will just exchange `if` and `unless` on that condition

A "NOT" on an entire "OR" will convert it to an "AND" of "NOT"s, `NOT(a OR b OR c OR ...) == NOT(NOT(NOT a AND NOT b AND NOT c AND ...)) == NOT a AND NOT b AND NOT c AND ...`

A "NOT" on an entire "AND" will move the "AND" conditions into a function and use `unless function`, since (NOT a OR NOT b ...) would require a function anyway, and this way it remains a single command with multiple subcommands in the function:
```hs
execute ... unless function <and> ... run return function <true>
```

`@function <and>`
```hs
execute <conditions> run return 1
```