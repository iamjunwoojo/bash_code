ls |grep -v bash|grep TCGA > all_file
for i in {0..100..5}
do
for k in $(cat all_file|head -n $i|tail -n 5|tr '\n' ' ')
do cd $k/trimmomatic
bowtie2 --threads 2 -x /home/junwoojo/TCGA/done_file/human_bowtie2/human -1 forward_paired.fq -2 reverse_paired.fq -U  singleton.fq  -S $k.sam &
cd ../../
done
wait
done
