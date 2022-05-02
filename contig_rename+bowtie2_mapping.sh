for i in $(ls|grep TCGA)
do cd $i/trimmomatic/final/megahit_out
python ../../../../test.py $(echo $i|sed 's/\.d$/_contig/')
cd ../../../../
done


wait

mkdir totalcontig
cat  */trimmomatic/final/megahit_out/contig_above_1000 >total_contig
mv total_contig totalcontig/

wait

cd totalcontig/
bowtie2-build --threads 16 total_contig  total
cd ../

wait

for i in $(ls|grep TCGA)
do
bowtie2 --threads 15 -x totalcontig/total -1 /home/syc/hdd_ext2/junwoojo/donefile_bash/${i}/trimmomatic/final/repair.1.fq  -2 /home/syc/hdd_ext2/junwoojo/donefile_bash/${i}/trimmomatic/final/repair.2.fq  -U  /home/syc/hdd_ext2/junwoojo/donefile_bash/${i}/trimmomatic/final/repair.s.fq -S metabat/$i.sam
done
