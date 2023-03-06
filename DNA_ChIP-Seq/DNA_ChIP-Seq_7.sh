inputPath=../Input/5_finalBAM/1_BWA
ChIPedPath=5_finalBAM/1_BWA
outPath=7_MACS3/1_BWA
mkdir -p  $outPath



prefix=HCT116-si7SK-H3K27me3-rp1
macs3  callpeak  --treatment  $ChIPedPath/$prefix.bam   --control  $inputPath/HCT116-si7SK-input.bam   --format BAMPE  --gsize hs  --keep-dup all     \
                 --outdir $outPath   --name  $prefix    --qvalue 0.05   --broad   >  $outPath/$prefix.runLog.txt 2>&1 

prefix=HCT116-si7SK-H3K27me3-rp2
macs3  callpeak  --treatment  $ChIPedPath/$prefix.bam   --control  $inputPath/HCT116-si7SK-input.bam   --format BAMPE  --gsize hs  --keep-dup all     \
                 --outdir $outPath   --name  $prefix    --qvalue 0.05   --broad   >  $outPath/$prefix.runLog.txt 2>&1    







prefix=HCT116-sictr-H3K27me3-rp1
macs3  callpeak  --treatment  $ChIPedPath/$prefix.bam   --control  $inputPath/HCT116-sictr-input.bam   --format BAMPE  --gsize hs  --keep-dup all     \
                 --outdir $outPath   --name  $prefix    --qvalue 0.05   --broad   >  $outPath/$prefix.runLog.txt 2>&1    

prefix=HCT116-sictr-H3K27me3-rp2
macs3  callpeak  --treatment  $ChIPedPath/$prefix.bam   --control  $inputPath/HCT116-sictr-input.bam   --format BAMPE  --gsize hs  --keep-dup all     \
                 --outdir $outPath   --name  $prefix    --qvalue 0.05   --broad   >  $outPath/$prefix.runLog.txt 2>&1    






prefix=HCT116-sipus7-H3K27me3-rp1
macs3  callpeak  --treatment  $ChIPedPath/$prefix.bam   --control  $inputPath/HCT116-siPUS7-input.bam   --format BAMPE  --gsize hs  --keep-dup all     \
                 --outdir $outPath   --name  $prefix    --qvalue 0.05   --broad   >  $outPath/$prefix.runLog.txt 2>&1    

prefix=HCT116-sipus7-H3K27me3-rp2
macs3  callpeak  --treatment  $ChIPedPath/$prefix.bam   --control  $inputPath/HCT116-siPUS7-input.bam   --format BAMPE  --gsize hs  --keep-dup all     \
                 --outdir $outPath   --name  $prefix    --qvalue 0.05   --broad   >  $outPath/$prefix.runLog.txt 2>&1    




