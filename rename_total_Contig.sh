for i in $(ls|grep TCGA)
do cd $i/trimmomatic/final/megahit_out
python ../../../../test.py $(echo $i|sed 's/\.d$/_contig/')
cd ../../../../
done
