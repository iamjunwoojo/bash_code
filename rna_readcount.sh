for i in $(ls|grep \.csv|grep -v ttt);do less $i|cut -d "," -f 1 > rowname;done
for i in $(ls|grep \.csv);do less $i|cut -d "," -f 2 > $i.ttt;done
paste -d "," rowname *ttt >total_count_matrix
