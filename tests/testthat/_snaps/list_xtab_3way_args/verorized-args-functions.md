# list_xtab_3way_args() does the error list accurately capture invalid input for 'df'

    $result
    $result$issue_focus
    NULL
    
    
    $error
    $error$issue_focus
    <simpleError: 'df' must be a data frame>
    
    

# list_xtab_3way_args() does the error list accurately capture invalid input for 'control' (not found in df)

    $result
    $result$education_rollup
    # A tibble: 2 x 4
      x           y           z                caption                              
      <chr>       <chr>       <chr>            <chr>                                
    1 party_reg   issue_focus education_rollup Education Rollup by Party Reg And Is~
    2 issue_focus party_reg   education_rollup Education Rollup by Issue Focus And ~
    
    $result$unknown
    NULL
    
    $result$issue_focus
    # A tibble: 2 x 4
      x                y                z           caption                         
      <chr>            <chr>            <chr>       <chr>                           
    1 education_rollup party_reg        issue_focus Issue Focus by Education Rollup~
    2 party_reg        education_rollup issue_focus Issue Focus by Party Reg And Ed~
    
    
    $error
    $error$education_rollup
    NULL
    
    $error$unknown
    <simpleError: The argument 'control_var' must be a single column name found in 'df'>
    
    $error$issue_focus
    NULL
    
    

# list_xtab_3way_args() does the error list accurately capture invalid input for 'dependent_vars' (not in df)

    $result
    $result$education_rollup
    # A tibble: 2 x 4
      x           y           z                caption                              
      <chr>       <chr>       <chr>            <chr>                                
    1 party_reg   issue_focus education_rollup Education Rollup by Party Reg And Is~
    2 issue_focus party_reg   education_rollup Education Rollup by Issue Focus And ~
    
    $result$party_reg
    NULL
    
    $result$issue_focus
    NULL
    
    
    $error
    $error$education_rollup
    NULL
    
    $error$party_reg
    <simpleError: The argument 'dependent_vars' must be a subset of `base::setdiff(x = names(df), y = control_var)`>
    
    $error$issue_focus
    <simpleError: The argument 'dependent_vars' must be a subset of `base::setdiff(x = names(df), y = control_var)`>
    
    

# list_xtab_3way_args() does the error list accurately capture invalid input for 'independent_vars' (not in df)

    $result
    $result$education_rollup
    NULL
    
    $result$party_reg
    # A tibble: 2 x 4
      x                y                z         caption                           
      <chr>            <chr>            <chr>     <chr>                             
    1 education_rollup issue_focus      party_reg Party Reg by Education Rollup And~
    2 issue_focus      education_rollup party_reg Party Reg by Issue Focus And Educ~
    
    $result$issue_focus
    # A tibble: 2 x 4
      x                y                z           caption                         
      <chr>            <chr>            <chr>       <chr>                           
    1 education_rollup party_reg        issue_focus Issue Focus by Education Rollup~
    2 party_reg        education_rollup issue_focus Issue Focus by Party Reg And Ed~
    
    
    $error
    $error$education_rollup
    <simpleError: The argument 'independent_vars' must be a subset of `base::setdiff(x = names(df), y = control_var)`>
    
    $error$party_reg
    NULL
    
    $error$issue_focus
    NULL
    
    

# Does flatten_args() return correct output type and class and snapshot

    # A tibble: 6 x 4
      x                y                z                caption                    
      <chr>            <chr>            <chr>            <chr>                      
    1 party_reg        issue_focus      education_rollup Education Rollup by Party ~
    2 issue_focus      party_reg        education_rollup Education Rollup by Issue ~
    3 education_rollup issue_focus      party_reg        Party Reg by Education Rol~
    4 issue_focus      education_rollup party_reg        Party Reg by Issue Focus A~
    5 education_rollup party_reg        issue_focus      Issue Focus by Education R~
    6 party_reg        education_rollup issue_focus      Issue Focus by Party Reg A~

