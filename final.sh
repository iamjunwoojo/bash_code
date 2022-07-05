module load samtools-1.13/1.13
module load megahit/1.2.9
if [ $?==0 ]
then 
echo "samtools module load 성공"
else
exit 1
echo "module load 비성공"
fi



for i in $(ls|grep TCGA|grep -v bash|grep -v "\.d$")
do mkdir $i.d
mv $i $i.d
done

echo -e  "Process 1 Completed \n"



for i in $(ls|grep TCGA|grep \.d$)
do cd $i
if [ $(ls|grep bam|wc -l) -eq 0 ]
then
echo "${i} 는 파일이 bamfile 이 1개"
samtools view --threads 10 -bh -f 4 "$(ls|grep TCGA)" >unmapped.bam
else
echo "${i} 는 이미 unmmaped 된 bam 파일이 있음"
fi
cd ..
done

echo -e "Process 2 Completed \n"



for i in $(ls|grep TCGA|grep \.d$)
do cd $i
if [ ! -f total.fastq ]
then
samtools fastq --threads 10 unmapped.bam > total.fastq
else
echo "${i} 는 이미 total.fastq 있음"
fi
cd ../
done



echo -e  "Process 3 Completed \n"

for i in $(ls|grep TCGA|grep \.d$)
do cd $i
if [ -f total.fastq ] && [ ! -f repair.1.fq ]
then
repair.sh -eoom -Xmx80g in=total.fastq out=repair.1.fq out2=repair.2.fq outs=repair.s.fq
else
echo "repair 과정 했음"
fi
cd ..
done

echo -e "Process 4 Completed \n"





for i in $(ls|grep TCGA|grep \.d$)
do cd $i
if [ -f repair.1.fq ] && [ ! -d trimmomatic ]
then
#adapter위치 새로마춰야됨
trimmomatic PE -threads 7  repair.1.fq repair.2.fq forward_paired.fq forward_unpaired.fq reverse_paired.fq reverse_unpaired.fq ILLUMINACLIP:/home/junwoojo/adapter:2:30:10:2:True LEADING:3 TRAILING:3 &
trimmomatic SE -threads 7  repair.s.fq single_end.fq ILLUMINACLIP:/home/junwoojo/adapter:2:30:10:2:True LEADING:3 TRAILING:3 &
wait
mkdir trimmomatic
mv forward* trimmomatic/
mv reverse* trimmomatic/
mv single* trimmomatic/
cd trimmomatic/
cat forward_unpaired.fq reverse_unpaired.fq single_end.fq > singleton.fq
rm forward_unpaired.fq reverse_unpaired.fq single_end.fq
cd ../../
else
echo "${i}  trimming 이미 했음"
cd ../
fi
done




echo -e "Process 5 Completed \n"






for i in $(ls|grep TCGA|grep \.d$)
do

if [ ! -d ${i}/trimmomatic ] || [ -f ${i}/trimmomatic/${i}.sam ]
then
echo "${i} 는 이미 human에 맵핑했거나 trimming이 안됨"
continue

elif [ -s ${i}/trimmomatic/forward_paired.fq ] && [ -s ${i}/trimmomatic/singleton.fq ]
then
cd $i/trimmomatic
#경우에따라 human reference 위치 바꿔야됨
bowtie2 --threads 8 -x /home/junwoojo/REFERENCE/human_bowtie2/human -1 forward_paired.fq -2 reverse_paired.fq -U  singleton.fq  -S ${i}.sam
cd ../../

elif [ ! -s ${i}/trimmomatic/forward_paired.fq ]
then
cd $i/trimmomatic
#경우에따라 human reference 위치 바꿔야됨
bowtie2 --threads 8 -x /home/junwoojo/REFERENCE/human_bowtie2/human  -U  singleton.fq  -S ${i}.sam
cd ../../

fi

done

echo -e  "Process 6 Completed \n"

wait

for i in $(ls|grep TCGA|grep \.d$)
do

if [ -f ${i}/trimmomatic/unmapped.bam ]
then
echo "bam file 이 이미 있음"
continue
fi

if [ ! -f ${i}/trimmomatic/${i}.sam ]
then
echo "sam file이 없음"
continue
fi

if [ -f ${i}/trimmomatic/${i}.sam ] && [ ! -f ${i}/trimmomatic/unmapped.bam ]
then
cd ${i}/trimmomatic
samtools view --threads 10 -bh -f 4 "$(ls|grep TCGA)" >unmapped.bam
echo "${i} unmapped 완료"
cd ../../
fi

done

echo -e "Process 7 Completed \n"


for i in $(ls|grep TCGA|grep \.d$)
do
if [ -s ${i}/trimmomatic/unmapped.bam ] && [ ! -f ${i}/trimmomatic/final.s.fq ]
then
cd ${i}/trimmomatic
samtools fastq --threads 10  unmapped.bam >  final.fastq
repair.sh -eoom -Xmx80g in=final.fastq out=final.1.fq out2=final.2.fq outs=final.s.fq
cd ../../

elif [ ! -f ${i}/trimmomatic/unmapped.bam ]
then
echo "mapping 이 안됨 unmapped.bam 파일 확인하십시오"

elif [ -f ${i}/trimmomatic/final.s.fq ]
then
echo "final.s.fq 파일이 이미  존재합니다"

fi
done

echo -e "Process 8 Completed \n"



for i in $(ls|grep TCGA|grep \.d$)
do
if [ -s ${i}/trimmomatic/unmapped.bam ] && [ -f ${i}/trimmomatic/final.s.fq ] && [ ! -d ${i}/trimmomatic/megahit_out ]
then

if [ -s ${i}/trimmomatic/final.1.fq ]
then
cd ${i}/trimmomatic/
megahit -t 10 -1 final.1.fq -2 final.2.fq -r final.s.fq -o megahit_out
cd ../../
fi

elif [ -s ${i}/trimmomatic/final.s.fq ] && [ ! -s ${i}/trimmomatic/final.1.fq ]
then
megahit -t 10 -r final.s.fq -o megahit_out

else
echo "megahit_out 폴더가 이미 있거나 unmmapped파일이 없거나 final.s.fq 파일이 없습니다. 다시 확인해주세요"

fi

done

echo -e "Process 9 Completed \n"


for i in $(ls|grep TCGA|grep \.d$)
do
if [ -d ${i}/trimmomatic/megahit_out ]
cd ${i}/trimmomatic/megahit_out
