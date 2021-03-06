
context("Bioconductor")

test_that("packages can be installed, restored from Bioconductor", {

  skip_on_cran()
  skip_on_os("windows")
  skip_if(getRversion() < "3.5.0")
  skip_if(R.version$nickname == "Unsuffered Consequences")

  renv_scope_options(renv.tests.verbose = FALSE)

  renv_tests_scope("Biobase")

  cran <- "https://cloud.r-project.org"
  install.packages("BiocManager", repos = cran, quiet = TRUE)
  BiocManager <- asNamespace("BiocManager")
  BiocManager$install("Biobase", quiet = TRUE)

  expect_true(renv_package_installed("BiocManager"))
  expect_true(renv_package_installed("BiocVersion"))
  expect_true(renv_package_installed("Biobase"))

  snapshot()

  lockfile <- snapshot(lockfile = NULL)
  expect_true("Bioconductor" %in% names(lockfile))
  expect_equal(names(lockfile)[2], "Bioconductor")
  expect_equal(lockfile$Bioconductor$Version, format(BiocManager$version()))

  records <- renv_records(lockfile)
  expect_true("BiocManager" %in% names(records))
  expect_true("BiocVersion" %in% names(records))
  expect_true("Biobase" %in% names(records))

  if (!renv_platform_linux())
    renv_scope_options(pkgType = "both")

  remove("Biobase")
  restore()
  expect_true(renv_package_installed("Biobase"))

})

test_that("renv::install(<bioc>, rebuild = TRUE) works", {

  skip_on_cran()
  skip_on_os("windows")
  skip_if(getRversion() < "3.5.0")
  skip_if(R.version$nickname == "Unsuffered Consequences")
  skip_if_not_installed("BiocManager")

  renv_scope_options(renv.tests.verbose = FALSE)

  requireNamespace("BiocManager", quietly = TRUE)
  on.exit(unloadNamespace("BiocManager"), add = TRUE)

  renv_tests_scope()
  install("bioc::Biobase", rebuild = TRUE)

  expect_true(renv_package_installed("Biobase"))

})
