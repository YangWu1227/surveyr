# check_patterns() return meaningful error messages

    Code
      check_patterns(c(3, 4), patterns)
    Condition
      Error in `check_patterns()`:
      ! Expecting a string vector: [type=double; required=STRSXP].

---

    Code
      check_patterns(patterns)
    Condition
      Error in `check_patterns()`:
      ! argument "patterns" is missing, with no default

