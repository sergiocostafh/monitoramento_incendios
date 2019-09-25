library(readxl)
library(foreign)
library(dplyr)

# Importar dados
dados_cpo <- read_excel("//brcttfs/Grupos/Monitoramento_Florestal/Pluviometria/Pluviometria 13HRS_Relatorios_Incendios_CT__2019.xlsx",
                       sheet = 'CALCULO', skip = 2)
dados_moc <- read_excel("//brsgsfs/Geral/Protecao_Patrimonial/Incêndios/Incendios 2019/Relatorios_Incendios_Mocambo_2019.xls",
                        sheet = 'Calculo', skip = 2)
dados_mor <- read_excel("//brsgsfs/Geral/Protecao_Patrimonial/Incêndios/Incendios 2019/Relatorios_Incendios_Morungava_2019.xls",
                        sheet = 'Calculo', skip = 2)
#dados_cq <- read_excel("//brarafs/Florestal/Florestal_Comum/REFLORESTAMENTO/PASTA SILVICULTURA 2019/DADOS ESTAÇÃO/Relatórios Horto CQ 2019.xls",
#                       sheet = format(Sys.time(), '%b'), skip = 14)
dados_cq <- read_excel("~/Sergio/Monitoramento de risco de incendios/Modelo planilha/Risco de Incendio APO 2019.xlsx",
                       sheet = 'CQ', skip = 2)
dados_ct <- read_excel("~/Sergio/Monitoramento de risco de incendios/Modelo planilha/Risco de Incendio APO 2019.xlsx",
                       sheet = 'CT', skip = 2)
dados_sn <- read_excel("~/Sergio/Monitoramento de risco de incendios/Modelo planilha/Risco de Incendio APO 2019.xlsx",
                       sheet = 'SN e BM', skip = 2)
# Formatar dados
coords_arauco <- read.dbf('estacoes_arauco.dbf')
colnames(dados_cpo) <- c('Data','Umidmin', 'Chuva')
dados_cpo <- dados_cpo[,1:3]
head(dados_moc)
colnames(dados_moc) <- c('Data','Umidmin', 'Chuva')
dados_moc <- dados_moc[,1:3]
colnames(dados_mor) <- c('Data','Umidmin', 'Chuva')
dados_mor <- dados_mor[,1:3]
colnames(dados_cq) <- c('Data','Umidmin', 'Chuva')
dados_cq <- dados_cq[,1:3]
colnames(dados_ct) <- c('Data','Umidmin', 'Chuva')
dados_ct <- dados_ct[,1:3]
colnames(dados_sn) <- c('Data','Umidmin', 'Chuva')
dados_sn <- dados_sn[,1:3]
dados_mor$Data <- as.Date(as.numeric(dados_mor$Data), origin = "1899-12-30")
dados_moc$Data <- as.Date(as.numeric(dados_moc$Data), origin = "1899-12-30")
dados_cpo$Data <- as.Date(dados_cpo$Data)
dados_ct$Data <- as.Date(dados_ct$Data)
dados_cq$Data <- as.Date(dados_cq$Data)
dados_sn$Data <- as.Date(dados_sn$Data)
dados_ct$Chuva <- as.numeric(dados_ct$Chuva)
dados_cpo$POSTO <- 'CPO'
dados_mor$POSTO <- 'MOR'
dados_moc$POSTO <- 'MOC'
dados_cq$POSTO <- 'CQ'
dados_ct$POSTO <- 'CT'
dados_sn$POSTO <- 'SN'
# Unir dados
dados_arauco <- list(cpo = dados_cpo,
                 moc = dados_moc,
                 mor = dados_mor,
                 cq = dados_cq,
                 ct = dados_ct,
                 sn = dados_sn)
dados_arauco <- bind_rows(dados_arauco)
dados_arauco <- subset(dados_arauco, !is.na(dados_arauco$Chuva))
dados_arauco$FONTE <- 'Arauco'
# Definir parâmetros de SIG
dados_arauco$LAT <- coords_arauco$lat[match(dados_arauco$POSTO,coords_arauco$POSTO)]
dados_arauco$LONG <- coords_arauco$long[match(dados_arauco$POSTO,coords_arauco$POSTO)]
coordinates(dados_arauco) <- ~LONG+LAT
proj4string(dados_arauco) <- CRS("+init=epsg:4326")
dados_arauco$Longitude <- coordinates(dados_arauco)[,1]
dados_arauco$Latitude <- coordinates(dados_arauco)[,2]
# Remover objetos desnecessários
rm(dados_cpo,dados_cq,dados_ct,dados_moc,dados_mor,dados_sn, coords_arauco)
write.table(dados_arauco,'~/Sergio/Monitoramento de risco de incendios/dados_arauco.txt')
