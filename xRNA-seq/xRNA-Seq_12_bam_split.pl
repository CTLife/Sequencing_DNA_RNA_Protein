#!/usr/bin/env  perl
use  strict;
use  warnings;
use  v5.12;
## Perl5 version >= 5.12
###################################################################################################################################################################################################





###################################################################################################################################################################################################
my $SE_or_PE = '';  ## Single-end or Paired-end BAM: single or paired
my $input_g  = '';  ## such as "7_finalBAM/PE/3_STAR"   
my $output_g = '';  ## such as "12_splitBAM/PE/3_STAR"
{
## Help Infromation
my $HELP = '
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        Splitting reads in a BAM file by strands.
       
        Usage:
               perl xRNA-Seq_12_bam_split.pl    [-version]    [-help]  [-end Type]   [-in inputDir]    [-out outDir]
        For instance:
               nohup  time   perl xRNA-Seq_12_bam_split.pl   -end paired  -in 7_finalBAM/PE/3_STAR   -out 12_splitBAM/PE/3_STAR    > xRNA-Seq_12_bam_split.runLog.txt  2>&1     &      

        ----------------------------------------------------------------------------------------------------------
        Optional arguments:
        -version        Show version number of this program and exit.

        -help           Show this help message and exit.

        Required arguments:
        -end Type           single or paired.  (no default)
        
        -in inputDir        "inputDir" is the name of input path that contains your BAM files.  (no default)

        -out outDir         "outDir" is the name of output path that contains your running results (BAM files) of this step.  (no default)
        -----------------------------------------------------------------------------------------------------------

        For more details about this pipeline and other NGS data analysis piplines, please visit https://github.com/CTLife/Sequencing_DNA_RNA_Protein
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------------------------------------------
';

## Version Infromation
my $version = "    Separate Strand Specific RNA-Seq Alignments by Strand.   The 12th Step, version 1.2,  2023-07-25. ";

## Keys and Values
if ($#ARGV   == -1)   { say  "\n$HELP\n";  exit 0;  }       ## when there are no any command argumants.
if ($#ARGV%2 ==  0)   { @ARGV = (@ARGV, "-help") ;  }       ## when the number of command argumants is odd.
my %args = @ARGV;

## Initialize  Variables
$SE_or_PE = 'paired';                  ## This is only an initialization value or suggesting value, not default value.
$input_g  = '7_finalBAM/PE/3_STAR';    ## This is only an initialization value or suggesting value, not default value.
$output_g = '12_splitBAM/PE/3_STAR';   ## This is only an initialization value or suggesting value, not default value.

## Available Arguments 
my $available = "   -version    -help  -end   -in   -out  ";
my $boole = 0;
while( my ($key, $value) = each %args ) {
    if ( ($key =~ m/^\-/) and ($available !~ m/\s$key\s/) ) {say    "\n\tCann't recognize $key";  $boole = 1; }
}
if($boole == 1) {
    say  "\tThe Command Line Arguments are wrong!";
    say  "\tPlease see help message by using 'perl xRNA-Seq_12_bam_split.pl  -help' \n";
    exit 0;
}

## Get Arguments 
if ( exists $args{'-version' }   )     { say  "\n$version\n";    exit 0; }
if ( exists $args{'-help'    }   )     { say  "\n$HELP\n";       exit 0; }
if ( exists $args{'-end'     }   )     { $SE_or_PE = $args{'-end'     }; }else{say   "\n -end  is required.\n";   say  "\n$HELP\n";    exit 0; }
if ( exists $args{'-in'      }   )     { $input_g  = $args{'-in'      }; }else{say   "\n -in   is required.\n";   say  "\n$HELP\n";    exit 0; }
if ( exists $args{'-out'     }   )     { $output_g = $args{'-out'     }; }else{say   "\n -out  is required.\n";   say  "\n$HELP\n";    exit 0; }

## Conditions
$SE_or_PE =~ m/^\S+$/    ||  die   "\n\n$HELP\n\n";
$input_g  =~ m/^\S+$/    ||  die   "\n\n$HELP\n\n";
$output_g =~ m/^\S+$/    ||  die   "\n\n$HELP\n\n";

## Print Command Arguments to Standard Output
say  "\n
        ################ Arguments ###############################
                SE or PE:      $SE_or_PE
                Input   Path:  $input_g
                Output  Path:  $output_g
        ###############################################################
\n";
}
###################################################################################################################################################################################################





###################################################################################################################################################################################################
say   "\n\n\n\n\n\n##################################################################################################";
say   "Running ......";
sub myMakeDir  {
    my $path = $_[0];
    if ( !( -e $path) )  { system("mkdir  -p  $path"); }
    if ( !( -e $path) )  { mkdir $path  ||  die;       }
}

&myMakeDir($output_g);
opendir(my $DH_input_g, $input_g)  ||  die;
my @inputFiles_g = readdir($DH_input_g);
###################################################################################################################################################################################################



 
        
###################################################################################################################################################################################################

for(my $i=0; $i<=$#inputFiles_g; $i=$i+1) {
        my $temp = $inputFiles_g[$i];
        next unless $temp =~ m/\.bam$/;
        print "$temp\n";
        if($SE_or_PE  eq  "single"){ system("sh   xRNA-Seq_12_bam_split_single_end.sh     $input_g/$temp    $output_g");  }       
        if($SE_or_PE  eq  "paired"){ system("sh   xRNA-Seq_12_bam_split_paired_end.sh     $input_g/$temp    $output_g");  } 
}

###################################################################################################################################################################################################






say   "Done ......";






#####
