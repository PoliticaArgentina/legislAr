#' Obtener datos crudos de La Década Votata
#' (\emph{Download bill raw data})
#'
#'@description
#' Función que devuelve una \emph{list} con las bases de datos crudas disponible
#'
#'@param chamber parámetro para elegir entre las cámaras de 'diputados' o 'senadores'
#'
#'
#' @seealso  \link{show_available_bills}
#'
#' @export


get_bill_data <-function(chamber = NULL){


  ## Check for internet conection
  attempt::stop_if_not(.x = curl::has_internet(),
                       msg = "Internet access was not detected. Please check your connection //
No se detecto acceso a internet. Por favor chequear la conexion.")


  assertthat::assert_that(!is.null(chamber),
                          msg = "chamber can not be NULL. You should choose between 'diputados' or 'senadores'" )
  assertthat::assert_that(chamber %in% c('diputados', 'senadores'),
                          msg = glue::glue("{chamber} is not a valid option. Choose 'diputados' or 'senadores' instead"))


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

  if(is.null(default)){

    df <- base::message("Fail to download data. Source is not available // La fuente de datos no esta disponible")

  } else {


    df

    }
  }
