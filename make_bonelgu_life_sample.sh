mkdir bonelgu_${1}_${2}
for i in $(ls|grep TCGA)
do
mkdir bonelgu_${1}_${2}/${i}
cp -r ${i}/megahit_out   bonelgu_${1}_${2}/${i}/megahit_out
rm -r  bonelgu_${1}_${2}/${i}/megahit_out/intermediate_contigs bonelgu_${1}_${2}/${i}/megahit_out/log bonelgu_${1}_${2}/${i}/megahit_out/options.json bonelgu_${1}_${2}/${i}/megahit_out/checkpoints.txt bonelgu_${1}_${2}/${i}/megahit_out/done
done
