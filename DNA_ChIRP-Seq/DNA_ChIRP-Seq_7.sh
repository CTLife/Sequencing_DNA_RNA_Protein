inputPath=5_finalBAM/1_BWA
ChIPedPath=5_finalBAM/1_BWA
outPath=7_MACS3/1_BWA
mkdir -p  $outPath



prefix=HCT116-7SK-CHIRP-even.sictr-1
macs3  callpeak  --treatment  $ChIPedPath/$prefix.bam   --control  $inputPath/HCT116-7SK-CHIRP-input.sictr-1.bam   --format BAMPE  --gsize hs  --keep-dup all     \
                 --outdir $outPath   --name  $prefix    --qvalue 0.05   --broad   >  $outPath/$prefix.runLog.txt 2>&1 

prefix=HCT116-7SK-CHIRP-even.sictr-2
macs3  callpeak  --treatment  $ChIPedPath/$prefix.bam   --control  $inputPath/HCT116-7SK-CHIRP-input.sictr-2.bam   --format BAMPE  --gsize hs  --keep-dup all     \
                 --outdir $outPath   --name  $prefix    --qvalue 0.05   --broad   >  $outPath/$prefix.runLog.txt 2>&1    



prefix=HCT116-7SK-CHIRP-even.sipus7-1
macs3  callpeak  --treatment  $ChIPedPath/$prefix.bam   --control  $inputPath/HCT116-7SK-CHIRP-input.sipus7-1.bam   --format BAMPE  --gsize hs  --keep-dup all     \
                 --outdir $outPath   --name  $prefix    --qvalue 0.05   --broad   >  $outPath/$prefix.runLog.txt 2>&1    

prefix=HCT116-7SK-CHIRP-even.sipus7-2
macs3  callpeak  --treatment  $ChIPedPath/$prefix.bam   --control  $inputPath/HCT116-7SK-CHIRP-input.sipus7-2.bam   --format BAMPE  --gsize hs  --keep-dup all     \
                 --outdir $outPath   --name  $prefix    --qvalue 0.05   --broad   >  $outPath/$prefix.runLog.txt 2>&1    








prefix=HCT116-7SK-CHIRP-odd.sictr-1
macs3  callpeak  --treatment  $ChIPedPath/$prefix.bam   --control  $inputPath/HCT116-7SK-CHIRP-input.sictr-1.bam   --format BAMPE  --gsize hs  --keep-dup all     \
                 --outdir $outPath   --name  $prefix    --qvalue 0.05   --broad   >  $outPath/$prefix.runLog.txt 2>&1 

prefix=HCT116-7SK-CHIRP-odd.sictr-2
macs3  callpeak  --treatment  $ChIPedPath/$prefix.bam   --control  $inputPath/HCT116-7SK-CHIRP-input.sictr-2.bam   --format BAMPE  --gsize hs  --keep-dup all     \
                 --outdir $outPath   --name  $prefix    --qvalue 0.05   --broad   >  $outPath/$prefix.runLog.txt 2>&1    



prefix=HCT116-7SK-CHIRP-odd.sipus7-1
macs3  callpeak  --treatment  $ChIPedPath/$prefix.bam   --control  $inputPath/HCT116-7SK-CHIRP-input.sipus7-1.bam   --format BAMPE  --gsize hs  --keep-dup all     \
                 --outdir $outPath   --name  $prefix    --qvalue 0.05   --broad   >  $outPath/$prefix.runLog.txt 2>&1    

prefix=HCT116-7SK-CHIRP-odd.sipus7-2
macs3  callpeak  --treatment  $ChIPedPath/$prefix.bam   --control  $inputPath/HCT116-7SK-CHIRP-input.sipus7-2.bam   --format BAMPE  --gsize hs  --keep-dup all     \
                 --outdir $outPath   --name  $prefix    --qvalue 0.05   --broad   >  $outPath/$prefix.runLog.txt 2>&1    








