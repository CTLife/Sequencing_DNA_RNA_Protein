#!/usr/bin/env  perl
use  strict;
use  warnings;
use  v5.12;
## Perl5 version >= 5.12
###################################################################################################################################################################################################





###################################################################################################################################################################################################
my $input_g  = '';  ## such as "6_finalBAM/3_STAR"
my $output_g = '';  ## such as "8_rawCounts/3_STAR"

{
## Help Infromation
my $HELP = '
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------------------------------------------ 
        Usage:
               perl  RNA_mRNA-Seq_8.pl    [-version]    [-help]    [-in inputDir]    [-out outDir]
        For instance:
               nohup time  perl  RNA_mRNA-Seq_8.pl    -in 6_finalBAM/3_STAR   -out 8_rawCounts/3_STAR    > RNA_mRNA-Seq_8.runLog  2>&1   &

        ----------------------------------------------------------------------------------------------------------
        Optional arguments:
        -version        Show version number of this program and exit.
        -help           Show this help message and exit.

        Required arguments:
        -in inputDir        "inputDir" is the name of input path that contains your BAM files.  (no default)
        -out outDir         "outDir" is the name of output path that contains your running results of this step.  (no default)
        -----------------------------------------------------------------------------------------------------------

        For more details about this pipeline and other NGS data analysis piplines, please visit https://github.com/CTLife/Sequencing_DNA_RNA_Protein
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------------------------------------------
';

## Version Infromation
my $version = "   The 8th Step, version 1.1,  2023-03-05";

## Keys and Values
if ($#ARGV   == -1)   { say  "\n$HELP\n";  exit 0;  }       ## when there are no any command argumants.
if ($#ARGV%2 ==  0)   { @ARGV = (@ARGV, "-help") ;  }       ## when the number of command argumants is odd.
my %args = @ARGV;

## Initialize  Variables
$input_g  = '6_finalBAM/3_STAR';         ## This is only an initialization value or suggesting value, not default value.
$output_g = '8_rawCounts/3_STAR';        ## This is only an initialization value or suggesting value, not default value.

## Available Arguments
my $available = "   -version    -help    -in   -out  ";
my $boole = 0;
while( my ($key, $value) = each %args ) {
    if ( ($key =~ m/^\-/) and ($available !~ m/\s$key\s/) ) {say    "\n\tCann't recognize $key";  $boole = 1; }
}
if($boole == 1) {
    say  "\tThe Command Line Arguments are wrong!";
    say  "\tPlease see help message by using 'perl  RNA_mRNA-Seq_8.pl  -help' \n";
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
 
my $output2_g = "$output_g/QC_Results";
&myMakeDir($output_g);
&myMakeDir($output2_g);

opendir(my $DH_input_g, $input_g)  ||  die;
my @inputFiles_g = readdir($DH_input_g);
my $numCores_g   = 16;
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


&printVersion("featureCounts   -v");
&printVersion("htseq-count     --version");
###################################################################################################################################################################################################





###################################################################################################################################################################################################
my $GTF_file_g = "/home/yongpeng/MyProgramFiles_02302023/14_Genomes/Gencode/Human_GRCh38.p13/gencode.v43.primary_assembly.annotation.gtf";
## my $GTF_file_g = "/home/yongpeng/MyProgramFiles_02302023/14_Genomes/Gencode/Mouse_GRCm39/gencode.vM32.primary_assembly.annotation.gtf";

&myMakeDir("$output_g/featureCounts");
&myMakeDir("$output_g/featureCounts_formatted");
&myMakeDir("$output_g/htseq-count");  
###################################################################################################################################################################################################





###################################################################################################################################################################################################
say   "\n\n\n\n\n\n##################################################################################################";
say   "Detecting bam files in input folder ......";
my @bamfiles_g = ();
open(seqFiles_FH, ">", "$output2_g/bam-Files.txt")  or  die; 
for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {     
    next unless $inputFiles_g[$i] =~ m/\.bam$/;
    next unless $inputFiles_g[$i] !~ m/^[.]/;
    next unless $inputFiles_g[$i] !~ m/[~]$/;
    next unless $inputFiles_g[$i] !~ m/^unpaired/;
    next unless $inputFiles_g[$i] !~ m/^removed_/;
    say    "\t......$inputFiles_g[$i]"; 
    $inputFiles_g[$i] =~ m/\.bam$/  or  die;  
    $bamfiles_g[$#bamfiles_g+1] =  $inputFiles_g[$i];
    say        "\t\t\t\tbam file:  $inputFiles_g[$i]\n";
    say   seqFiles_FH  "bam file:  $inputFiles_g[$i]\n";
}

say   seqFiles_FH  "\n\n\n\n\n";  
say   seqFiles_FH  "All bam files:@bamfiles_g\n\n\n";
say        "\t\t\t\tAll bam files:@bamfiles_g\n\n";
my $num1 = $#bamfiles_g + 1;
say seqFiles_FH   "\nThere are $num1 bam files.\n";
say         "\t\t\t\tThere are $num1 bam files.\n";

###################################################################################################################################################################################################





###################################################################################################################################################################################################
{
say   "\n\n\n\n\n\n##################################################################################################";
say   "Calculating raw counts of each gene/transcript by featureCounts ......";
for (my $i=0; $i<=$#bamfiles_g; $i++) {
    my $temp = $bamfiles_g[$i]; 
    $temp =~ s/\.bam$//  ||  die; 
    say   "\t......$bamfiles_g[$i]";

    system("featureCounts   -p  --countReadPairs   -O  -M    -s 2     -T $numCores_g   -a $GTF_file_g    -o $output_g/featureCounts/$temp.featureCounts  $input_g/$bamfiles_g[$i]    > $output_g/$temp.featureCounts.runLog.txt  2>&1 ");
    sleep(3);
    my $myCommand_1 = " sed  1,2d   $output_g/featureCounts/$temp.featureCounts   |   awk '{print \$1,\$7}'  >    $output_g/featureCounts_formatted/$temp.featureCounts  " ;  
    system( $myCommand_1 );
    sleep(3);
    system( " tr   ' '   '\t'   <  $output_g/featureCounts_formatted/$temp.featureCounts   >   $output_g/featureCounts_formatted/final.$temp.featureCounts " );
}
}
###################################################################################################################################################################################################
#  -s <int or string>  Perform strand-specific read counting. A single integer
#                      value (applied to all input files) or a string of comma-
#                      separated values (applied to each corresponding input
#                      file) should be provided. Possible values include:
#                      0 (unstranded), 1 (stranded) and 2 (reversely stranded).
#                      Default value is 0 (ie. unstranded read counting carried
#                      out for all input files).


 



###################################################################################################################################################################################################
{
say   "\n\n\n\n\n\n##################################################################################################";
say   "Calculating raw counts of each gene/transcript by htseq-count ......";
for (my $i=0; $i<=$#bamfiles_g; $i++) {
    my $temp = $bamfiles_g[$i]; 
    $temp =~ s/\.bam$//  ||  die; 
    say   "\t......$bamfiles_g[$i]";
    system("htseq-count  --format bam  --order pos  --stranded reverse    -n $numCores_g  $input_g/$bamfiles_g[$i]    $GTF_file_g     > $output_g/htseq-count/$temp.htseq-count");
}
}
###################################################################################################################################################################################################





###################################################################################################################################################################################################
say   "\n\n\n\n\n\n##################################################################################################";
say   "\tJob Done! Cheers! \n\n\n\n\n";


 

  
## END



