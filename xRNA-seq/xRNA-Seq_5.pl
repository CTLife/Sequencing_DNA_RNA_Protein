#!/usr/bin/env  perl
use  strict;
use  warnings;
use  v5.12;
## Perl5 version >= 5.12
###################################################################################################################################################################################################





###################################################################################################################################################################################################
my $genome_g   = '';  ## such as "mm39", "ce11", "hg38".
my $input_g    = '';  ## such as "3_removedDups"
my $output_g   = '';  ## such as "4_Strandedness"

{
## Help Infromation
my $HELP = '
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        Step 4: Quick determination of RNA-Seq strandedness by using  Salmon and how_are_we_stranded_here.

                If this script works well, you do not need to check the the versions of the softwares or packages whcih are used in this script. 
                And you do not need to exactly match the versions of the softwares or packages.
                If some errors or warnings are reported, please check the versions of softwares or packages.

                The versions of softwares or packages are used in this script:  
                        Perl,     5.26.1
                        Kallisto, 0.46.1 
                        Salmon,   v1.1.0
                        RSeQC,    5.0.1 ##such as  tin.py, geneBody_coverage.py
                        check_strandedness, 1.0.1
     
        Usage:
               perl  xRNA-Seq_5.pl    [-version]    [-help]   [-genome RefGenome]    [-in inputDir]    [-out outDir]   
        For instance:
               nohup time  perl  xRNA-Seq_5.pl   -genome hg38   -in 3_removedDups   -out 5_Strandedness/PE     > xRNA-Seq_5.PE.runLog  2>&1  &
               nohup time  perl  xRNA-Seq_5.pl   -genome hg38   -in 4_SE-RC         -out 5_Strandedness/SE     > xRNA-Seq_5.SE.runLog  2>&1  &
               
        ----------------------------------------------------------------------------------------------------------
        Optional arguments:
        -version        Show version number of this program and exit.

        -help           Show this help message and exit.

        Required arguments:
        -genome RefGenome   "RefGenome" is the short name of your reference genome, such as "mm10", "ce11", "hg38".    (no default)

        -in inputDir        "inputDir" is the name of input path that contains your FASTQ files.  (no default)

        -out outDir         "outDir" is the name of output path that contains your running results (BAM files) of this step.  (no default)
        -----------------------------------------------------------------------------------------------------------

        For more details about this pipeline and other NGS data analysis piplines, please visit https://github.com/CTLife/Sequencing_DNA_RNA_Protein
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------------------------------------------
';

## Version Infromation
my $version = "   The 5th Step, version 1.2,  2023-07-25.";

## Keys and Values
if ($#ARGV   == -1)   { say  "\n$HELP\n";  exit 0;  }       ## when there are no any command argumants.
if ($#ARGV%2 ==  0)   { @ARGV = (@ARGV, "-help") ;  }       ## when the number of command argumants is odd.
my %args = @ARGV;

## Initialize  Variables
$genome_g = 'hg38';                 ## This is only an initialization value or suggesting value, not default value.
$input_g  = '3_removedDups';        ## This is only an initialization value or suggesting value, not default value.
$output_g = '4_Strandedness';       ## This is only an initialization value or suggesting value, not default value.

## Available Arguments
my $available = "   -version    -help   -genome   -in   -out    ";
my $boole = 0;
while( my ($key, $value) = each %args ) {
    if ( ($key =~ m/^\-/) and ($available !~ m/\s$key\s/) ) {say    "\n\tCann't recognize $key";  $boole = 1; }
}
if($boole == 1) {
    say  "\tThe Command Line Arguments are wrong!";
    say  "\tPlease see help message by using 'perl  xRNA-Seq_5.pl  -help' \n";
    exit 0;
}

## Get Arguments
if ( exists $args{'-version' }   )     { say  "\n$version\n";    exit 0; }
if ( exists $args{'-help'    }   )     { say  "\n$HELP\n";       exit 0; }
if ( exists $args{'-genome'  }   )     { $genome_g = $args{'-genome'  }; }else{say   "\n -genome is required.\n";   say  "\n$HELP\n";    exit 0; }
if ( exists $args{'-in'      }   )     { $input_g  = $args{'-in'      }; }else{say   "\n -in     is required.\n";   say  "\n$HELP\n";    exit 0; }
if ( exists $args{'-out'     }   )     { $output_g = $args{'-out'     }; }else{say   "\n -out    is required.\n";   say  "\n$HELP\n";    exit 0; }

## Conditions
$genome_g =~ m/^\S+$/       ||  die   "\n\n$HELP\n\n";
$input_g  =~ m/^\S+$/       ||  die   "\n\n$HELP\n\n";
$output_g =~ m/^\S+$/       ||  die   "\n\n$HELP\n\n";

## Print Command Arguments to Standard Output
say  "\n
        ################ Arguments ###############################
                Reference Genome:  $genome_g
                Input       Path:  $input_g
                Output      Path:  $output_g
        ##########################################################
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
my $numCores_g   = 8;
###################################################################################################################################################################################################













## context specific
###################################################################################################################################################################################################
## Context specific:
my  $commonPath_g      = "/media/yp/1one/MyProgramFiles_02302023";

my  $Kallisto_index_g  = "$commonPath_g/2_Aligners/kallisto/RefGenomes/$genome_g/$genome_g";
my  $Salmon_index_g    = "$commonPath_g/2_Aligners/salmon/RefGenomes/$genome_g/salmon_index";

my  $fasta_g = "$commonPath_g/14_Genomes/Gencode/Human_GRCh38.p13/gencode.v43.transcripts.fa";
my  $GTF_g   = "$commonPath_g/14_Genomes/Gencode/Human_GRCh38.p13/gencode.v43.primary_assembly.annotation.gtf";

if($genome_g eq "mm39"){
   $fasta_g = "$commonPath_g/14_Genomes/Gencode/Mouse_GRCm39/gencode.vM32.transcripts.fa";
   $GTF_g   = "$commonPath_g/14_Genomes/Gencode/Mouse_GRCm39/gencode.vM32.primary_assembly.annotation.gtf";
}

say   "\n\n\n\n\n\n################################################################################################## Index Path:";
say   "Kallisto:  $Kallisto_index_g";
say   "Salmon:    $Salmon_index_g";
say   "FASTA:     $fasta_g";
say   "GTF:       $GTF_g";
###################################################################################################################################################################################################



















###################################################################################################################################################################################################
say   "\n\n\n\n\n\n##################################################################################################";
say   "Checking all the necessary softwares in this step......" ;

sub printVersion  {
    my $software = $_[0];
    system("echo    '##############################################################################'  >> $output2_g/VersionsOfSoftwares.txt   2>&1");
    system("echo    '#########$software'                                                              >> $output2_g/VersionsOfSoftwares.txt   2>&1");
    system("$software                                                                                 >> $output2_g/VersionsOfSoftwares.txt   2>&1");
    system("echo    '\n\n\n\n\n\n'                                                                    >> $output2_g/VersionsOfSoftwares.txt   2>&1");
}

sub fullPathApp  {
    my $software = $_[0];
    say($software);
    system("which   $software  > yp_my_temp_1.$software.txt");
    open(tempFH, "<", "yp_my_temp_1.$software.txt")  or  die;
    my @fullPath1 = <tempFH>;
    ($#fullPath1 == 0)  or  die;
    system("rm  yp_my_temp_1.$software.txt");
    $fullPath1[0] =~ s/\n$//  or  die;
    return($fullPath1[0]);
}

my  $Picard_g   = &fullPathApp("picard.jar");
my  $QoRTs_g    = &fullPathApp("QoRTs.jar");

&printVersion("kallisto");
&printVersion("salmon");
&printVersion("check_strandedness  -h"); 

&printVersion("bam_stat.py             --version");  ## in RSeQC
&printVersion("geneBody_coverage.py    --version");  ## in RSeQC
&printVersion("inner_distance.py       --version");  ## in RSeQC
&printVersion("junction_annotation.py  --version");  ## in RSeQC
&printVersion("junction_saturation.py  --version");  ## in RSeQC
&printVersion("read_distribution.py    --version");  ## in RSeQC
&printVersion("read_duplication.py     --version");  ## in RSeQC
&printVersion("RPKM_saturation.py      --version");  ## in RSeQC
&printVersion("tin.py                  --version");  ## in RSeQC
###################################################################################################################################################################################################





###################################################################################################################################################################################################
say   "\n\n\n\n\n\n##################################################################################################";
say   "Detecting single-end and paired-end FASTQ files ......";
my @singleEnd_g   = ();
my @pairedEnd_g   = ();
open(seqFiles_FH_g, ">", "$output2_g/singleEnd-pairedEnd-Files.txt")  or  die;

for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {
    next unless $inputFiles_g[$i] !~ m/^[.]/;
    next unless $inputFiles_g[$i] !~ m/[~]$/;
    next unless $inputFiles_g[$i] !~ m/\.sh$/;
    next unless $inputFiles_g[$i] !~ m/^unpaired/;
    next unless $inputFiles_g[$i] !~ m/^QC_Results$/;
    next unless $inputFiles_g[$i] !~ m/runLog\.txt$/;
    next unless $inputFiles_g[$i] =~ m/\.fastq.gz$/ ;
    my $temp =  $inputFiles_g[$i]; 
    say    "\t......$temp";
    if ($temp !~ m/^(\S+)\.R[12]\.fastq/) {   ## sinlge end sequencing files.
        $temp =~ m/^(\S+)\.fastq/   or  die;
        $singleEnd_g[$#singleEnd_g+1] =  $temp;
        say         "\t\t\t\tSingle-end sequencing files: $temp\n";
        say  seqFiles_FH_g  "Single-end sequencing files: $temp\n";
    }else{     ## paired end sequencing files.
        $temp =~ m/^(\S+)\.R[12]\.fastq/  or  die;
        $pairedEnd_g[$#pairedEnd_g+1] =  $temp;
        say        "\t\t\t\tPaired-end sequencing files: $temp\n";
        say seqFiles_FH_g  "Paired-end sequencing files: $temp\n";
    }
}

@singleEnd_g  = sort(@singleEnd_g);
@pairedEnd_g  = sort(@pairedEnd_g);

( ($#pairedEnd_g+1)%2 == 0 )  or die;
say   seqFiles_FH_g  "\n\n\n\n\n";
say   seqFiles_FH_g  "All single-end sequencing files:@singleEnd_g\n\n\n";
say   seqFiles_FH_g  "All paired-end sequencing files:@pairedEnd_g\n\n\n";
say          "\t\t\t\tAll single-end sequencing files:@singleEnd_g\n\n";
say          "\t\t\t\tAll paired-end sequencing files:@pairedEnd_g\n\n";

my $numSingle_g = $#singleEnd_g + 1;
my $numPaired_g = $#pairedEnd_g + 1;

say seqFiles_FH_g   "\nThere are $numSingle_g single-end sequencing files.\n";
say seqFiles_FH_g   "\nThere are $numPaired_g paired-end sequencing files.\n";
say           "\t\t\t\tThere are $numSingle_g single-end sequencing files.\n";
say           "\t\t\t\tThere are $numPaired_g paired-end sequencing files.\n";


for ( my $i=0; $i<$#pairedEnd_g; $i=$i+2 ) {
    my $temp = $pairedEnd_g[$i]; 
    $temp =~ s/\.R1\.fastq/.R2.fastq/  or die "\n##Error-1: $temp ##\n\n";
    ($pairedEnd_g[$i+1] eq $temp) or die "\n##Error-2: $temp ## $pairedEnd_g[$i+1] ##\n\n";
}

print("\n\n\n\n\n#########################################\n");
###################################################################################################################################################################################################








###################################################################################################################################################################################################
my $Kallisto_1_g   = "$output_g/1_how_are_we_stranded_here";
&myMakeDir($Kallisto_1_g);
{ ########## Start check_strandedness
say   "\n\n\n\n\n\n##################################################################################################";
say   "Mapping reads to the reference transcriptome by using check_strandedness ......";
for (my $i=0; $i<=$#pairedEnd_g; $i=$i+2) {
        my $end1 = $pairedEnd_g[$i];
        my $end2 = $pairedEnd_g[$i+1];
        say    "\n\t......$end1";
        say    "  \t......$end2\n";
        my $temp = $end1; 
        $temp =~ s/\.R1\.fastq//  or die "\n##Error-a1: $temp ##\n\n";
        $temp =~ s/\.gz//;
        $temp =~ s/\.bz2//;
        open(tempFH,  ">>",  "$Kallisto_1_g/paired-end-files.txt")  or  die;
        say  tempFH  "$end1,   $end2\n";
        system("check_strandedness   --gtf $GTF_g  --transcripts $fasta_g   --nreads $numCores_g  --reads_1 $input_g/$end1   --reads_2 $input_g/$end2     >>  $Kallisto_1_g/$temp.runLog.txt  2>&1  ");
        my $folder = "stranded_test_"."$end1";
        $folder =~ s/.fastq.gz// ;
        system("mv  $folder  $Kallisto_1_g")
}

system("rm   kallisto_index")


}  ########## End check_strandedness
###################################################################################################################################################################################################


 

###################################################################################################################################################################################################
my $Salmon_2_g   = "$output_g/2_Salmon";
&myMakeDir($Salmon_2_g);
{ ########## Start Salmon
say   "\n\n\n\n\n\n##################################################################################################";
say   "Mapping reads to the reference transcriptome by using Salmon ......";
for (my $i=0; $i<=$#pairedEnd_g; $i=$i+2) {
        my $end1 = $pairedEnd_g[$i];
        my $end2 = $pairedEnd_g[$i+1];
        say    "\n\t......$end1";
        say    "  \t......$end2\n";
        my $temp = $end1; 
        $temp =~ s/\.R1\.fastq//  or die "\n##Error-a2: $temp ##\n\n";
        $temp =~ s/\.gz//;
        $temp =~ s/\.bz2//;
        open(tempFH, ">>", "$Salmon_2_g/paired-end-files.txt")  or  die;
        say  tempFH  "$end1,   $end2\n";
        system("salmon quant  --threads $numCores_g   --libType A     --softclip       --index $Salmon_index_g    --output $Salmon_2_g/$temp    --mates1 $input_g/$end1  --mates2 $input_g/$end2    >>  $Salmon_2_g/$temp.runLog.txt  2>&1 ");
}

for (my $i=0; $i<=$#singleEnd_g; $i++) {
        my $temp = $singleEnd_g[$i];
        say   "\n\t......$temp\n";
        $temp =~ s/\.fastq//  or die "\n##Error-b2: $temp ##\n\n";
        $temp =~ s/\.gz//;
        $temp =~ s/\.bz2//;
        system("salmon quant  --threads $numCores_g    --libType A   --softclip      --index $Salmon_index_g    --output $Salmon_2_g/$temp    --unmatedReads $input_g/$singleEnd_g[$i]      >>  $Salmon_2_g/$temp.runLog.txt  2>&1 ");      
}

&myMakeDir("$output2_g/2_MultiQC_Salmon");
system( "multiqc    --title Salmon        --verbose  --export   --outdir $output2_g/2_MultiQC_Salmon        $Salmon_2_g     >> $output2_g/2_MultiQC_Salmon/MultiQC.Salmon.runLog    2>&1" );

}  ########## End Salmon
###################################################################################################################################################################################################







###################################################################################################################################################################################################
say   "\n\n\n\n\n\n##################################################################################################";
say   "\tJob Done! Cheers! \n\n\n\n\n";





## END
