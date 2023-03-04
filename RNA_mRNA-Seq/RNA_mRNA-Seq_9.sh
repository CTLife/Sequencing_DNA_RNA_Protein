sleep 4h

out1="9_DEGs/1A_featureCounts_DESeq2"
mkdir -p $out1
Rscript  RNA_mRNA-Seq_9_DESeq2_CL.r  --projectName=mRNA-Seq  --author=YongPeng  --targetFile=RNA_mRNA-Seq_9_target.featureCounts.txt  --rawDir=8_rawCounts/3_STAR/featureCounts_formatted  --varInt=group  --condRef=siCtrl  --alpha=0.05 > $out1/runLog.txt 2>&1
mv figures  $out1
mv tables   $out1
mv mRNA-Seq.RData        $out1
mv mRNA-Seq_report.html  $out1


out2="9_DEGs/1B_featureCounts_edgeR"
mkdir -p $out2
Rscript  RNA_mRNA-Seq_9_edgeR_CL.r  --projectName=mRNA-Seq  --author=YongPeng  --targetFile=RNA_mRNA-Seq_9_target.featureCounts.txt  --rawDir=8_rawCounts/3_STAR/featureCounts_formatted  --varInt=group  --condRef=siCtrl  --alpha=0.05 > $out2/runLog.txt 2>&1
mv figures  $out2
mv tables   $out2
mv mRNA-Seq.RData        $out2
mv mRNA-Seq_report.html  $out2






out3="9_DEGs/2A_htseq-count_DESeq2"
mkdir -p $out3
Rscript  RNA_mRNA-Seq_9_DESeq2_CL.r  --projectName=mRNA-Seq  --author=YongPeng  --targetFile=RNA_mRNA-Seq_9_target.htseq-count.txt  --rawDir=8_rawCounts/3_STAR/htseq-count  --varInt=group  --condRef=siCtrl  --alpha=0.05 > $out3/runLog.txt 2>&1
mv figures  $out3
mv tables   $out3
mv mRNA-Seq.RData        $out3
mv mRNA-Seq_report.html  $out3


out4="9_DEGs/2B_htseq-count_edgeR"
mkdir -p $out4
Rscript  RNA_mRNA-Seq_9_edgeR_CL.r  --projectName=mRNA-Seq  --author=YongPeng  --targetFile=RNA_mRNA-Seq_9_target.htseq-count.txt  --rawDir=8_rawCounts/3_STAR/htseq-count  --varInt=group  --condRef=siCtrl  --alpha=0.05 > $out4/runLog.txt 2>&1
mv figures  $out4
mv tables   $out4
mv mRNA-Seq.RData        $out4
mv mRNA-Seq_report.html  $out4


