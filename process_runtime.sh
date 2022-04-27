start=`date +%s`
echo "start"

#insert process code

end=`date +%s`
diff=$((${end}-${start}))
echo $diff > spades_time
