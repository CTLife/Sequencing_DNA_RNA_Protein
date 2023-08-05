#!/usr/bin/env  perl
use  strict;
use  warnings;
use  v5.22;
###################################################################################################################################################################################################





###################################################################################################################################################################################################
my $input_g  = '';  ## such as "8_BW/PE/3_STAR"
my $output_g = '';  ## such as "9_clstering/PE/3_STAR"

{
## Help Infromation
my $HELP = '
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        Usage:
               perl  xRNA-Seq_9.pl    [-version]    [-help]      [-in inputDir]    [-out outDir]
        For instance:
               nohup  time  perl  xRNA-Seq_9.pl    -in 8_BW/PE/3_STAR  -out 9_clstering/PE/3_STAR    > xRNA-Seq_9.1.runLog.txt  2>&1  &

        ----------------------------------------------------------------------------------------------------------
        Optional arguments:
        -version        Show version number of this program and exit.

        -help           Show this help message and exit.

        Required arguments:
        -in inputDir        "inputDir" is the name of input path that contains your BigWig files.  (no default)

        -out outDir         "outDir" is the name of output path that contains your running results of this step.  (no default)
        -----------------------------------------------------------------------------------------------------------

        For more details about this pipeline and other NGS data analysis piplines, please visit https://github.com/CTLife/Sequencing_DNA_RNA_Protein
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------------------------------------------
';

## Version Infromation
my $version = "    The 9th Step, version 1.2,  2023-07-25. ";

## Keys and Values
if ($#ARGV   == -1)   { say  "\n$HELP\n";  exit 0;  }       ## when there are no any command argumants.
if ($#ARGV%2 ==  0)   { @ARGV = (@ARGV, "-help") ;  }       ## when the number of command argumants is odd.
my %args = @ARGV;

## Initialize  Variables
$input_g  = '8_BW/PE/3_STAR';          ## This is only an initialization value or suggesting value, not default value.
$output_g = '9_clstering/PE/3_STAR ';  ## This is only an initialization value or suggesting value, not default value.

## Available Arguments
my $available = "   -version    -help   -genome   -in   -out  ";
my $boole = 0;
while( my ($key, $value) = each %args ) {
    if ( ($key =~ m/^\-/) and ($available !~ m/\s$key\s/) ) {say    "\n\tCann't recognize $key";  $boole = 1; }
}
if($boole == 1) {
    say  "\tThe Command Line Arguments are wrong!";
    say  "\tPlease see help message by using 'perl  xRNA-Seq_9.pl  -help' \n";
    exit 0;
}

## Get Arguments
if ( exists $args{'-version' }   )     { say  "\n$version\n";    exit 0; }
if ( exists $args{'-help'    }   )     { say  "\n$HELP\n";       exit 0; }
if ( exists $args{'-in'      }   )     { $input_g  = $args{'-in'      }; }else{say   "\n -in     is required.\n";   say  "\n$HELP\n";    exit 0; }
if ( exists $args{'-out'     }   )     { $output_g = $args{'-out'     }; }else{say   "\n -out    is required.\n";   say  "\n$HELP\n";    exit 0; }

## Conditions
$input_g  =~ m/^\S+$/    ||  die   "\n\n$HELP\n\n";
$output_g =~ m/^\S+$/    ||  die   "\n\n$HELP\n\n";

## Print Command Arguments to Standard Output
say  "\n
        ################ Arguments ###############################
                Input       Path:  $input_g
                Output      Path:  $output_g
        ###############################################################
\n";
}
###################################################################################################################################################################################################





###################################################################################################################################################################################################
say    "\n\n\n\n\n\n##################################################################################################";
say    "Running......";

sub myMakeDir  {
    my $path = $_[0];
    if ( !( -e $path) )  { system("mkdir  -p  $path"); }
    if ( !( -e $path) )  { mkdir $path  ||  die; }
}

&myMakeDir($output_g);

opendir(my $DH_input_g, $input_g)  ||  die;
my @inputFiles_g = readdir($DH_input_g);
###################################################################################################################################################################################################





###################################################################################################################################################################################################
say   "\n\n\n\n\n\n##################################################################################################";
say   "Checking all the necessary softwares in this step......" ;
sub printVersion  {
    my $software = $_[0];
    system("echo    '##############################################################################'  >> $output_g/VersionsOfSoftwares.txt   2>&1");
    system("echo    '#########$software'                                                              >> $output_g/VersionsOfSoftwares.txt   2>&1");
    system("$software                                                                                 >> $output_g/VersionsOfSoftwares.txt   2>&1");
    system("echo    '\n\n\n\n\n\n'                                                                    >> $output_g/VersionsOfSoftwares.txt   2>&1");
}
&printVersion("deeptools   --version");
###################################################################################################################################################################################################





###################################################################################################################################################################################################
say   "\n\n\n\n\n\n##################################################################################################";
say   "Detecting BigWig files in input folder ......";
my @BigWigfiles_g = ();
{
open(seqFiles_FH, ">", "$output_g/BigWig-Files.txt")  or  die; 
for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {     
    next unless $inputFiles_g[$i] =~ m/\.bw$/;
    next unless $inputFiles_g[$i] !~ m/^[.]/;
    next unless $inputFiles_g[$i] !~ m/[~]$/;
    next unless $inputFiles_g[$i] !~ m/^unpaired/;
    say    "\t......$inputFiles_g[$i]"; 
    $BigWigfiles_g[$#BigWigfiles_g+1] =  $inputFiles_g[$i];
    say        "\t\t\t\tBigWig file:  $inputFiles_g[$i]\n";
    say   seqFiles_FH  "BigWig file:  $inputFiles_g[$i]\n";
}

say   seqFiles_FH  "\n\n\n\n\n";  
say   seqFiles_FH  "All BigWig files:@BigWigfiles_g\n\n\n";
say        "\t\t\t\tAll BigWig files:@BigWigfiles_g\n\n";
my $num1 = $#BigWigfiles_g + 1;
say seqFiles_FH   "\nThere are $num1 BigWig files.\n";
say         "\t\t\t\tThere are $num1 BigWig files.\n";
}

my @BigWigfiles_g2 =  @BigWigfiles_g;    
for ( my $i=0; $i<=$#BigWigfiles_g2; $i++ ) { 
   $BigWigfiles_g2[$i] = "$input_g/$BigWigfiles_g2[$i]";   ## add path  
   print("##$BigWigfiles_g2[$i]##\n");
}
###################################################################################################################################################################################################





###################################################################################################################################################################################################
say   "\n\n\n\n\n\n##################################################################################################";
say   "Using multiBigwigSummary bin, plotCorrelation and plotPCA ......";

{
    my $output_sub1 = "$output_g/1000bp";   
    &myMakeDir($output_sub1);
    system("multiBigwigSummary bins   --bwfiles @BigWigfiles_g2    --smartLabels    --binSize 1000   --numberOfProcessors max/2    --verbose    --outRawCounts $output_sub1/B.1-RawCounts.1000bp-Bin.txt   --outFileName $output_sub1/B.1-results.1000bp.npz  --chromosomesToSkip chrX chrY chrM   >> $output_sub1/B.1-runLog.txt   2>&1");                               
    system("plotCorrelation -in $output_sub1/B.1-results.1000bp.npz    --whatToPlot heatmap        --corMethod pearson     -o $output_sub1/B.2-Correlation.heatmap.pearson.1000bp.pdf       --outFileCorMatrix $output_sub1/B.2-Correlation.heatmap.pearson.1000bp.txt         --plotHeight 20   --plotWidth 20      --skipZeros  --removeOutliers     >> $output_sub1/B.2-runLog.txt   2>&1");                               
    system("plotCorrelation -in $output_sub1/B.1-results.1000bp.npz    --whatToPlot heatmap        --corMethod spearman    -o $output_sub1/B.3-Correlation.heatmap.spearman.1000bp.pdf      --outFileCorMatrix $output_sub1/B.3-Correlation.heatmap.spearman.1000bp.txt        --plotHeight 20   --plotWidth 20      --skipZeros  --removeOutliers     >> $output_sub1/B.3-runLog.txt   2>&1");                               
    #system("plotCorrelation -in $output_sub1/B.1-results.1000bp.npz    --whatToPlot scatterplot    --corMethod pearson     -o $output_sub1/B.4-Correlation.scatterplot.pearson.1000bp.pdf   --outFileCorMatrix $output_sub1/B.4-Correlation.scatterplot.pearson.1000bp.txt     --plotHeight 20   --plotWidth 20      --skipZeros  --removeOutliers     >> $output_sub1/B.4-runLog.txt   2>&1");                               
    #system("plotCorrelation -in $output_sub1/B.1-results.1000bp.npz    --whatToPlot scatterplot    --corMethod spearman    -o $output_sub1/B.5-Correlation.scatterplot.spearman.1000bp.pdf  --outFileCorMatrix $output_sub1/B.5-Correlation.scatterplot.spearman.1000bp.txt    --plotHeight 20   --plotWidth 20      --skipZeros  --removeOutliers     >> $output_sub1/B.5-runLog.txt   2>&1");                               

    $output_sub1 = "$output_g/500bp";   
    &myMakeDir($output_sub1);
    system("multiBigwigSummary bins   --bwfiles @BigWigfiles_g2    --smartLabels    --binSize 500   --numberOfProcessors max/2    --verbose    --outRawCounts $output_sub1/C.1-RawCounts.500bp-Bin.txt   --outFileName $output_sub1/C.1-results.500bp.npz    --chromosomesToSkip chrX chrY chrM   >> $output_sub1/C.1-runLog.txt   2>&1");                               
    system("plotCorrelation -in $output_sub1/C.1-results.500bp.npz    --whatToPlot heatmap        --corMethod pearson     -o $output_sub1/C.2-Correlation.heatmap.pearson.500bp.pdf       --outFileCorMatrix $output_sub1/C.2-Correlation.heatmap.pearson.500bp.txt         --plotHeight 20   --plotWidth 20      --skipZeros  --removeOutliers     >> $output_sub1/C.2-runLog.txt   2>&1");                               
    system("plotCorrelation -in $output_sub1/C.1-results.500bp.npz    --whatToPlot heatmap        --corMethod spearman    -o $output_sub1/C.3-Correlation.heatmap.spearman.500bp.pdf      --outFileCorMatrix $output_sub1/C.3-Correlation.heatmap.spearman.500bp.txt        --plotHeight 20   --plotWidth 20      --skipZeros  --removeOutliers     >> $output_sub1/C.3-runLog.txt   2>&1");                               
    #system("plotCorrelation -in $output_sub1/C.1-results.500bp.npz    --whatToPlot scatterplot    --corMethod pearson     -o $output_sub1/C.4-Correlation.scatterplot.pearson.500bp.pdf   --outFileCorMatrix $output_sub1/C.4-Correlation.scatterplot.pearson.500bp.txt     --plotHeight 20   --plotWidth 20      --skipZeros  --removeOutliers     >> $output_sub1/C.4-runLog.txt   2>&1");                               
    #system("plotCorrelation -in $output_sub1/C.1-results.500bp.npz    --whatToPlot scatterplot    --corMethod spearman    -o $output_sub1/C.5-Correlation.scatterplot.spearman.500bp.pdf  --outFileCorMatrix $output_sub1/C.5-Correlation.scatterplot.spearman.500bp.txt    --plotHeight 20   --plotWidth 20      --skipZeros  --removeOutliers     >> $output_sub1/C.5-runLog.txt   2>&1");                               


    $output_sub1 = "$output_g/200bp";   
    &myMakeDir($output_sub1);
    system("multiBigwigSummary bins   --bwfiles @BigWigfiles_g2    --smartLabels    --binSize 200   --numberOfProcessors max/2    --verbose    --outRawCounts $output_sub1/D.1-RawCounts.200bp-Bin.txt   --outFileName $output_sub1/D.1-results.200bp.npz    --chromosomesToSkip chrX chrY chrM   >> $output_sub1/D.1-runLog.txt   2>&1");                               
    system("plotCorrelation -in $output_sub1/D.1-results.200bp.npz    --whatToPlot heatmap        --corMethod pearson     -o $output_sub1/D.2-Correlation.heatmap.pearson.200bp.pdf       --outFileCorMatrix $output_sub1/D.2-Correlation.heatmap.pearson.200bp.txt         --plotHeight 20   --plotWidth 20      --skipZeros  --removeOutliers     >> $output_sub1/D.2-runLog.txt   2>&1");                               
    system("plotCorrelation -in $output_sub1/D.1-results.200bp.npz    --whatToPlot heatmap        --corMethod spearman    -o $output_sub1/D.3-Correlation.heatmap.spearman.200bp.pdf      --outFileCorMatrix $output_sub1/D.3-Correlation.heatmap.spearman.200bp.txt        --plotHeight 20   --plotWidth 20      --skipZeros  --removeOutliers     >> $output_sub1/D.3-runLog.txt   2>&1");                               
    #system("plotCorrelation -in $output_sub1/D.1-results.200bp.npz    --whatToPlot scatterplot    --corMethod pearson     -o $output_sub1/D.4-Correlation.scatterplot.pearson.200bp.pdf   --outFileCorMatrix $output_sub1/D.4-Correlation.scatterplot.pearson.200bp.txt     --plotHeight 20   --plotWidth 20      --skipZeros  --removeOutliers     >> $output_sub1/D.4-runLog.txt   2>&1");                               
    #system("plotCorrelation -in $output_sub1/D.1-results.200bp.npz    --whatToPlot scatterplot    --corMethod spearman    -o $output_sub1/D.5-Correlation.scatterplot.spearman.200bp.pdf  --outFileCorMatrix $output_sub1/D.5-Correlation.scatterplot.spearman.200bp.txt    --plotHeight 20   --plotWidth 20      --skipZeros  --removeOutliers     >> $output_sub1/D.5-runLog.txt   2>&1");                               

}
###################################################################################################################################################################################################    





###################################################################################################################################################################################################
say   "\n\n\n\n\n\n##################################################################################################";
say   "\tJob Done! Cheers! \n\n\n\n\n";


 

  
## END







