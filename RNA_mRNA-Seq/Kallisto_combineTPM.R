suppressPackageStartupMessages( library(ggplot2)  )
suppressPackageStartupMessages( library(scales) )
suppressPackageStartupMessages( library(corrplot) )
suppressPackageStartupMessages( library(gplots) )
suppressPackageStartupMessages( library(Hmisc) )




###########################################################################################################################################################################
df_1 <- read.table("HCT116-mRNA-seq-si7sk-1.3.rf/abundance.tsv",   header=T,   sep="\t" )  
df_2 <- read.table("HCT116-mRNA-seq-si7sk-2.3.rf/abundance.tsv",   header=T,   sep="\t" )  
df_3 <- read.table("HCT116-mRNA-seq-si7sk-3.3.rf/abundance.tsv",   header=T,   sep="\t" )  
df_4 <- read.table("HCT116-mRNA-seq-sicon-1.3.rf/abundance.tsv",   header=T,   sep="\t" )  
df_5 <- read.table("HCT116-mRNA-seq-sicon-2.3.rf/abundance.tsv",   header=T,   sep="\t" )  
df_6 <- read.table("HCT116-mRNA-seq-sicon-3.3.rf/abundance.tsv",   header=T,   sep="\t" )  
df_7 <- read.table("HCT116-mRNA-seq-sipus7-1.3.rf/abundance.tsv",  header=T,   sep="\t" )  
df_8 <- read.table("HCT116-mRNA-seq-sipus7-2.3.rf/abundance.tsv",  header=T,   sep="\t" )  
df_9 <- read.table("HCT116-mRNA-seq-sipus7-3.3.rf/abundance.tsv",  header=T,   sep="\t" )  

dim( df_1 )
dim( df_2 )
dim( df_3 )
dim( df_4 )
dim( df_5 )
dim( df_6 )
dim( df_7 )
dim( df_8 )
dim( df_9 )

colnames(df_1) = paste( "si-7sk-1",  colnames(df_1),  sep="_")
colnames(df_2) = paste( "si-7sk-2",  colnames(df_2),  sep="_")
colnames(df_3) = paste( "si-7sk-3",  colnames(df_3),  sep="_")
colnames(df_4) = paste( "si-Ctrl-1",  colnames(df_4),  sep="_")
colnames(df_5) = paste( "si-Ctrl-2",  colnames(df_5),  sep="_")
colnames(df_6) = paste( "si-Ctrl-3",  colnames(df_6),  sep="_")
colnames(df_7) = paste( "si-PUS7-1",  colnames(df_7),  sep="_")
colnames(df_8) = paste( "si-PUS7-2",  colnames(df_8),  sep="_")
colnames(df_9) = paste( "si-PUS7-3",  colnames(df_9),  sep="_")

df_1[1:5 , ]
df_2[1:5 , ]
df_3[1:5 , ]
df_4[1:5 , ]
df_5[1:5 , ]
df_6[1:5 , ]
df_7[1:5 , ]
df_8[1:5 , ]
df_9[1:5 , ]

target_id_1 = as.vector( df_1[ , 1] )
target_id_2 = as.vector( df_2[ , 1] )
target_id_3 = as.vector( df_3[ , 1] )
target_id_4 = as.vector( df_4[ , 1] )
target_id_5 = as.vector( df_5[ , 1] )
target_id_6 = as.vector( df_6[ , 1] )
target_id_7 = as.vector( df_7[ , 1] )
target_id_8 = as.vector( df_8[ , 1] )
target_id_9 = as.vector( df_9[ , 1] )


bool_1 <- ( target_id_1 == target_id_1 )
bool_2 <- ( target_id_1 == target_id_2 )
bool_3 <- ( target_id_1 == target_id_3 )
bool_4 <- ( target_id_1 == target_id_4 )
bool_5 <- ( target_id_1 == target_id_5 )
bool_6 <- ( target_id_1 == target_id_6 )
bool_7 <- ( target_id_1 == target_id_7 )
bool_8 <- ( target_id_1 == target_id_8 )
bool_9 <- ( target_id_1 == target_id_9 )

length( bool_1[bool_1] )
length( bool_2[bool_2] )
length( bool_3[bool_3] )
length( bool_4[bool_4] )
length( bool_5[bool_5] )
length( bool_6[bool_6] )
length( bool_4[bool_7] )
length( bool_5[bool_8] )
length( bool_6[bool_9] )






AllResults_g <- "Z-FinalFigures_TPM"
if( ! file.exists(AllResults_g) ) { dir.create(path=AllResults_g, recursive = TRUE) }

matrix1 =  cbind( df_1, df_2[,-1], df_3[,-1], df_4[,-1], df_5[,-1] ,df_6[,-1], df_7[,-1], df_8[,-1], df_9[,-1]   )  

write.table(   matrix1 , paste0(AllResults_g, "/allSamples.TPM.txt"),    quote=F, sep="\t", row.names=F, col.names=T )
 
 





