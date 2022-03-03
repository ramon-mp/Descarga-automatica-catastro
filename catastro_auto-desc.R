#------------------------------------------------------------------------------#
# Descarga automatica de informacion catastral                                 #
# Parcela catastral (CP) y Edificios (BU)                                      #
# Autor: Ramon Molinero-Parejo                                                 #
# Fecha: 03/03/2022                                                            #
# Version: 1.0                                                                 #
#------------------------------------------------------------------------------#

##PARAMETROS REQUERIDOS####

# establecer directorio de trabajo
setwd('D:/')

# codigo de la provincia que se va a descargar
cod_post <- '18'

# tipo de archivos que se quieren descargar 
# | BU - Edificios | CP - Parcelas catastrales | BOTH - Ambos |
file_download <- 'BU'

#------------------------------------------------------------------------------#
##MODULO DE DESCARGA####

# lectura .csv lista de municipios
df <- read.csv('list-muni.csv', 
               sep = ',', 
               encoding = 'UTF-8', 
               colClasses = 'character')

# seleccion municipios provincia seleccionada
df <- df[df$CPROV == cod_post, ]

# url del catastro inspire  
url_a <- 'http://www.catastro.minhap.es/INSPIRE/'
url_b <- '/A.ES.SDGC.'

# descarga edificios
if (file_download == 'BU'){
  for (row in 1:nrow(df)){
    cprov <- df[row, 'CPROV']
    municipio <- df[row, 'MUNICIPIO']
    cp <- df[row, 'CP']
    url <- paste0(url_a, 'Buildings/', cprov, '/', 
                  municipio, url_b, 'BU.', cp, '.zip')
    print(url)
    tryCatch(
      download.file(url = url, destfile = paste0(municipio, '-BU', '.zip')),
      finally = next
    )
  }
} 

# descarga parcelas catastrales
if (file_download == 'CP'){
  for (row in 1:nrow(df)){
    cprov <- df[row, 'CPROV']
    municipio <- df[row, 'MUNICIPIO']
    cp <- df[row, 'CP']
    url <- paste0(url_a, 'CadastralParcels/', cprov, '/', 
                  municipio, url_b, 'CP.', cp, '.zip')
    tryCatch(
      download.file(url = url, destfile = paste0(municipio, '-CP', '.zip')),
      finally = next
    )
  }
}

# descarga ambos
if (file_download == 'BOTH'){
  for (row in 1:nrow(df)){
    cprov <- df[row, 'CPROV']
    municipio <- df[row, 'MUNICIPIO']
    cp <- df[row, 'CP']
    url_bu <- paste0(url_a, 'Buildings/', cprov, '/', 
                  municipio, url_b, 'BU.', cp, '.zip')
    url_cp <- paste0(url_a, 'CadastralParcels/', cprov, '/', 
                     municipio, url_b, 'CP.', cp, '.zip')
    tryCatch(
      c(
      download.file(url = url_bu, destfile = paste0(municipio, '-BU', '.zip')),
      download.file(url = url_cp, destfile = paste0(municipio, '-CP', '.zip'))
      ),
      finally = next
    )
  }
}
#------------------------------------------------------------------------------#



