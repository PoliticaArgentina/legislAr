#' Obtener votos de un proyecto de ley
#' (\emph{Download bill vote data})
#'
#'@description
#' Función que devuelve un \emph{data.frame} con el detalle de los votos individuales de los legisladores a un proyecto de ley.
#'
#'@param bill Parámetro en el que se especifica el id del proyecto obtenido con \code{\link{show_available_bills}}
#'
#' @examples
#'
#' get_bill_votes(bill = "2218-DIPUTADOS")
#'
#' @seealso  \link{show_available_bills}
#'
#' @export


get_bill_votes <- function(bill = NULL){

  ## Check for internet conection
  attempt::stop_if_not(.x = curl::has_internet(),
                       msg = "Internet access was not detected. Please check your connection //
No se detecto acceso a internet. Por favor chequear la conexion.")

  # DETECT CHAMBER
          chamber <- if(stringr::str_detect(bill, "DIPU", )){
            'diputados'
          } else {
            'senadores'
          }


 # GET INDIVIDUAL VOTES by Chamber parameter

 url_votacion <- glue::glue("https://github.com/PoliticaArgentina/data_warehouse/raw/master/legislAr/data_raw/votaciones-{chamber}.csv")

 # PARTIES DATA
 url_bloques <- glue::glue("https://github.com/PoliticaArgentina/data_warehouse/raw/master/legislAr/data_raw/bloques-{chamber}.csv")

 # LEGIS DATA
 url_legislador <- glue::glue("https://github.com/PoliticaArgentina/data_warehouse/raw/master/legislAr/data_raw/diputados-{chamber}.csv")



  data <- tibble::tibble( url = c(url_bloques,
                                url_legislador,
                                url_votacion))


  # Set default value for try()

  default <- NULL

  df <- base::suppressWarnings(base::suppressMessages(base::try(default <- purrr::map(.x = data$url, .f = ~ vroom::vroom(file = .x,
                                               col_names = FALSE,
                                               col_types = NULL,
                                               progress = FALSE )), silent = TRUE)
                                               ))




output <-   if(is.null(default)){

     base::message("Fail to download data. Source is not available // La fuente de datos no esta disponible")

            } else {


      df <- base::suppressWarnings(df)


    bloques <- df[[1]] %>%
      dplyr::select(bloque_id = 1,
                    nombre_bloque = 2,
                    color_bloque = 3)

    legisladores <- df[[2]] %>%
      dplyr::select(legis_id = 1,
                    nombre_legislador = 2,
                    provincia = 3,
                    color_bloque = 4)

    votacion <- df[[3]] %>%
      dplyr::select(id = 1,
                    legis_id = 2,
                    bloque_id = 3,
                    voto = 4) %>%
      dplyr::filter(paste0(id, "-", toupper(chamber)) == bill)

  # JOIN DATASETS

  votacion %>%
    dplyr::left_join(bloques,
                     by = 'bloque_id') %>%
    dplyr::left_join(legisladores,
                     by = 'legis_id') %>%
    dplyr::select(-c(dplyr::contains(match = 'id'),
                     dplyr::contains(match = 'color'))) %>%
    dplyr::mutate(voto = dplyr::case_when(
      voto  == 0 ~ 'AFIRMATIVO',
      voto  == 1 ~ 'NEGATIVO',
      voto  == 2 ~ 'ABSTENCION',
      voto  == 3 ~ 'AUSENTE', TRUE ~ 'PRESIDENTE'))



  }



base::suppressWarnings(output)


}

