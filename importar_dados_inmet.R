library(shiny)
library(RCurl)
library(DT)
library(sp)
library(rgdal)
library(rgeos)
library(raster)
library(gstat)
library(leaflet)
library(mapview)
library(ggplot2)
library(magick)
############################################
#######IMPORTAR DADOS ESTACOES INMET########
############################################
sarif <- getURL('ftp://ftpupload.net/htdocs/dados/SARIF.txt', userpwd='epiz_24386438:BPkSG73NVw')
dados_inmet <- read.delim(textConnection(sarif))
write.table(dados_inmet,'sarif.txt')
dados_inmet <- dados_inmet[,c(1,3,6,7,11,12)]
colnames(dados_inmet) <- c('Data','POSTO','LAT','LONG','Umidmin','Chuva')
dados_inmet$Chuva <- as.numeric(gsub(',','.',trimws(dados_inmet$Chuva)))
dados_inmet$Umidmin <- as.numeric(gsub(',','.',trimws(dados_inmet$Umidmin)))
dados_inmet$Data <- as.Date(dados_inmet$Data,"%d/%m/%Y")
dados_inmet$LAT <- as.numeric(gsub(',','.',trimws(dados_inmet$LAT)))
dados_inmet$LONG <- as.numeric(gsub(',','.',trimws(dados_inmet$LONG)))
dados_inmet$FONTE <- 'Inmet'
dados_inmet <- subset(dados_inmet, !is.na(dados_inmet$Chuva))
# Definir parâmetros de SIG
coordinates(dados_inmet) <- ~LONG+LAT
proj4string(dados_inmet) <- CRS("+init=epsg:4326")
dados_inmet$Longitude <- coordinates(dados_inmet)[,1]
dados_inmet$Latitude <- coordinates(dados_inmet)[,2]
# Remover objetos desnecessários
rm(sarif)
write.table(dados_inmet,'~/Sergio/Monitoramento de risco de incendios/dados_inmet.txt')
