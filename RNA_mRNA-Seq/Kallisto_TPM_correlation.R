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

TPM_1 = as.vector( df_1[ , 5] )
TPM_2 = as.vector( df_2[ , 5] )
TPM_3 = as.vector( df_3[ , 5] )
TPM_4 = as.vector( df_4[ , 5] )
TPM_5 = as.vector( df_5[ , 5] )
TPM_6 = as.vector( df_6[ , 5] )
TPM_7 = as.vector( df_7[ , 5] )
TPM_8 = as.vector( df_8[ , 5] )
TPM_9 = as.vector( df_9[ , 5] )


bool_1 <- ( target_id_1 == target_id_1 )
bool_2 <- ( target_id_1 == target_id_2 )
bool_3 <- ( target_id_1 == target_id_3 )
bool_4 <- ( target_id_1 == target_id_4 )
bool_5 <- ( target_id_1 == target_id_5 )
bool_6 <- ( target_id_1 == target_id_6 )

length( bool_1[bool_1] )
length( bool_2[bool_2] )
length( bool_3[bool_3] )
length( bool_4[bool_4] )
length( bool_5[bool_5] )
length( bool_6[bool_6] )






AllResults_g <- "Z-FinalFigures_correlation"
if( ! file.exists(AllResults_g) ) { dir.create(path=AllResults_g, recursive = TRUE) }

matrix1 = log2( cbind( TPM_1, TPM_2, TPM_3, TPM_4, TPM_5 ,TPM_6, TPM_7, TPM_8, TPM_9   ) + 1)
matrix1[1:5, ]

length(matrix1[matrix1 >= 0])
length(matrix1[matrix1 > 10])
length(matrix1[matrix1 > 7 ])
matrix1[ matrix1 > 8 ] = 8

pdf( paste(AllResults_g, "1.same-group.different-parameters.pdf" , sep="/" )  )
pairs( matrix1  ,   col = alpha("red", 0.1),    pch = 19,   cex = 0.1 )  
dev.off()


## The function rcorr() [in Hmisc package] can be used to compute the significance levels for pearson and spearman correlations. 
## It returns both the correlation coefficients and the p-value of the correlation for all possible pairs of columns in the data table.

res2 <- rcorr(  as.matrix(matrix1, type="pearson") )
res2

my_col3=colorRampPalette( c( "cyan4",  "cyan",  "white", "red",   "red4"),  bias = 1,  space = "rgb" )

correlaton_1 = as.matrix( res2$r )
correlaton_1 = round(correlaton_1, digits = 2)

pdf( file = paste(AllResults_g, "1.heatmap.pdf", sep="/"),  width=7, height=8  )
corrplot(correlaton_1, method = "color", type = "full",  title = "", is.corr = FALSE,  order = "original",  tl.col = "black", tl.srt = 90, col = my_col3(100) )
text(  col(correlaton_1), nrow(correlaton_1)+1-row(correlaton_1),   correlaton_1, cex=1.5)
dev.off() 

pdf( file = paste(AllResults_g, "1.heatmap.cluster.pdf", sep="/"),  width=7, height=7  )
heatmap.2(x= correlaton_1 ,  dendrogram = "both",  scale =  "none" , na.rm=TRUE,  col=my_col3(100), trace = "none",  cellnote=correlaton_1 ,  notecex=1.5, notecol="black", na.color=par("bg") )    
dev.off() 











###################################
myBool = (TPM_1>0.1)

## Number of zeros of each row
numOfZero <- function(x) {
  return(length(which(x == 0)))
}
numOfZero1 = apply(matrix1,  1, numOfZero )
length(numOfZero1)
length(numOfZero1[numOfZero1>=5])
length(numOfZero1[numOfZero1 < 4])

## max of each row
rowMax1 = apply(matrix1,  1,  max, na.rm=TRUE)
length(rowMax1)
length(rowMax1[rowMax1>1])
length(rowMax1[rowMax1<=1])


mybool = ( (numOfZero1<=3) |  (rowMax1 >= 1) )
length(mybool[mybool])

matrix2A = matrix1[mybool , ]
matrix2B = matrix1[!mybool , ]
dim( matrix1)
dim( matrix2A)
dim( matrix2B)

write.table(   matrix2A , paste0(AllResults_g, "/2A.kept.txt"), quote=F, sep="\t", row.names=F, col.names=T )
write.table(   matrix2B , paste0(AllResults_g, "/2B.discard.txt"), quote=F, sep="\t", row.names=F, col.names=T )



pdf( paste(AllResults_g, "2.same-group.different-parameters.pdf" , sep="/" )  )
pairs( matrix2A  ,   col = alpha("red", 0.1),    pch = 19,   cex = 0.1 )  
dev.off()


## The function rcorr() [in Hmisc package] can be used to compute the significance levels for pearson and spearman correlations. 
## It returns both the correlation coefficients and the p-value of the correlation for all possible pairs of columns in the data table.

res2 <- rcorr(  as.matrix(matrix2A, type="pearson") )
res2

my_col3=colorRampPalette( c( "cyan4",  "cyan",  "white", "red",   "red4"),  bias = 1,  space = "rgb" )

correlaton_1 = as.matrix( res2$r )
correlaton_1 = round(correlaton_1, digits = 2)

pdf( file = paste(AllResults_g, "2.heatmap.pdf", sep="/"),  width=7, height=8  )
corrplot(correlaton_1, method = "color", type = "full",  title = "", is.corr = FALSE,  order = "original",  tl.col = "black", tl.srt = 90, col = my_col3(100) )
text(  col(correlaton_1), nrow(correlaton_1)+1-row(correlaton_1),   correlaton_1, cex=1.5)
dev.off() 

pdf( file = paste(AllResults_g, "2.heatmap.cluster.pdf", sep="/"),  width=7, height=7  )
heatmap.2(x= correlaton_1 ,  dendrogram = "both",  scale =  "none" , na.rm=TRUE,  col=my_col3(100), trace = "none",  cellnote=correlaton_1 ,  notecex=1.5, notecol="black", na.color=par("bg") )    
dev.off() 









