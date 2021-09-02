#!/bin/bash -xv

IFS='\n'; echo "$(curl http://localhost/data.txt)" > test2.txt
text_tn=$(echo -e "\n"$(cat test2.txt | sed -n '2,9p'))
text_tc=$(echo -e "\n"$(cat test2.txt | sed -n '10,17p'))
text_ta=$(echo -e "\n"$(cat test2.txt | sed -n '18,25p'))
text_tp=$(echo -e "\n"$(cat test2.txt | sed -n '26,33p'))
text_ts=$(echo -e "\n"$(cat test2.txt | sed -n '34,41p'))
echo $text_tn
echo $text_tc
echo $text_ta
echo $text_tp
echo $text_ts
while read -r line;do
	var=$var$(awk '{print "time_namelookup_"$1"", $2z}');
	echo $var
done <<< $text_tn
echo "$var" | curl --data-binary @- http://localhost:9091/metrics/job/instance/machine/1
var=null
#curl -X POST -H "Content-Type: text/plain" --data "$var" http://localhost:9091/metrics/job/instance/machine/1
while read -r line;do
	var=$var$(awk '{print "time_connect_"$1"", $2z}');
	echo $var
done <<< $text_tc
echo "$var" | curl --data-binary @- http://localhost:9091/metrics/job/instance/machine/1
var=null
while read -r line;do
	var=$var$(awk '{print "time_appconnect_"$1"", $2z}');
	echo $var
done <<< $text_ta
echo "$var" | curl --data-binary @- http://localhost:9091/metrics/job/instance/machine/1
var=null
while read -r line;do
	var=$var$(awk '{print "time_pretransfer_"$1"", $2z}');
	echo $var
done <<< $text_tp
echo "$var" | curl --data-binary @- http://localhost:9091/metrics/job/instance/machine/1
var=null
while read -r line;do
	var=$var$(awk '{print "time_starttransfer_"$1"", $2z}');
	echo $var
done <<< $text_ts
echo "$var" | curl --data-binary @- http://localhost:9091/metrics/job/instance/machine/1
var=null
#
