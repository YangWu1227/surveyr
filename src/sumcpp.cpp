#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

//' Sum of Vector Elements (C++)
//'
//' @description
//' This function uses the `accu()` function from the `Armadillo` library, a C++ library for linear algebra and
//' scientific computing. For \strong{double-Precision} vectors, the run time of this function is faster than the base
//' `sum()` function, making it better suited for summing the `weight` variable with > 3000 elements.
//'
//' @param x A numeric vector.
//'
//' @return A numeric vector.
//'
//' @export
//'
//' @examples
//' \donttest{
//' # Summing a double vector
//' x <- runif(1000000, 0.0000001, 1.99999999)
//' sumcpp(x)
//' }
// [[Rcpp::export]]
double sumcpp(arma::vec& x) {
  return arma::accu(x);
}

