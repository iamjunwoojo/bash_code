mkdir bonelgu_${1}_${2}
for i in $(ls|grep TCGA)
do
mkdir bonelgu_${1}_${2}/${i}
mkdir bonelgu_${1}_${2}/${i}/megahit_out
cp ${i}/megahit_out/final.contigs.fa   bonelgu_${1}_${2}/${i}/megahit_out/
cp ${i}/flagstat* bonelgu_${1}_${2}/${i}/
done
