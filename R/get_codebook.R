#' Obtener libro de códigos de bases crudas del proyecto la 'Década Votada'
#' (\emph{Get datasets codebooks})
#'
#' @param base define el libro de códigos a descargar del conjunto de conjunto de datos disponibles: 'bloques', 'diputados', 'votacion' o 'asuntos'
#'
#' @return a "tbl_df" "tbl" "data.frame" object
#' @export


get_codebook <- function(base = NULL){

  ## Check for internet conection
  attempt::stop_if_not(.x = curl::has_internet(),
                       msg = "Internet access was not detected. Please check your connection //
No se detecto acceso a internet. Por favor chequear la conexion.")


  assertthat::assert_that(!is.null(base),
                          msg = "'base' can not be NULL. You should choose between 'bloques', 'diputados', 'votacion' or 'asuntos'" )


  assertthat::assert_that(base %in% c('bloques', 'diputados', 'votacion', 'asuntos'),
                          msg = glue::glue("{base} is not a valid option. Choose 'bloques', 'votaciones' , 'asuntos' or 'diputados' instead" ))


      temp <- codebook %>%
        dplyr::filter(base == 'diputados')


       temp <- purrr::pluck(temp$data)[[1]]

      return(temp)
  }
