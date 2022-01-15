#include <Rcpp.h>
using namespace Rcpp;

//' Print tables iteratively
//'
//' @description
//' This function takes a list of `flextable` objects and prints the raw code. \strong{Note} that chunk option
//' results must be set to \strong{asis}, i.e., `results='asis'`.
//'
//' @param l A list of `flextable` objects, which are s3 lists with certain structures.
//'
//' @return Invisible.
//'
//' @importFrom flextable flextable_to_rmd
//' @importFrom flextable autofit
//' @export
//'
//' @examples
//' \donttest{
//' # Toplines
//' print_tbls(list_toplines)
//'
//' # Crosstabs
//' print_tbls(list_xtabs)
//' }
// [[Rcpp::export]]
void print_tbls(List l) {
  int n = l.size();
  Environment flex = Environment::namespace_env("flextable");
  Function print_flex = flex["flextable_to_rmd"];
  Function fit = flex["autofit"];

  for(int i = 0; i < n; ++i) {
    print_flex(
      _["x"] = fit(
        _["x"] = l[i]
    ),
    _["text_after"] = "\\pagebreak"
    );
    }
}
