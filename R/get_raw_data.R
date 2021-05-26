#' Obtener datos crudos de La Década Votada
#' (\emph{Download bill raw data})
#'
#'@description
#' Funcion que devuelve una \emph{list} con las bases de datos crudas disponible
#'
#'@param chamber parámetro para elegir entre las cámaras de 'diputados' o 'senadores'
#'
#'@param base parámetro para definir que base de datos descargar. Las opciones son  'bloques', 'votaciones', 'asuntos' y  'diputados'. El valor por defecto NULL devuelve las tres bases disponibles.
#'
#' @seealso  \link{show_available_bills}
#'
#' @export


get_raw_data <-function(chamber = NULL,
                        base = NULL){



          base <-   if(is.null(base)) {

                          "all"

                        } else {

                          base
                        }


  ## Check for internet conection
  attempt::stop_if_not(.x = curl::has_internet(),
                       msg = "Internet access was not detected. Please check your connection //
No se detecto acceso a internet. Por favor chequear la conexion.")


  assertthat::assert_that(!is.null(chamber),
                          msg = "'chamber' can not be NULL. You should choose between 'diputados' or 'senadores'" )

  assertthat::assert_that(chamber %in% c('diputados', 'senadores'),
                          msg = glue::glue("{chamber} is not a valid option. Choose 'diputados' or 'senadores' instead"))


  assertthat::assert_that(base %in% c('bloques', 'diputados', 'votacion', 'asuntos', 'all'),
                          msg = glue::glue("{base} is not a valid option. Choose 'bloques', 'votaciones' , 'asuntos' or 'diputados' instead" ))




  # GET INDIVIDUAL VOTES

  url_votaciones <- glue::glue("https://github.com/PoliticaArgentina/data_warehouse/raw/master/legislAr/data_raw/votaciones-{chamber}.csv")

  # PARTIES DATA
  url_bloques <- glue::glue("https://github.com/PoliticaArgentina/data_warehouse/raw/master/legislAr/data_raw/bloques-{chamber}.csv")

  # LEGIS DATA
  url_diputados <- glue::glue("https://github.com/PoliticaArgentina/data_warehouse/raw/master/legislAr/data_raw/diputados-{chamber}.csv")

  # GET BILL LIST AND RESULTS

  url_asuntos <- glue::glue("https://github.com/PoliticaArgentina/data_warehouse/raw/master/legislAr/data_raw/asuntos-{chamber}.csv")



  # Set default value for try()

  default <- NULL


  ########### DOWNLOAD ALL DATASETS


df <-   if(base == "all"){


  data <- tibble::tibble(url = c(url_bloques,
                                 url_diputados,
                                 url_votaciones,
                                 url_asuntos),
                         base = c('bloques',
                                  'diputados',
                                  'votaciones',
                                  'asuntos'))


      df <- base::suppressWarnings(base::suppressMessages(base::try(default <- data %>%
                                                                  dplyr::mutate(data = purrr::map(.x = data$url, .f = ~ vroom::vroom(file = .x,
                                                                                                                         col_names = FALSE,
                                                                                                                         col_types = NULL,
                                                                                                                         progress = FALSE ))), silent = TRUE)
                                                      ))




                if(is.null(default)){

                  df <- base::message("Fail to download data. Source is not available // La fuente de datos no esta disponible")


                } else {


                  df %>%
                    dplyr::select(base, data)


                }

      } else {

    ########### INDIVIDUAL DATA SET DOWNLOAD

        # PARAM base -> URL

        url <- dplyr::case_when(
          base == 'bloques' ~ url_bloques,
          base == 'diputados' ~ url_diputados,
          base == 'votaciones' ~ url_votaciones,
          base == 'asuntos' ~ url_asuntos)


      df <- base::suppressWarnings(base::suppressMessages(base::try(default <- vroom::vroom(file = url,
                                                                                            col_names = FALSE,
                                                                                            col_types = NULL,
                                                                                            progress = FALSE ), silent = TRUE)
                                                          ))



      if(is.null(default)){

        df <- base::message("Fail to download data. Source is not available // La fuente de datos no esta disponible")


                    } else {

                    df


                      }

          }




# download message one per session hack
if(base::getOption('descarga-decadavotada', TRUE)){


  message(glue::glue("Los datos fueron obtenidos del proyecto 'Decada Votada' de Andy Tow el {format(Sys.Date(), '%d %B de %Y')}. La documentacion y el libro de codigos se encuetra disponible en https://decadavotada.andytow.com/doc.html"))

  options('descarga-decadavotada' = FALSE)

}



      return(df)
}

