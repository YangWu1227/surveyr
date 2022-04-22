////////////////////////////////////////////////////////////////
// Credit inst/include/Rcpp/sugar/functions/strings/trimws.h //
///////////////////////////////////////////////////////////////

#include <Rcpp.h>
#include <string>
using namespace Rcpp;

// Trim leading and trailing white spaces
const char* trim_str(const char* str, R_len_t len, std::string* buffer) {

  if (!str) {
    return "";
  }

  // Remove all elements
  buffer->clear();

  // If space (' '), form feed ('\f'), line feed ('\n'), carriage return ('\r'), horizontal tab ('\t'), vertical tab ('\v')
  // Pre-increment and pre-decrement 'len' and return a reference to the result
  while (std::isspace(*str)) {
    ++str; --len;
  }

  // Mutable pointer to an immutable character
  const char* pointer = str + len - 1;

  for (; pointer > str && std::isspace(*pointer); --len, --pointer);

  buffer->append(str, len);
  return buffer->c_str();
}

//' Remove leading and trailing spaces of strings in a vector (C++)
//'
//' @description
//' This function removes all leading or trailing white space, including
//' space (' '), form feed (`\f`), line feed (`\n`), carriage return (`\r'`,
//' horizontal tab (`\t`), and vertical tab (`\v`), from a character vector.
//'
//' @param s A character vector.
//'
//' @return A character vector.
//'
//' @export
//'
//' @examples
//' \donttest{
//' x <- c(" leading", "trailing ", " both ")
//' trimcpp(x)
//' }
// [[Rcpp::export]]
Vector<STRSXP> trimcpp(const Vector<STRSXP>& s) {

  // Initialize loop vars
  R_xlen_t i = 0, len = s.size();
  // Output container to avoid an unneeded initial allocation
  Vector<STRSXP> output = no_init(len);
  std::string buffer;

    for (; i < len; i++) {
      // If NA element, propagate
      if (traits::is_na<STRSXP>(s[i])) {
        output[i] = s[i];
      } else {
        output[i] = trim_str(
          s[i],
           LENGTH(s[i]),
           &buffer
        );
      }
    }

  return output;
}
