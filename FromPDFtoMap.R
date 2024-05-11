# Cargar los paquetes tidyverse y pdftools
require(tidyverse)
require(pdftools)

# Definir la ubicación del archivo PDF
QQ = "C:/Users/jucar/BBOC1342-Sam.pdf"

# Extraer el texto del PDF y dividirlo por líneas
PDF = pdf_text(QQ) %>% str_split('\n')

# Crear un dataframe con las líneas específicas del texto del PDF
PDF2 = data.frame(PDF[[3]][7:18])

# Renombrar la columna del dataframe como "Info"
colnames(PDF2) = "Info"

# Mostrar las dimensiones y las primeras filas del dataframe PDF2
dim(PDF2)
head(PDF2)

# Limpiar la información eliminando espacios adicionales
PDF2.1 = data.frame(gsub("\\s+", " ", PDF2$Info))

# Seleccionar un rango específico de filas y columnas
PDF2.1 = data.frame(PDF2.1[2:12,])

# Renombrar la columna del dataframe como "Info"
colnames(PDF2.1) = "Info"

# Mostrar las dimensiones y el dataframe después de los cambios
dim(PDF2.1)
PDF2.1

# Reemplazar valores específicos en la columna "Info"
PDF2.1$Info = gsub("Bruno Sawmill",
                   "Bruno-Sawmill",
                   PDF2.1$Info)

PDF2.1$Info = gsub("Kombuno Mambuno",
                   "Kombuno-Mambuno",
                   PDF2.1$Info)

PDF2.1$Info = gsub("Lake Aunde",
                   "Lake-Aunde",
                   PDF2.1$Info)

# Mostrar las dimensiones y el dataframe después de los cambios
dim(PDF2.1)
PDF2.1

# Cargar el paquete tidyr
require(tidyr)

# Separar la columna "Info" en múltiples columnas
Sd = separate(PDF2.1, Info,
              into = c("Site", "Elev",
                       "Lat", "Lon"),
              sep = " ")

# Eliminar filas con valores NA
Sd = na.omit(Sd)

# Limpiar las columnas de longitud, latitud y elevación
Sd$Lon = gsub("[,°’ ”]|[[:upper:]]+", " ", Sd$Lon)
Sd$Lat = gsub("[,°’ ”]|[[:upper:]]+", " ", Sd$Lat)
Sd$Elev = gsub("[,]", "", Sd$Elev)

# Eliminar espacios extras al final de las columnas de longitud y latitud
Sd$Lon = trimws(Sd$Lon, "right")
Sd$Lat = trimws(Sd$Lat, "right")

# Mostrar la estructura del dataframe
str(Sd)

# Cargar el paquete measurements y convertir las coordenadas de grados, minutos y segundos a grados decimales
require(measurements)
for(i in rownames(Sd[,3:4])){
  for(j in colnames(Sd[,3:4])){
    Sd[i,j] = conv_unit(Sd[i,j],
                        from = "deg_min_sec",
                        to = "dec_deg")
  }
}

# Redondear las coordenadas a 4 dígitos significativos y ajustar el signo de latitud
Sd$Lon = signif(as.numeric(Sd$Lon),
                digits = 4)
Sd$Lat = signif(as.numeric(Sd$Lat),
                digits = 4)
Sd$Lat = Sd$Lat * -1

# Mostrar el dataframe después de los cambios
Sd

# Reordenar las columnas del dataframe
Sd = Sd[,c(1,4,3,2)]
Sd

# Cargar un archivo de datos previamente guardado
load("QMap.Rdata")

# Graficar los datos en un mapa con un ángulo de 50 grados
QMap(Sd, angle = 50)
