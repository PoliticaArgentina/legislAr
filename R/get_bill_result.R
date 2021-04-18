#' Obtiene el resultado de la votación de un proyecto de leu
#'
#' @param bill identificador del proyecto de ley que se obtiene con \link{show_available_bills}
#'
#' @export
#'

        get_bill_result <- function(bill = NULL){

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

                  # BILL DATA
                  url <- glue::glue("https://github.com/PoliticaArgentina/data_warehouse/raw/master/legislAr/data_raw/asuntos-{chamber}.csv")


                  # Set default value for try()

                  default <- NULL

                  df <- base::suppressWarnings(base::suppressMessages(base::try(default <-  vroom::vroom(file = url,
                                                                                                         col_names = FALSE,
                                                                                                         col_types = NULL,
                                                                                                         progress = FALSE ), silent = TRUE)
                  ))




                  if(is.null(default)){

                    base::message("Fail to download data. Source is not available // La fuente de datos no esta disponible")

                  } else {

                   df %>%
                      dplyr::select(id = 1,
                                    sesion = 2,
                                    asunto = 3,
                                    fecha = 5,
                                    base = 7,
                                    mayoria = 8,
                                    resultado = 9,
                                    presentes = 11,
                                    ausentes = 12,
                                    abstenciones = 13,
                                    afirmativos = 14,
                                    negativos = 15,
                                    voto_presidente = 16,
                                    titulo =17)  %>%
                      dplyr::filter(paste0(id, "-", toupper(chamber)) == bill) %>%
                      tidyr::pivot_longer(cols = c(presentes:negativos), names_to = "voto", values_to = "n")







                      }
                  }
