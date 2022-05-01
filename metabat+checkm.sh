cd $i/
cd trimmomatic
cd final
cd megahit_out
mkdir contig_bowtie_index
cd contig_bowtie_index/ 
bowtie2-build --threads 15 ../final.contigs.fa cotig
cd ..
bowtie2  --threads 11 -x contig_bowtie_index/cotig -1 ../repair.1.fq -2 ../repair.2.fq  -U ../repair.s.fq -S contig.sam
samtools view --threads 11 -S -b  contig.sam >  contig.bam
samtools sort  --threads 11 contig.bam >contig.bam.sorted
runMetaBat.sh final.contigs.fa contig.bam.sorted

checkm lineage_wf  -f checkm.txt -t 15 -x fa final.contigs.fa.metabat-bins/ checkm_output
cd ../../../../
