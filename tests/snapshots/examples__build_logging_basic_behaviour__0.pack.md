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
say     dup1.__rebind__(condB)
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
say     dup1.__rebind__(condB)
say   < condA.__branch__
say   > dup1.__not__
say     notDup1.__init__
say   < dup1.__not__
say   > notDup1.__branch__
say     true
say   < notDup1.__branch__
say < if-not-and
 
say > if-and-else
say   condA.__init__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > condA.__branch__
say     condB.__init__
say     dup1.__rebind__(condB)
say   < condA.__branch__
say   > dup1.__not__
say     notDup1.__init__
say   < dup1.__not__
say   > dup1.__branch__
say     true
say   < dup1.__branch__
say   > notDup1.__branch__
say     false
say   < notDup1.__branch__
say < if-and-else
 
say > if-not-and-else
say   condA.__init__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > condA.__branch__
say     condB.__init__
say     dup1.__rebind__(condB)
say   < condA.__branch__
say   > dup1.__not__
say     notDup1.__init__
say   < dup1.__not__
say   > notDup1.__not__
say     notNotDup1.__init__
say   < notDup1.__not__
say   > notDup1.__branch__
say     true
say   < notDup1.__branch__
say   > notNotDup1.__branch__
say     false
say   < notNotDup1.__branch__
say < if-not-and-else
 
say > if-and ... if not, same instance
say   should be different from if-and-else
say   condA.__init__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > condA.__branch__
say     condB.__init__
say     dup1.__rebind__(condB)
say   < condA.__branch__
say   > dup1.__branch__
say     true
say   < dup1.__branch__
say   > dup1.__not__
say     notDup1.__init__
say   < dup1.__not__
say   > notDup1.__branch__
say     false
say   < notDup1.__branch__
say < if-and ... if not, same instance
 
say > if not and ... if not, same instance
say   Should be different from if-not-and-else
say   condA.__init__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > condA.__branch__
say     condB.__init__
say     dup1.__rebind__(condB)
say   < condA.__branch__
say   > dup1.__not__
say     notDup1.__init__
say   < dup1.__not__
say   > notDup1.__branch__
say     true
say   < notDup1.__branch__
say   > notDup1.__not__
say     notNotDup1.__init__
say   < notDup1.__not__
say   > notNotDup1.__branch__
say     false
say   < notNotDup1.__branch__
say < if not and ... if not, same instance
 
say > if-and2
say   condA.__init__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > condA.__branch__
say     condB.__init__
say     dup1.__rebind__(condB)
say   < condA.__branch__
say   > dup1.__dup__
say     dup2.__init__
say   < dup1.__dup__
say   > dup1.__branch__
say     condC.__init__
say     dup2.__rebind__(condC)
say   < dup1.__branch__
say   > dup2.__branch__
say     true
say   < dup2.__branch__
say < if-and2
 
say > if-not-and2
say   condA.__init__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > condA.__branch__
say     condB.__init__
say     dup1.__rebind__(condB)
say   < condA.__branch__
say   > dup1.__dup__
say     dup2.__init__
say   < dup1.__dup__
say   > dup1.__branch__
say     condC.__init__
say     dup2.__rebind__(condC)
say   < dup1.__branch__
say   > dup2.__not__
say     notDup2.__init__
say   < dup2.__not__
say   > notDup2.__branch__
say     true
say   < notDup2.__branch__
say < if-not-and2
 
say > if-and2-else
say   condA.__init__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > condA.__branch__
say     condB.__init__
say     dup1.__rebind__(condB)
say   < condA.__branch__
say   > dup1.__dup__
say     dup2.__init__
say   < dup1.__dup__
say   > dup1.__branch__
say     condC.__init__
say     dup2.__rebind__(condC)
say   < dup1.__branch__
say   > dup2.__not__
say     notDup2.__init__
say   < dup2.__not__
say   > dup2.__branch__
say     true
say   < dup2.__branch__
say   > notDup2.__branch__
say     false
say   < notDup2.__branch__
say < if-and2-else
 
say > if-not-and2-else
say   condA.__init__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > condA.__branch__
say     condB.__init__
say     dup1.__rebind__(condB)
say   < condA.__branch__
say   > dup1.__dup__
say     dup2.__init__
say   < dup1.__dup__
say   > dup1.__branch__
say     condC.__init__
say     dup2.__rebind__(condC)
say   < dup1.__branch__
say   > dup2.__not__
say     notDup2.__init__
say   < dup2.__not__
say   > notDup2.__not__
say     notNotDup2.__init__
say   < notDup2.__not__
say   > notDup2.__branch__
say     true
say   < notDup2.__branch__
say   > notNotDup2.__branch__
say     false
say   < notNotDup2.__branch__
say < if-not-and2-else
 
say > if-and2 ... if not, same instance
say   should be different from if-and2-else
say   condA.__init__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > condA.__branch__
say     condB.__init__
say     dup1.__rebind__(condB)
say   < condA.__branch__
say   > dup1.__dup__
say     dup2.__init__
say   < dup1.__dup__
say   > dup1.__branch__
say     condC.__init__
say     dup2.__rebind__(condC)
say   < dup1.__branch__
say   > dup2.__branch__
say     true
say   < dup2.__branch__
say   > dup2.__not__
say     notDup2.__init__
say   < dup2.__not__
say   > notDup2.__branch__
say     false
say   < notDup2.__branch__
say < if-and2 ... if not, same instance
 
say > if not and2 ... if not, same instance
say   Should be different from if-not-and2-else
say   condA.__init__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > condA.__branch__
say     condB.__init__
say     dup1.__rebind__(condB)
say   < condA.__branch__
say   > dup1.__dup__
say     dup2.__init__
say   < dup1.__dup__
say   > dup1.__branch__
say     condC.__init__
say     dup2.__rebind__(condC)
say   < dup1.__branch__
say   > dup2.__not__
say     notDup2.__init__
say   < dup2.__not__
say   > notDup2.__branch__
say     true
say   < notDup2.__branch__
say   > notDup2.__not__
say     notNotDup2.__init__
say   < notDup2.__not__
say   > notNotDup2.__branch__
say     false
say   < notNotDup2.__branch__
say < if not and2 ... if not, same instance
 
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
say     dup1.__rebind__(condB)
say   < notA.__branch__
say   > dup1.__branch__
say     true
say   < dup1.__branch__
say < if-or
 
say > if-not-or
say   condA.__init__
say   > condA.__not__
say     notA.__init__
say   < condA.__not__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > notA.__branch__
say     condB.__init__
say     dup1.__rebind__(condB)
say   < notA.__branch__
say   > dup1.__not__
say     notDup1.__init__
say   < dup1.__not__
say   > notDup1.__branch__
say     true
say   < notDup1.__branch__
say < if-not-or
 
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
say     dup1.__rebind__(condB)
say   < notA.__branch__
say   > dup1.__not__
say     notDup1.__init__
say   < dup1.__not__
say   > dup1.__branch__
say     true
say   < dup1.__branch__
say   > notDup1.__branch__
say     false
say   < notDup1.__branch__
say < if-or-else
 
say > if-not-or-else
say   condA.__init__
say   > condA.__not__
say     notA.__init__
say   < condA.__not__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > notA.__branch__
say     condB.__init__
say     dup1.__rebind__(condB)
say   < notA.__branch__
say   > dup1.__not__
say     notDup1.__init__
say   < dup1.__not__
say   > notDup1.__not__
say     notNotDup1.__init__
say   < notDup1.__not__
say   > notDup1.__branch__
say     true
say   < notDup1.__branch__
say   > notNotDup1.__branch__
say     false
say   < notNotDup1.__branch__
say < if-not-or-else
 
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
say     dup1.__rebind__(condB)
say   < notA.__branch__
say   > dup1.__branch__
say     true
say   < dup1.__branch__
say   > dup1.__not__
say     notDup1.__init__
say   < dup1.__not__
say   > notDup1.__branch__
say     false
say   < notDup1.__branch__
say < if-or ... if not, same instance
 
say > if-not-or ... if not, same instance
say   should be different from if-not-or-else
say   condA.__init__
say   > condA.__not__
say     notA.__init__
say   < condA.__not__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > notA.__branch__
say     condB.__init__
say     dup1.__rebind__(condB)
say   < notA.__branch__
say   > dup1.__not__
say     notDup1.__init__
say   < dup1.__not__
say   > notDup1.__branch__
say     true
say   < notDup1.__branch__
say   > notDup1.__not__
say     notNotDup1.__init__
say   < notDup1.__not__
say   > notNotDup1.__branch__
say     false
say   < notNotDup1.__branch__
say < if-not-or ... if not, same instance
 
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
say     dup1.__rebind__(condB)
say   < notA.__branch__
say   > dup1.__not__
say     notDup1.__init__
say   < dup1.__not__
say   > dup1.__dup__
say     dup2.__init__
say   < dup1.__dup__
say   > notDup1.__branch__
say     condC.__init__
say     dup2.__rebind__(condC)
say   < notDup1.__branch__
say   > dup2.__branch__
say     true
say   < dup2.__branch__
say < if-or2
 
say > if-not-or2
say   condA.__init__
say   > condA.__not__
say     notA.__init__
say   < condA.__not__
say   > condA.__dup__
say     dup1.__init__
say   < condA.__dup__
say   > notA.__branch__
say     condB.__init__
say     dup1.__rebind__(condB)
say   < notA.__branch__
say   > dup1.__not__
say     notDup1.__init__
say   < dup1.__not__
say   > dup1.__dup__
say     dup2.__init__
say   < dup1.__dup__
say   > notDup1.__branch__
say     condC.__init__
say     dup2.__rebind__(condC)
say   < notDup1.__branch__
say   > dup2.__not__
say     notDup2.__init__
say   < dup2.__not__
say   > notDup2.__branch__
say     true
say   < notDup2.__branch__
say   condD.__init__
say   > condD.__not__
say     notD.__init__
say   < condD.__not__
say   > condD.__dup__
say     dup3.__init__
say   < condD.__dup__
say   > notD.__branch__
say     condE.__init__
say     dup3.__rebind__(condE)
say     dup3.__rebind__(dup3)
say   < notD.__branch__
say   > dup3.__not__
say     notDup3.__init__
say   < dup3.__not__
say   > dup3.__dup__
say     dup4.__init__
say   < dup3.__dup__
say   > notDup3.__branch__
say     true
say   < notDup3.__branch__
say < if-not-or2
 
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
say     dup1.__rebind__(condB)
say   < notA.__branch__
say   > dup1.__not__
say     notDup1.__init__
say   < dup1.__not__
say   > dup1.__dup__
say     dup2.__init__
say   < dup1.__dup__
say   > notDup1.__branch__
say     condC.__init__
say     dup2.__rebind__(condC)
say   < notDup1.__branch__
say   > dup2.__not__
say     notDup2.__init__
say   < dup2.__not__
say   > dup2.__branch__
say     true
say   < dup2.__branch__
say   > notDup2.__branch__
say     false
say   < notDup2.__branch__
say < if-or2-else
 
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
say     dup1.__rebind__(condB)
say   < notA.__branch__
say   > dup1.__not__
say     notDup1.__init__
say   < dup1.__not__
say   > dup1.__dup__
say     dup2.__init__
say   < dup1.__dup__
say   > notDup1.__branch__
say     condC.__init__
say     dup2.__rebind__(condC)
say   < notDup1.__branch__
say   > dup2.__branch__
say     true
say   < dup2.__branch__
say   > dup2.__not__
say     notDup2.__init__
say   < dup2.__not__
say   > notDup2.__branch__
say     false
say   < notDup2.__branch__
say < if-or2 ... if not, same instance
 
```
