for i in $(ls|grep TCGA)
do 
if [ ! -f $i/repair.1.fq ]
then
cd $i
repair.sh -eoom -Xmx80g in=1.fq in2=2.fq out=repair.1.fq out2=repair.2.fq outs=repair.s.fq
cd ..
fi
done
