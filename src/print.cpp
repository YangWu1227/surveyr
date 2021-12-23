#include <Rcpp.h>
using namespace Rcpp;

//' Print tables iteratively
//'
//' @description
//' This function takes a list of `flextable` or `kableExtra` objects and prints the raw code adapted to the 'output'
//' format. \strong{Note} that chunk option results must be set to \strong{asis}, i.e., `results='asis'`.
//'
//' @param l A list of `flextable` or `kableExtra` objects, which are s3 lists with certain structures.
//' @param output A string specifying the output format.
//'
//' @return Invisible.
//'
//' @importFrom flextable flextable_to_rmd
//' @importFrom flextable autofit
//' @export
//'
//' @examples
//' \donttest{
//' # Toplines to word
//' print_tbls(list_toplines, output = "word")
//'
//' # Crosstabs to pdf
//' print_tbls(list_xtabs, output = "pdf")
//' }
// [[Rcpp::export]]
void print_tbls(List l, String output) {
  int n = l.size();
  Environment flex = Environment::namespace_env("flextable");
  Environment base = Environment::namespace_env("base");
  Function print_flex = flex["flextable_to_rmd"];
  Function fit = flex["autofit"];
  Function print = base["print"];

  if (output == "word") {
    for(int i = 0; i < n; ++i) {
      print_flex(
        _["x"] = fit(
          _["x"] = l[i]
        ),
        _["text_after"] = "\\pagebreak"
      );
    }
  } else if (output == "pdf") {
    for(int i = 0; i < n; ++i) {
      print(l[i]);
    }
  } else {
    stop("Error: The argument 'output' must either be 'word' or 'pdf'");
  }
}
