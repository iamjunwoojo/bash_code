cat trimmomatic_bash 
for i in $(ls|grep TCGA|grep -v bash)
do cd $i
trimmomatic PE -threads 7  repair.1.fq repair.2.fq forward_paired.fq forward_unpaird.fq reverse_paired.fq reverse_unpaird.fq ILLUMINACLIP::2:30:10:2:True LEADING:3 TRAILING:3 &
trimmomatic SE -threads 7  repair.s.fq single_end.fq ILLUMINACLIP::2:30:10:2:True LEADING:3 TRAILING:3 &
wait
mkdir trimmomatic
mv forward* trimmomatic/
mv reverse* trimmomatic/
mv single* trimmomatic/
cd ..
done
