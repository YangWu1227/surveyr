# check_patterns() return meaningful error messages

    Code
      check_patterns(c(3, 4), patterns)
    Error <Rcpp::not_compatible>
      Expecting a string vector: [type=double; required=STRSXP].

---

    Code
      check_patterns(patterns)
    Error <simpleError>
      argument "patterns" is missing, with no default

