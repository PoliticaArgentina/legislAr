
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/opinAr)](https://CRAN.R-project.org/package=opinAr)
[![R build
status](https://github.com/PoliticaArgentina/opinAr/workflows/R-CMD-check/badge.svg)](https://github.com/PoliticaArgentina/opinAr/actions)

<!-- badges: end -->

## Datos `legisla`tivos de `Ar`rgentina usando `R` <a><img src="man/figures/logo.png" width="200" align="right" /></a>

------------------------------------------------------------------------

### INSTALACIÓN

### Versión en desarrollo (*Development version*)

``` r
# install.packages('devtools') si no tiene instalado devtools

devtools::install_github("politicaargentina/legislAr")
```

------------------------------------------------------------------------

El paquete está pensado para facilitar la exploración de datos
compartidos por Andy Tow en su proyecto [*La Década
Votada*](https://andytow.com/scripts/disciplina/index-d.html) en cuya
[documentación](https://andytow.com/scripts/disciplina/doc.html) se
detallan las bases de datos disponibilizadas, sus campos y
descripciones.

![](https://andytow.com/scripts/disciplina/assets/img/votaciones.gif)

### Ejemplo de uso (*Usage*)

``` r
library(legislAr)


(data <- show_available_bills(chamber = 'diputados')) # Preview avialable data 
#> # A tibble: 2,491 x 4
#>    id          description                                           month  year
#>    <chr>       <chr>                                                 <dbl> <dbl>
#>  1 2335-DIPUT~ Expediente 719-D-19 de ley. Declárase como Capital N~     4  2019
#>  2 2334-DIPUT~ Expediente 1259-D-2018 de ley. Institúyase el 21 de ~     4  2019
#>  3 2333-DIPUT~ Expediente 3309-D-2018 de ley. Declárase el primero ~     4  2019
#>  4 2214-DIPUT~ Simplificación y desburocratización para el desarrol~     3  2018
#>  5 2215-DIPUT~ Simplificación y desburocratización para el desarrol~     3  2018
#>  6 2216-DIPUT~ Simplificación y desburocratización de la administra~     3  2018
#>  7 2217-DIPUT~ Solicitud de Tratamiento sobre Tablas solicitado por~     3  2018
#>  8 2218-DIPUT~ Habilitar el Tratamiento del Expediente 2133-D-2018.~     4  2018
#>  9 2219-DIPUT~ Habilitar el Tratamiento del Expediente 2142-D-2018.~     4  2018
#> 10 2220-DIPUT~ Habilitar el Tratamiento del Expediente 1818-D-2018.~     4  2018
#> # ... with 2,481 more rows

# busco votación en particular: tratamiento del diploma del genocida Bussi en la cámara de Diputados 
(bussi <- data %>% 
  dplyr::filter(stringr::str_detect(string = description, 
                      pattern = 'Bussi')))
#> # A tibble: 2 x 4
#>   id          description                                            month  year
#>   <chr>       <chr>                                                  <dbl> <dbl>
#> 1 179-DIPUTA~ Proceder a la Apertura del sobre que contiene la Decl~     2  1998
#> 2 244-DIPUTA~ Rechazo del Diploma del Diputado Electo por el Distri~     5  2000

# explorar resultado
  get_bill_result(bill = '244-DIPUTADOS') %>% 
    dplyr::select(voto, n)
#> # A tibble: 5 x 2
#>   voto             n
#>   <chr>        <dbl>
#> 1 presentes      191
#> 2 ausentes        66
#> 3 abstenciones     2
#> 4 afirmativos    181
#> 5 negativos        7

# descargo los votos individuales
  get_bill_votes(bill = '244-DIPUTADOS') 
#> Warning: One or more parsing issues, see `problems()` for details
#> # A tibble: 257 x 4
#>    voto       nombre_bloque           nombre_legislador          provincia      
#>    <chr>      <chr>                   <chr>                      <chr>          
#>  1 AFIRMATIVO Acción por la República FERRERO, Fernanda          Cdad.Aut.Bs.As.
#>  2 AFIRMATIVO FREPASO                 ALESSANDRO, Dario Pedro    Cdad.Aut.Bs.As.
#>  3 AFIRMATIVO FREPASO                 BRAVO, Alfredo Pedro       Cdad.Aut.Bs.As.
#>  4 AFIRMATIVO FREPASO                 GARRÉ, Nilda Celia         Cdad.Aut.Bs.As.
#>  5 AFIRMATIVO FREPASO                 GONZALEZ, María América    Cdad.Aut.Bs.As.
#>  6 AFIRMATIVO FREPASO                 LANZA, José Luis           Cdad.Aut.Bs.As.
#>  7 AFIRMATIVO FREPASO                 PARENTELLA, Irma Fidela    Cdad.Aut.Bs.As.
#>  8 AFIRMATIVO FREPASO                 POLINO, Hector Teodoro     Cdad.Aut.Bs.As.
#>  9 AFIRMATIVO FREPASO                 PUIGGROS, Adriana Victoria Cdad.Aut.Bs.As.
#> 10 AFIRMATIVO Justicialista           MOURIÑO, Javier            Cdad.Aut.Bs.As.
#> # ... with 247 more rows
```

## `{legislAr}` es parte del universo de paquetes **polAr**

<img src="https://github.com/PoliticaArgentina/data_warehouse/raw/master/hex/collage.png" width="100%" />
