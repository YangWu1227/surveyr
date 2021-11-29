# Does the error list accurately capture invalid input for 'df'

    $result
    $result$education_rollup
    NULL
    
    $result$party_reg
    NULL
    
    $result$issue_focus
    NULL
    
    
    $error
    $error$education_rollup
    <simpleError: 'df' must be a data frame>
    
    $error$party_reg
    <simpleError: 'df' must be a data frame>
    
    $error$issue_focus
    <simpleError: 'df' must be a data frame>
    
    

# Does the error list accurately capture invalid input for 'var_interest' (not found in df)

    $result
    $result$education_rollup
    # A tibble: 2 x 3
      x                y           caption                        
      <chr>            <chr>       <chr>                          
    1 education_rollup party_reg   Party reg by Education rollup  
    2 education_rollup issue_focus Issue focus by Education rollup
    
    $result$party_reg
    # A tibble: 2 x 3
      x         y                caption                      
      <chr>     <chr>            <chr>                        
    1 party_reg education_rollup Education rollup by Party reg
    2 party_reg issue_focus      Issue focus by Party reg     
    
    $result$issue_focus
    # A tibble: 2 x 3
      x           y                caption                        
      <chr>       <chr>            <chr>                          
    1 issue_focus education_rollup Education rollup by Issue focus
    2 issue_focus party_reg        Party reg by Issue focus       
    
    $result$unknown
    NULL
    
    
    $error
    $error$education_rollup
    NULL
    
    $error$party_reg
    NULL
    
    $error$issue_focus
    NULL
    
    $error$unknown
    <simpleError: The argument 'var_of_interest' must be a single column name found in 'df'>
    
    

# Does the error list accurately capture invalid input for 'dependent_vars' (not in df)

    $result
    $result$education_rollup
    NULL
    
    $result$party_reg
    # A tibble: 1 x 3
      x         y           caption                 
      <chr>     <chr>       <chr>                   
    1 party_reg issue_focus Issue focus by Party reg
    
    $result$issue_focus
    # A tibble: 1 x 3
      x           y         caption                 
      <chr>       <chr>     <chr>                   
    1 issue_focus party_reg Party reg by Issue focus
    
    
    $error
    $error$education_rollup
    <simpleError: The argument 'dependent_vars' must be a subset of `base::setdiff(x = names(df), y = var_of_interest)`>
    
    $error$party_reg
    NULL
    
    $error$issue_focus
    NULL
    
    

# Does the error list accurately capture invalid input for 'rm' (not in df and wrong type)

    $result
    $result$education_rollup
    NULL
    
    $result$party_reg
    NULL
    
    $result$issue_focus
    NULL
    
    
    $error
    $error$education_rollup
    <simpleError: The argument 'rm' must contain columns in 'df'>
    
    $error$party_reg
    <simpleError: The argument 'rm' must contain columns in 'df'>
    
    $error$issue_focus
    <simpleError: The argument 'rm' must contain columns in 'df'>
    
    

---

    $result
    $result$education_rollup
    NULL
    
    $result$party_reg
    NULL
    
    $result$issue_focus
    NULL
    
    
    $error
    $error$education_rollup
    <simpleError: The argument 'rm' must be a character vector>
    
    $error$party_reg
    <simpleError: The argument 'rm' must be a character vector>
    
    $error$issue_focus
    <simpleError: The argument 'rm' must be a character vector>
    
    

# Does flatten_args() return correct output type and class and snapshot

    # A tibble: 6 x 3
      x                y                caption                        
      <chr>            <chr>            <chr>                          
    1 education_rollup party_reg        Party reg by Education rollup  
    2 education_rollup issue_focus      Issue focus by Education rollup
    3 party_reg        education_rollup Education rollup by Party reg  
    4 party_reg        issue_focus      Issue focus by Party reg       
    5 issue_focus      party_reg        Party reg by Issue focus       
    6 issue_focus      education_rollup Education rollup by Issue focus

