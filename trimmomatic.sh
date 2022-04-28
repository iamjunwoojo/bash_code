find
for i in $(ls|grep TCGA|grep -v bash)
do cd $i
trimmomatic PE -threads 7  repair.1.fq repair.2.fq forward_paired.fq forward_unpaired.fq reverse_paired.fq reverse_unpaired.fq ILLUMINACLIP:/home/junwoojo/donefile_energy/adapter:2:30:10:2:True LEADING:3 TRAILING:3 &
trimmomatic SE -threads 7  repair.s.fq single_end.fq ILLUMINACLIP:/home/junwoojo/donefile_energy/adapter:2:30:10:2:True LEADING:3 TRAILING:3 &
wait
mkdir trimmomatic
mv forward* trimmomatic/
mv reverse* trimmomatic/
mv single* trimmomatic/
cd trimmomatic/
cat forward_unpaired.fq reverse_unpaired.fq single_end.fq > singleton.fq
cd ../../
done
