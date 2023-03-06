#    venn                Venn diagram of intersection of genomic regions or list sets (upto 6-way).
#    upset               UpSet diagram of intersection of genomic regions or list sets.
#    pairwise            Pairwise intersection and heatmap of N genomic region sets in <BED/GTF/GFF> format.


A0=HCT116-si7SK-PolII-rp1_peaks.broadPeak
A1=HCT116-si7SK-PolII-rp2_peaks.broadPeak
A2=HCT116-sictr-PolII-rp1_peaks.broadPeak
A3=HCT116-sictr-PolII-rp2_peaks.broadPeak
A4=HCT116-sipus7-PolII-rp1_peaks.broadPeak
A5=HCT116-sipus7-PolII-rp2_peaks.broadPeak

outdir="Overlap"
mkdir  $outdir 


## venn
##############################################################################
outpath1=$outdir/venn
mkdir  $outpath1
intervene  venn  --input  \
$A0  \
$A1  \
$A2  \
$A3  \
$A4  \
$A5  \
--type genomic    --save-overlaps   --output $outpath1  \
--dpi 1200  --figtype pdf   --figsize 12 12  --fontsize 10
##############################################################################


## upset
##############################################################################
outpath2=$outdir/upset
mkdir  $outpath2
intervene  upset  --input  \
$A0  \
$A1  \
$A2  \
$A3  \
$A4  \
$A5  \
--type   genomic   --save-overlaps   --output $outpath2  --ninter 100       \
--dpi 1200  --figtype pdf   --figsize 12 6   
##############################################################################


## pairwise
##############################################################################
outpath1="$outdir/pairwise.fraction"
mkdir -p $outpath1

intervene  pairwise  \
--input  \
$A0  \
$A1  \
$A2  \
$A3  \
$A4  \
$A5  \
--type genomic    --compute  frac  --htype color   --output $outpath1  \
--dpi 1200  --figtype svg   --figsize 10 10  --fontsize 10



outpath2="$outdir/pairwise.count"
mkdir -p $outpath2

intervene  pairwise  \
--input  \
$A0  \
$A1  \
$A2  \
$A3  \
$A4  \
$A5  \
--type genomic    --compute  count  --htype color  --output $outpath2  \
--dpi 1200  --figtype svg   --figsize 10 10   --fontsize 10
##############################################################################




















 






