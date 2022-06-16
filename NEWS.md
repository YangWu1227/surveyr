# surveyr 1.9.3

* Add `FrameCleaner` class that contains cleaning routines for data frame.

# surveyr 1.8.3

* Re-implement table functions to avoid lazy evaluation. The preferred approach is switch to data.table's built-in `substitute2()` function, which will be released in version 1.14.3. 

# citizen 1.8.1

* Add `MyRedshift` class that reads data from database. Plans to add a `MyS3` class with methods to read data from AWS S3. 

# citizen 1.7.3

* Switch to `data.table` backend for table functions--- topline and crosstabs.

# citizen 0.0.0.9000

* Create an R package for internal use by data team members. Many tasks and processes should be quicker and easier with the help of `surveyr`. 
