This document describes the pattern of method calls that Bolt generates for various different bits of condition logic, and what that pattern represents.

The hope is that all cases can be unambiguously differentiated with well defined start and end points.
Ultimately, the best solution would be if Bolt had better support for directly overrriding the behaviour of `and` and `or`, as well as a more explicit way of knowing about the presence of absence of an `else`, but as it stands Bolt does not have this support, so we have to detect the different patterns it generates.

1.  
    - 1.  condA -> `__branch__`: body1
          ```py
          if condA:
            body1
          ```
      2.  condA -> `__not__` -> `__branch__`: body2
          ```py
          if not condA:
            body2
          ```
          Technically already covered in another case, but listing here just in case

    - 1.  notA = (condA -> `__not__`)
      2.  
          - 1.  notA -> `__branch__`: body1
                ```py
                notA = not condA
                if notA:
                  body1
                ```
            2.  notA -> `__not__` -> `__branch__`: body2
                ```py
                if not notA:
                  body2
                ```

          - 1.  condA -> `__branch__`: body1
            2.  notA -> `__branch__`: body2
            ```py
            if condA:
              body1
            else:
              body2
            ```

          - 1.  notNotA = (notA -> `__not__`)
            2.  notA -> `__branch__`: body1
            3.  notNotA -> `__branch__`: body2
            ```py
            if not condA:
              body1
            else:
              body2
            ```

          - 1.  dup1 = (condA -> `__dup__`)
            2.  notA -> `__branch__`:
                1.  dup1 = (dup1 -> `__rebind__(condB)`)
            3.  
                - 1.  dup1 -> `__branch__`: body1
                      ```py
                      cond = condA or condB
                      if cond:
                        body1
                      ```
                  2.  dup1 -> `__not__` -> `__branch__`: body2
                      ```py
                      if not cond:
                        body2
                      ```

                - 1.  notDup1 = (dup1 -> `__not__`)
                  2.  
                      - 1.  dup1 -> `__branch__`: body1
                        2.  notDup1 -> `__branch__`: body2
                        ```py
                        if condA or condB:
                          body1
                        else:
                          body2
                        ```

                      - 1.  dup2 = (dup1 -> `__dup__`)
                        2.  notDup1 -> `__branch__`:
                            1.  dup2 = (dup2 -> `__rebind__(condC)`)
                        3.  Repeat (including notDup"N" = (dup"N" -> `__not__`)) for condD, condE, ...
                        4.  
                            - 1.  dup"N" -> `__branch__`: body1
                                  ```py
                                  cond = condA or condB or condC or ...
                                  if cond:
                                    body1
                                  ```
                              2.  dup"N" -> `__not__` -> `__branch__`: body2
                                  ```py
                                  if not cond:
                                    body2
                                  ```

                            - 1.  notDup"N" = (dup"N" -> `__not__`)
                              2.  dup"N" -> `__branch__`: body1
                              3.  notDup"N" -> `__branch__`: body2
                              ```py
                              if condA or condB or condC or ...:
                                body1
                              else:
                                body2
                              ```
    
    - 1.  dup1 = (condA -> `__dup__`)
      2.  condA -> `__branch__`:
          1.  dup1 = (dup1 -> `__rebind__(condB)`)
      3.  
          - 1.  dup1 -> `__branch__`: body1
                ```py
                cond = condA and condB
                if cond:
                  body1
                ```
            2.  dup1 -> `__not__` -> `__branch__`: body2
                ```py
                if not cond:
                  body2
                ```

          - 1.  notDup1 = (dup1 -> `__not__`)
            2. 
                - notDup1 -> `__branch__`: body1
                  ```py
                  if not (condA and condB):
                    body1
                  ```

                - 1.  dup1 -> `__branch__`: body1
                  2.  notDup1 -> `__branch__`: body2
                  ```py
                  if condA and condB:
                    body1
                  else:
                    body2
                  ```

          - 1.  dup2 = (dup1 -> `__dup__`)
            2.  dup1 -> `__branch__`:
                1.  dup2 = (dup2 -> `__rebind__(condC)`)
            3.  Repeat for condD, condE, ...
            4.  
                - 1.  dup"N" -> `__branch__`: body1
                      ```py
                      cond = condA and condB and condC and ...
                      if cond:
                        body1
                      ```
                  2.  dup"N" -> `__not__` -> `__branch__`: body2
                      ```py
                      if not cond:
                        body2
                      ```

                - 1.  notDup"N" = (dup"N" -> `__not__`)
                  2.  dup"N" -> `__branch__`: body1
                  3.  notDup"N" -> `__branch__`: body2
                  ```py
                  if condA and condB and condC and ...:
                    body1
                  else:
                    body2
                  ```