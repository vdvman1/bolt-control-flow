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

`@function demo:logging`

```mcfunction
say > if
say   condA.__init__
say   > condA.__branch__
say     true
say   < condA.__branch__
say < if
 
say > if-not
say   condA.__init__
say   > condA.__not__
say     notA.__init__
say   < condA.__not__
say   > notA.__branch__
say     true
say   < notA.__branch__
say < if-not
 
say > if-else
say   condA.__init__
say   > condA.__not__
say     notA.__init__
say   < condA.__not__
say   > condA.__branch__
say     true
say   < condA.__branch__
say   > notA.__branch__
say     false
say   < notA.__branch__
say < if-else
 
say > if-not-else
say   condA.__init__
say   > condA.__not__
say     notA.__init__
say   < condA.__not__
say   > notA.__not__
say     notNotA.__init__
say   < notA.__not__
say   > notA.__branch__
say     true
say   < notA.__branch__
say   > notNotA.__branch__
say     false
say   < notNotA.__branch__
say < if-not-else
 
say > if ... if not, same instance
say   Should be different from if-else
say   condA.__init__
say   > condA.__branch__
say     true
say   < condA.__branch__
say   > condA.__not__
say     notA.__init__
say   < condA.__not__
say   > notA.__branch__
say     false
say   < notA.__branch__
say < if ... if not, same instance
 
say > if not ... if not, same instance
say   Should be different from if-not-else
say   condA.__init__
say   > condA.__not__
say     notA.__init__
say   < condA.__not__
say   > notA.__branch__
say     true
say   < notA.__branch__
say   > notA.__not__
say     notNotA.__init__
say   < notA.__not__
say   > notNotA.__branch__
say     false
say   < notNotA.__branch__
say < if not ... if not, same instance
 
say > if-and
say   condA.__init__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > condA.__branch__
say     condB.__init__
say     > dup1.__rebind__(condB)
say     < dup1.__rebind__(condB)
say   < condA.__branch__
say   > dup1.__branch__
say     true
say   < dup1.__branch__
say < if-and
 
say > if-not-and
say   condA.__init__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > condA.__branch__
say     condB.__init__
say     > dup1.__rebind__(condB)
say     < dup1.__rebind__(condB)
say   < condA.__branch__
say   > dup1.__not__
say     notdup1.__init__
say   < dup1.__not__
say   > notdup1.__branch__
say     true
say   < notdup1.__branch__
say < if-not-and
 
say > if-and2
say   condA.__init__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > condA.__branch__
say     condB.__init__
say     > dup1.__rebind__(condB)
say     < dup1.__rebind__(condB)
say   < condA.__branch__
say   > dup1.__dup__
say     dup2.__init__
say   < dup1.__dup__
say   > dup1.__branch__
say     condC.__init__
say     > dup2.__rebind__(condC)
say     < dup2.__rebind__(condC)
say   < dup1.__branch__
say   > dup2.__branch__
say     true
say   < dup2.__branch__
say < if-and2
 
say > if-and-else
say   condA.__init__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > condA.__branch__
say     condB.__init__
say     > dup1.__rebind__(condB)
say     < dup1.__rebind__(condB)
say   < condA.__branch__
say   > dup1.__not__
say     notdup1.__init__
say   < dup1.__not__
say   > dup1.__branch__
say     true
say   < dup1.__branch__
say   > notdup1.__branch__
say     false
say   < notdup1.__branch__
say < if-and-else
 
say > if-and2-else
say   condA.__init__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > condA.__branch__
say     condB.__init__
say     > dup1.__rebind__(condB)
say     < dup1.__rebind__(condB)
say   < condA.__branch__
say   > dup1.__dup__
say     dup2.__init__
say   < dup1.__dup__
say   > dup1.__branch__
say     condC.__init__
say     > dup2.__rebind__(condC)
say     < dup2.__rebind__(condC)
say   < dup1.__branch__
say   > dup2.__not__
say     notdup2.__init__
say   < dup2.__not__
say   > dup2.__branch__
say     true
say   < dup2.__branch__
say   > notdup2.__branch__
say     false
say   < notdup2.__branch__
say < if-and2-else
 
say > if-and ... if not, same instance
say   should be different from if-and-else
say   condA.__init__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > condA.__branch__
say     condB.__init__
say     > dup1.__rebind__(condB)
say     < dup1.__rebind__(condB)
say   < condA.__branch__
say   > dup1.__branch__
say     true
say   < dup1.__branch__
say   > dup1.__not__
say     notdup1.__init__
say   < dup1.__not__
say   > notdup1.__branch__
say     false
say   < notdup1.__branch__
say < if-and ... if not, same instance
 
say > if-and2 ... if not, same instance
say   should be different from if-and2-else
say   condA.__init__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > condA.__branch__
say     condB.__init__
say     > dup1.__rebind__(condB)
say     < dup1.__rebind__(condB)
say   < condA.__branch__
say   > dup1.__dup__
say     dup2.__init__
say   < dup1.__dup__
say   > dup1.__branch__
say     condC.__init__
say     > dup2.__rebind__(condC)
say     < dup2.__rebind__(condC)
say   < dup1.__branch__
say   > dup2.__branch__
say     true
say   < dup2.__branch__
say   > dup2.__not__
say     notdup2.__init__
say   < dup2.__not__
say   > notdup2.__branch__
say     false
say   < notdup2.__branch__
say < if-and2 ... if not, same instance
 
say > if-or
say   condA.__init__
say   > condA.__not__
say     notA.__init__
say   < condA.__not__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > notA.__branch__
say     condB.__init__
say     > dup1.__rebind__(condB)
say     < dup1.__rebind__(condB)
say   < notA.__branch__
say   > dup1.__branch__
say     true
say   < dup1.__branch__
say < if-or
 
say > if-or2
say   condA.__init__
say   > condA.__not__
say     notA.__init__
say   < condA.__not__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > notA.__branch__
say     condB.__init__
say     > dup1.__rebind__(condB)
say     < dup1.__rebind__(condB)
say   < notA.__branch__
say   > dup1.__not__
say     notdup1.__init__
say   < dup1.__not__
say   > dup1.__dup__
say     dup2.__init__
say   < dup1.__dup__
say   > notdup1.__branch__
say     condC.__init__
say     > dup2.__rebind__(condC)
say     < dup2.__rebind__(condC)
say   < notdup1.__branch__
say   > dup2.__branch__
say     true
say   < dup2.__branch__
say < if-or2
 
say > if-or-else
say   condA.__init__
say   > condA.__not__
say     notA.__init__
say   < condA.__not__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > notA.__branch__
say     condB.__init__
say     > dup1.__rebind__(condB)
say     < dup1.__rebind__(condB)
say   < notA.__branch__
say   > dup1.__not__
say     notdup1.__init__
say   < dup1.__not__
say   > dup1.__branch__
say     true
say   < dup1.__branch__
say   > notdup1.__branch__
say     false
say   < notdup1.__branch__
say < if-or-else
 
say > if-or2-else
say   condA.__init__
say   > condA.__not__
say     notA.__init__
say   < condA.__not__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > notA.__branch__
say     condB.__init__
say     > dup1.__rebind__(condB)
say     < dup1.__rebind__(condB)
say   < notA.__branch__
say   > dup1.__not__
say     notdup1.__init__
say   < dup1.__not__
say   > dup1.__dup__
say     dup2.__init__
say   < dup1.__dup__
say   > notdup1.__branch__
say     condC.__init__
say     > dup2.__rebind__(condC)
say     < dup2.__rebind__(condC)
say   < notdup1.__branch__
say   > dup2.__not__
say     notdup2.__init__
say   < dup2.__not__
say   > dup2.__branch__
say     true
say   < dup2.__branch__
say   > notdup2.__branch__
say     false
say   < notdup2.__branch__
say < if-or2-else
 
say > if-or ... if not, same instance
say   should be different from if-or-else
say   condA.__init__
say   > condA.__not__
say     notA.__init__
say   < condA.__not__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > notA.__branch__
say     condB.__init__
say     > dup1.__rebind__(condB)
say     < dup1.__rebind__(condB)
say   < notA.__branch__
say   > dup1.__branch__
say     true
say   < dup1.__branch__
say   > dup1.__not__
say     notdup1.__init__
say   < dup1.__not__
say   > notdup1.__branch__
say     false
say   < notdup1.__branch__
say < if-or ... if not, same instance
 
say > if-or2 ... if not, same instance
say   should be different from if-or2-else
say   condA.__init__
say   > condA.__not__
say     notA.__init__
say   < condA.__not__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > notA.__branch__
say     condB.__init__
say     > dup1.__rebind__(condB)
say     < dup1.__rebind__(condB)
say   < notA.__branch__
say   > dup1.__not__
say     notdup1.__init__
say   < dup1.__not__
say   > dup1.__dup__
say     dup2.__init__
say   < dup1.__dup__
say   > notdup1.__branch__
say     condC.__init__
say     > dup2.__rebind__(condC)
say     < dup2.__rebind__(condC)
say   < notdup1.__branch__
say   > dup2.__branch__
say     true
say   < dup2.__branch__
say   > dup2.__not__
say     notdup2.__init__
say   < dup2.__not__
say   > notdup2.__branch__
say     false
say   < notdup2.__branch__
say < if-or2 ... if not, same instance
 
```
