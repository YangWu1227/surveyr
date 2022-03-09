# Custom crosstab function returns correct s3 class (data.table) and output

                            issue_focus  education_rollup Percent   MOE
     1:                           Crime         Bachelors    35.7  14.4
     2:                           Crime          Graduate    20.8  12.2
     3:                           Crime Less than college    43.5  14.9
     4:               Education/Schools         Bachelors    34.5  27.8
     5:               Education/Schools          Graduate    23.7  24.8
     6:               Education/Schools Less than college    41.9  28.8
     7:                      Healthcare         Bachelors    61.1 102.7
     8:                      Healthcare          Not sure    38.9 102.7
     9:                    Homelessness          Graduate    41.8 103.9
    10:                    Homelessness Less than college    58.2 103.9
    11:                         Housing          Graduate    26.2  65.4
    12:                         Housing Less than college    73.8  65.4
    13:                            Jobs         Bachelors     100   NaN
    14:                   Police reform         Bachelors    41.9  36.7
    15:                   Police reform          Graduate    13.1  25.1
    16:                   Police reform Less than college      45    37
    17: Something else (please specify)         Bachelors    32.2  37.2
    18: Something else (please specify)          Graduate     7.2  20.5
    19: Something else (please specify) Less than college    60.7  38.9
    20:                  Transportation         Bachelors    18.9  26.1
    21:                  Transportation          Graduate     9.8  19.8
    22:                  Transportation Less than college    71.3  30.1
                            issue_focus  education_rollup Percent   MOE
        Survey Total Percent
     1:                 33.8
     2:                 18.1
     3:                 47.6
     4:                 33.8
     5:                 18.1
     6:                 47.6
     7:                 33.8
     8:                  0.5
     9:                 18.1
    10:                 47.6
    11:                 18.1
    12:                 47.6
    13:                 33.8
    14:                 33.8
    15:                 18.1
    16:                 47.6
    17:                 33.8
    18:                 18.1
    19:                 47.6
    20:                 33.8
    21:                 18.1
    22:                 47.6
        Survey Total Percent

---

                  party_reg  education_rollup Percent  MOE Survey Total Percent
    1: The Republican party         Bachelors    33.8   10                 33.8
    2: The Republican party          Graduate    18.1  8.1                 18.1
    3: The Republican party Less than college    47.6 10.6                 47.6
    4: The Republican party          Not sure     0.5  1.5                  0.5

# Custom three-way crosstab function returns correct s3 class (data.table) and output

                   party_reg                     issue_focus  education_rollup
     1: The Republican party                           Crime         Bachelors
     2: The Republican party                           Crime          Graduate
     3: The Republican party                           Crime Less than college
     4: The Republican party               Education/Schools         Bachelors
     5: The Republican party               Education/Schools          Graduate
     6: The Republican party               Education/Schools Less than college
     7: The Republican party                      Healthcare         Bachelors
     8: The Republican party                      Healthcare          Not sure
     9: The Republican party                    Homelessness          Graduate
    10: The Republican party                    Homelessness Less than college
    11: The Republican party                         Housing          Graduate
    12: The Republican party                         Housing Less than college
    13: The Republican party                            Jobs         Bachelors
    14: The Republican party                   Police reform         Bachelors
    15: The Republican party                   Police reform          Graduate
    16: The Republican party                   Police reform Less than college
    17: The Republican party Something else (please specify)         Bachelors
    18: The Republican party Something else (please specify)          Graduate
    19: The Republican party Something else (please specify) Less than college
    20: The Republican party                  Transportation         Bachelors
    21: The Republican party                  Transportation          Graduate
    22: The Republican party                  Transportation Less than college
                   party_reg                     issue_focus  education_rollup
        Percent   MOE Survey Total Percent
     1:    35.7  14.4                 33.8
     2:    20.8  12.2                 18.1
     3:    43.5  14.9                 47.6
     4:    34.5  27.8                 33.8
     5:    23.7  24.8                 18.1
     6:    41.9  28.8                 47.6
     7:    61.1 102.7                 33.8
     8:    38.9 102.7                  0.5
     9:    41.8 103.9                 18.1
    10:    58.2 103.9                 47.6
    11:    26.2  65.4                 18.1
    12:    73.8  65.4                 47.6
    13:     100   NaN                 33.8
    14:    41.9  36.7                 33.8
    15:    13.1  25.1                 18.1
    16:      45    37                 47.6
    17:    32.2  37.2                 33.8
    18:     7.2  20.5                 18.1
    19:    60.7  38.9                 47.6
    20:    18.9  26.1                 33.8
    21:     9.8  19.8                 18.1
    22:    71.3  30.1                 47.6
        Percent   MOE Survey Total Percent

---

                            issue_focus            party_reg  education_rollup
     1:                           Crime The Republican party         Bachelors
     2:                           Crime The Republican party          Graduate
     3:                           Crime The Republican party Less than college
     4:               Education/Schools The Republican party         Bachelors
     5:               Education/Schools The Republican party          Graduate
     6:               Education/Schools The Republican party Less than college
     7:                      Healthcare The Republican party         Bachelors
     8:                      Healthcare The Republican party          Not sure
     9:                    Homelessness The Republican party          Graduate
    10:                    Homelessness The Republican party Less than college
    11:                         Housing The Republican party          Graduate
    12:                         Housing The Republican party Less than college
    13:                            Jobs The Republican party         Bachelors
    14:                   Police reform The Republican party         Bachelors
    15:                   Police reform The Republican party          Graduate
    16:                   Police reform The Republican party Less than college
    17: Something else (please specify) The Republican party         Bachelors
    18: Something else (please specify) The Republican party          Graduate
    19: Something else (please specify) The Republican party Less than college
    20:                  Transportation The Republican party         Bachelors
    21:                  Transportation The Republican party          Graduate
    22:                  Transportation The Republican party Less than college
                            issue_focus            party_reg  education_rollup
        Percent   MOE Survey Total Percent
     1:    35.7  14.4                 33.8
     2:    20.8  12.2                 18.1
     3:    43.5  14.9                 47.6
     4:    34.5  27.8                 33.8
     5:    23.7  24.8                 18.1
     6:    41.9  28.8                 47.6
     7:    61.1 102.7                 33.8
     8:    38.9 102.7                  0.5
     9:    41.8 103.9                 18.1
    10:    58.2 103.9                 47.6
    11:    26.2  65.4                 18.1
    12:    73.8  65.4                 47.6
    13:     100   NaN                 33.8
    14:    41.9  36.7                 33.8
    15:    13.1  25.1                 18.1
    16:      45    37                 47.6
    17:    32.2  37.2                 33.8
    18:     7.2  20.5                 18.1
    19:    60.7  38.9                 47.6
    20:    18.9  26.1                 33.8
    21:     9.8  19.8                 18.1
    22:    71.3  30.1                 47.6
        Percent   MOE Survey Total Percent

