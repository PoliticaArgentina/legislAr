#' Diccionario de proyectos de ley sometidos a votación
#' (\emph{Bills collection})
#'
#'@description
#' Función que devuelve un \emph{data.frame} listado de proyectos de ley con un id por proyecto y cámara legislativa
#'
#'@param viewer Por default es \code{TRUE} y  muestra una tabla formateada en el \emph{Viewer} de \emph{RStudio}. Cuando \code{FALSE} imprime en consola.
#'
#'@param chamber parámetro para elegir entre las cámaras de 'diputados' o 'senadores'
#'
#'
#' @examples
#'
#' show_available_bills(chamber = 'senadores' , viewer = FALSE)
#'
#'
#' @seealso  \link{get_bill_votes}
#'
#' @export




show_available_bills <- function(chamber = NULL,
                                 viewer = FALSE){

  assertthat::assert_that(!is.null(chamber),
                          msg = "chamber can not be NULL. You should choose between 'diputados' or 'senadores'" )
  assertthat::assert_that(chamber %in% c('diputados', 'senadores'),
                          msg = glue::glue("{chamber} is not a valid option. Choose 'diputados' or 'senadores' instead"))



  url <-  glue::glue("https://github.com/PoliticaArgentina/data_warehouse/raw/master/legislAr/data_raw/asuntos-{chamber}.csv")


  # Set default value for try()

  default <- NULL

  df <- base::suppressWarnings(base::try(default <- vroom::vroom(file = url,
                                                                 col_names = FALSE,
                                                                 col_select = c(id = 1,
                                                                                fecha = 5,
                                                                                descripcion = 17)),
                                         vroom::cols(),
                                         silent = TRUE))

  if(is.null(default)){

    df <- base::message("Fail to download data. Source is not available // La fuente de datos no esta disponible")

  } else {


  df <- df %>%
    dplyr::mutate(id = as.character(glue::glue("{id}-{toupper(chamber)}")),
                  fecha = lubridate::as_date(fecha),
                  noth = lubridate::month(fecha),
                  year= lubridate::year(fecha)) %>%
    dplyr::select(-c(fecha))



  if (viewer == TRUE) {

    df %>%
      DT::datatable(options = list(
        language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Spanish.json')))

  }else{

    df

    }

   }
}


