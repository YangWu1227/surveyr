with_mock_db(
  test_that("Tests for MyRedshift class", {
    # Instantiate class
    # Using a public database https://rnacentral.org/help/public-database
    db <- MyRedshift$new(
      host = "hh-pgsql-public.ebi.ac.uk",
      port = "5432",
      user = "reader",
      password = "NWDMCE5xdipIjRrp",
      dbname = "pfmegrnargs"
    )

    # Read table
    df_tbl <- db$read_tbl("Rna", nrow = 1)

    # Read query
    df_query <- db$read_sql("SELECT upi FROM Rna;", nrow = 1)

    # Class
    expect_s3_class(df_tbl, "data.frame", exact = TRUE)
    expect_s3_class(df_query, "data.frame", exact = TRUE)

    # Snapshots
    expect_snapshot_output(
      x = df_tbl,
      cran = FALSE,
      variant = "myredshift_tbl_output"
    )
    expect_snapshot_output(
      x = df_query,
      cran = FALSE,
      variant = "myredshift_query_output"
    )
  })
)
