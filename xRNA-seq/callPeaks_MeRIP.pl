#!/usr/bin/env  perl5
use  strict;
use  warnings;
use  v5.22;
## Perl5 version >= 5.22
## You can create a symbolic link for perl5 by using "sudo  ln  /usr/bin/perl   /usr/bin/perl5" in Ubuntu.
## Suffixes of all self-defined global variables must be "_g".
###################################################################################################################################################################################################





###################################################################################################################################################################################################
my $genome_g = '';  ## such as "mm39", "ce11", "hg38".
my $input_g  = '';  ## such as "Input"
my $IP_g     = '';  ## such as "IP"
my $output_g = '';  ## such as "MACS2"

{
## Help Infromation
my $HELP = '
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        Call peaks for BAM or BAMPE by using MACS2 with input.  
        Usage:
               perl  callPeaks_MeRIP.pl    [-version]    [-help]   [-genome RefGenome]    [-in inputDir]   [-ip  IPdir]  [-out outDir]
        For instance:
               nohup time  perl  callPeaks_MeRIP.pl   -genome hg38   -in Input   -ip  IP -out MACS2    > callPeaks_MeRIP.runLog.txt   2>&1    &
        ----------------------------------------------------------------------------------------------------------
        Optional arguments:
        -version        Show version number of this program and exit.
        -help           Show this help message and exit.
        
        Required arguments:
        -genome RefGenome   "RefGenome" is the short name of your reference genome, such as "mm39", "ce11", "hg38".    (no default)
        -in inputDir        "inputDir" is the name of input path that contains your BAM files.  (no default)
        -out outDir         "outDir" is the name of output path that contains your running results of this step.  (no default)
        -----------------------------------------------------------------------------------------------------------
        For more details about this pipeline and other NGS data analysis piplines, please visit https://github.com/CTLife/2ndGS_Pipelines
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------------------------------------------
';

## Version Infromation
my $version = "     The call peaks Step, version 1.1,  2023-07-01.";

## Keys and Values
if ($#ARGV   == -1)   { say  "\n$HELP\n";  exit 0;  }       ## when there are no any command argumants.
if ($#ARGV%2 ==  0)   { @ARGV = (@ARGV, "-help") ;  }       ## when the number of command argumants is odd.
my %args = @ARGV;

## Initialize  Variables
$genome_g = 'hg38';     ## This is only an initialization value or suggesting value, not default value.
$input_g  = 'Input';    ## This is only an initialization value or suggesting value, not default value.
$IP_g     = 'IP';       ## This is only an initialization value or suggesting value, not default value.
$output_g = 'MACS2';    ## This is only an initialization value or suggesting value, not default value.

## Available Arguments
my $available = "   -version    -help   -genome   -in  -ip   -out  ";
my $boole = 0;
while( my ($key, $value) = each %args ) {
    if ( ($key =~ m/^\-/) and ($available !~ m/\s$key\s/) ) {say    "\n\tCann't recognize $key";  $boole = 1; }
}
if($boole == 1) {
    say  "\tThe Command Line Arguments are wrong!";
    say  "\tPlease see help message by using 'perl  callPeaks_MeRIP.pl  -help' \n";
    exit 0;
}

## Get Arguments
if ( exists $args{'-version' }   )     { say  "\n$version\n";    exit 0; }
if ( exists $args{'-help'    }   )     { say  "\n$HELP\n";       exit 0; }
if ( exists $args{'-genome'  }   )     { $genome_g = $args{'-genome'  }; }else{say   "\n -genome is required.\n";   say  "\n$HELP\n";    exit 0; }
if ( exists $args{'-in'      }   )     { $input_g  = $args{'-in'      }; }else{say   "\n -in     is required.\n";   say  "\n$HELP\n";    exit 0; }
if ( exists $args{'-ip'      }   )     { $IP_g     = $args{'-ip'      }; }else{say   "\n -ip     is required.\n";   say  "\n$HELP\n";    exit 0; }
if ( exists $args{'-out'     }   )     { $output_g = $args{'-out'     }; }else{say   "\n -out    is required.\n";   say  "\n$HELP\n";    exit 0; }

## Conditions
$genome_g =~ m/^\S+$/    ||  die   "\n\n$HELP\n\n";
$input_g  =~ m/^\S+$/    ||  die   "\n\n$HELP\n\n";
$IP_g     =~ m/^\S+$/    ||  die   "\n\n$HELP\n\n";
$output_g =~ m/^\S+$/    ||  die   "\n\n$HELP\n\n";

## Print Command Arguments to Standard Output
say  "\n
        ################ Arguments ###############################
                Reference Genome:  $genome_g
                Input       Path:  $input_g
                IP          Path:  $IP_g
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

opendir(my $DH_IP_g, $IP_g)  ||  die;
my @IPFiles_g1 = readdir($DH_IP_g);

my $numCores_g   = 16;
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

&printVersion("macs2  --version");
###################################################################################################################################################################################################





###################################################################################################################################################################################################
say   "\n\n\n\n\n\n##################################################################################################";
say   "Detecting BAM files in input folder ......";
my @BAMfiles_g = ();
{
open(seqFiles_FH, ">", "$output2_g/BAM-Files.txt")  or  die; 
for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {     
    next unless $inputFiles_g[$i] =~ m/\.bam$/;
    next unless $inputFiles_g[$i] !~ m/^[.]/;
    next unless $inputFiles_g[$i] !~ m/[~]$/;
    next unless $inputFiles_g[$i] !~ m/^unpaired/;
    say    "\t......$inputFiles_g[$i]"; 
    $BAMfiles_g[$#BAMfiles_g+1] =  $inputFiles_g[$i];
    say        "\t\t\t\tBAM file:  $inputFiles_g[$i]\n";
    say   seqFiles_FH  "BAM file:  $inputFiles_g[$i]\n";
}

say   seqFiles_FH  "\n\n\n\n\n";  
say   seqFiles_FH  "All BAM files:@BAMfiles_g\n\n\n";
say        "\t\t\t\tAll BAM files:@BAMfiles_g\n\n";
my $num1 = $#BAMfiles_g + 1;
say seqFiles_FH   "\nThere are $num1 BAM files.\n";
say         "\t\t\t\tThere are $num1 BAM files.\n";
}



my @IPfiles_g = ();
{
open(seqFiles_FH, ">", "$output2_g/IP-Files.txt")  or  die; 
for ( my $i=0; $i<=$#IPFiles_g1; $i++ ) {     
    next unless $IPFiles_g1[$i] =~ m/\.bam$/;
    next unless $IPFiles_g1[$i] !~ m/^[.]/;
    next unless $IPFiles_g1[$i] !~ m/[~]$/;
    next unless $IPFiles_g1[$i] !~ m/^unpaired/;
    say    "\t......$IPFiles_g1[$i]"; 
    $IPfiles_g[$#IPfiles_g+1] =  $IPFiles_g1[$i];
    say        "\t\t\t\tBAM file:  $IPFiles_g1[$i]\n";
    say   seqFiles_FH  "BAM file:  $IPFiles_g1[$i]\n";
}

say   seqFiles_FH  "\n\n\n\n\n";  
say   seqFiles_FH  "All BAM files:@IPfiles_g\n\n\n";
say        "\t\t\t\tAll BAM files:@IPfiles_g\n\n";
my $num1 = $#IPfiles_g + 1;
say seqFiles_FH   "\nThere are $num1 BAM files.\n";
say         "\t\t\t\tThere are $num1 BAM files.\n";
}



@BAMfiles_g = sort(@BAMfiles_g);
@IPfiles_g  = sort(@IPfiles_g);

say("###########################################");
say($#BAMfiles_g);
say($#IPfiles_g);
say("###########################################");
###################################################################################################################################################################################################





###################################################################################################################################################################################################
my $genome_size_g = '';  
if($genome_g eq 'hg38')  {$genome_size_g = 'hs'; }
if($genome_g eq 'dm6' )  {$genome_size_g = 'dm'; }
if($genome_g eq 'mm39')  {$genome_size_g = 'mm'; }
print("\n\ngenome_size: $genome_size_g\n\n");
###################################################################################################################################################################################################





###################################################################################################################################################################################################
say   "\n\n\n\n\n\n##################################################################################################";
say   "Peak calling for narrow peaks ......";

{
&myMakeDir("$output_g");
my $outputDir1 = "$output_g/narrow_run1";
my $outputDir2 = "$output_g/narrow_run2";
my $outputDir3 = "$output_g/narrow_run3";
my $outputDir4 = "$output_g/narrow_run4";
my $outputDir5 = "$output_g/narrow_run5";

&myMakeDir($outputDir1);
&myMakeDir($outputDir2);
&myMakeDir($outputDir3);
&myMakeDir($outputDir4);
&myMakeDir($outputDir5);

for ( my $i=0; $i<=$#BAMfiles_g; $i++ ) { 
    my $ctrl = $BAMfiles_g[$i];
    my $temp = $IPfiles_g[$i];
    say("\n\nIP:$temp, Input:$ctrl\n\n");
    
    $temp =~ s/\.bam$//  or  die;
    &myMakeDir("$outputDir1/$temp");
    &myMakeDir("$outputDir2/$temp");
    &myMakeDir("$outputDir3/$temp");
    &myMakeDir("$outputDir4/$temp");
    &myMakeDir("$outputDir5/$temp");

    system("macs2  callpeak   --control  $input_g/$ctrl    --treatment $IP_g/$temp.bam       --format BAM   --gsize $genome_size_g   --keep-dup all     --outdir $outputDir1/$temp    --name $temp      --verbose 3         --qvalue 0.05                                   >> $outputDir1/$temp.runLog    2>&1");                    
    system("macs2  callpeak   --control  $input_g/$ctrl    --treatment $IP_g/$temp.bam       --format BAM   --gsize $genome_size_g   --keep-dup all     --outdir $outputDir2/$temp    --name $temp      --verbose 3         --qvalue 0.05     --nomodel                     >> $outputDir2/$temp.runLog    2>&1");                    
    system("macs2  callpeak   --control  $input_g/$ctrl    --treatment $IP_g/$temp.bam       --format BAM   --gsize $genome_size_g   --keep-dup all     --outdir $outputDir3/$temp    --name $temp      --verbose 3         --qvalue 0.05     --nomodel    --extsize 120    >> $outputDir3/$temp.runLog    2>&1");                    
    system("macs2  callpeak   --control  $input_g/$ctrl    --treatment $IP_g/$temp.bam       --format BAM   --gsize $genome_size_g   --keep-dup 5       --outdir $outputDir4/$temp    --name $temp      --verbose 3         --qvalue 0.05     --nomodel    --extsize 120    >> $outputDir4/$temp.runLog    2>&1");    
    system("macs2  callpeak   --control  $input_g/$ctrl    --treatment $IP_g/$temp.bam       --format BAM   --gsize $genome_size_g   --keep-dup 1       --outdir $outputDir5/$temp    --name $temp      --verbose 3         --qvalue 0.05      -nomodel    --extsize 120    >> $outputDir5/$temp.runLog    2>&1");   
    
 }

}
###################################################################################################################################################################################################



 




###################################################################################################################################################################################################
say   "\n\n\n\n\n\n##################################################################################################";
say   "\tJob Done! Cheers! \n\n\n\n\n";


 

  
## END
