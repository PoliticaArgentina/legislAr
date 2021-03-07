#' \code{legislAr} package
#'
#' Caja de Herramientas para el trabajo con datos legislativos de Argentina
#' See the README on
#' \href{https://github.com/PoliticaArgentina/legislAr/README.md}{Github}
#'
#' @docType package
#' @name legislAr
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines

if(getRversion() >= "2.15.1")
  utils::globalVariables(c("camara",
                           "colour",
                           "fecha",
                           "id",
                           "n",
                           "party_long",
                           "party_short",
                           "seats",
                           "value",
                           "x", "y"))
