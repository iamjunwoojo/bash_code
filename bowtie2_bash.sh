ls |grep -v bash|grep TCGA|sed 's/.d$//g' > all_file
for i in {0..100..5}
do
for k in $(cat all_file|head -n $i|tail -n 5|tr '\n' ' ')
do cd $i/trimmomatic
bowtie2 -x -1 forward_paired.fq -2 reverse_paired.fq -U  singleton.fq  &
done
wait
done
