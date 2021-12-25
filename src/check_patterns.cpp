// [[Rcpp::depends(BH)]]

#include <Rcpp.h>
#include <string>
#include <vector>
#include <boost/algorithm/string.hpp>
using namespace Rcpp;
using namespace boost::algorithm;
using std::string;
using std::any_of;

//' Check if column names start with patterns
//'
//' @description
//' This helper function takes two character vectors `mainstrs` and `patterns`, returning a boolean indicating
//' whether each element of `patterns` is a string pattern in which at least one element of `mainstrs` starts with.
//' In other words, for each element of `patterns`, does any element of `mainstrs` start with this particular pattern?
//' If so, return `TRUE`. This helper can be used to efficiently verify the argument `patterns` in `split_df()`,
//' especially when there is a large number of patterns.
//'
//' @param mainstrs A character vector of strings that are checked against each element in `patterns`.
//' @param patterns A character vector of pattern strings.
//'
//' @return A logical vector with the same length as `patterns`, indicating whether each pattern is one that
//' at least one string in `mainstrs` starts with.
//'
//' @export
//'
//' @examples
//' \donttest{
//' # Vector of patterns
//' patterns <- c("prefix_1", "predix_2", ...)
//'
//' # Checking if these patterns are valid for 'df'
//' check_patterns(mainstrs = names(df), patterns) |> all()
//'
//' # Find all invalid patterns
//' valid_index <- check_patterns(mainstrs = names(df), patterns)
//' patterns[!valid_index]
//' }
// [[Rcpp::export]]
std::vector<bool> check_patterns(std::vector<std::string> mainstrs, std::vector<std::string> patterns) {

  std::vector<bool> logical_inner(mainstrs.size());
  std::vector<bool> logical_outter(patterns.size());
  int n_pattern = patterns.size();
  int n_mainstrs = mainstrs.size();

  for(int k = 0; k < n_pattern; ++k) {
    for(int j = 0; j < n_mainstrs; ++j) {
      // Function from the boost/algorithm/string" library
      // Check if inputs mainstrs[0:n_mainstrs] begins with string pattern patterns[k] or not
      bool matched = starts_with(mainstrs[j], patterns[k]);
      // Populated with 'true' or 'false'
      logical_inner[j] = matched;
    }
    // Function from the std library that checks if any element of 'logical_inner' is 'true', if so, return 'true'
    bool any_matched = any_of(logical_inner.begin(), logical_inner.end(), [](bool i){return i == true;});
    // Populated with 'true' or 'false'
    logical_outter[k] = any_matched;
  }
  // Boolean results indicating whether each patterns[k] is a pattern matched in any element of 'mainstrs'
  return logical_outter;
}

// Test

/*** R
# Data
df <- readr::read_rds(test_path("testdata_multiselect.rds"))
patterns <- c("no_vote", "civic_engagement", "media", "activism", "unknown")
# Test
check_patterns(names(df), patterns)
*/
