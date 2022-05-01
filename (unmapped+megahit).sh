for i in $(ls|grep TCGA)
do cd $i
cd trimmomatic
samtools view --threads 15 -bh -f 4 ${i}.sam >unmapped.bam
cd ../../
done


for i in $(ls|grep TCGA)
do cd $i
cd trimmomatic
mkdir final
mv unmapped.bam  final/
cd final
samtools fastq --threads 15  unmapped.bam > all.fq
repair.sh -eoom -Xmx80g in=all.fq out=repair.1.fq out2=repair.2.fq outs=repair.s.fq
cd ../../../
done


for i in $(ls|grep TCGA)
do cd $i
cd trimmomatic
cd final
megahit -t 15 -1 repair.1.fq -2 repair.2.fq -r repair.s.fq  -o megahit_out
cd ../../../
done
