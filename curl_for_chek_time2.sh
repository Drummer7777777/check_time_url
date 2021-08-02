#!/bin/bash -xv
set -euo pipefail
perc_25()
{
	local -n arr=$1
	count_el=${#arr[@]}
	$count_el
	let ""el_perc=$(echo "scale=3; (25/100*($count_el-1)+1)" | bc | awk '{ print int($1) }')-1"" 
	echo ${arr[$el_perc]}
}
perc_50()
{
	local -n arr=$1
	count_el=${#arr[@]}
	$count_el
	let ""el_perc=$(echo "scale=3; (50/100*($count_el-1)+1)" | bc | awk '{ print int($1) }')-1"" 
	echo ${arr[$el_perc]}
}
perc_70()
{
	local -n arr=$1
	count_el=${#arr[@]}
	$count_el
	let ""el_perc=$(echo "scale=3; (70/100*($count_el-1)+1)" | bc | awk '{ print int($1) }')-1"" 
	echo ${arr[$el_perc]}
}
perc_95()
{
	local -n arr=$1
	count_el=${#arr[@]}
	$count_el
	let ""el_perc=$(echo "scale=3; (95/100*($count_el-1)+1)" | bc | awk '{ print int($1) }')-1"" 
	echo ${arr[$el_perc]}
}
perc_99()
{
	local -n arr=$1
	count_el=${#arr[@]}
	$count_el
	let ""el_perc=$(echo "scale=3; (99/100*($count_el-1)+1)" | bc | awk '{ print int($1) }')-1"" 
	echo ${arr[$el_perc]}
}
#mean()
#{
#	local -n arr=$1
#	count_el=${#arr[@]}
#	for 
#}
sort_bubble()
{
	local -n arr=$1
	for (( i=0; i<=$count; i++ )); do
		let "count2=$count-$i-1"
		$count
		$count2
		for (( j=0; j<=$count2; j++ )); do
			let "temp_j=$j+1"
			if [[ ${arr[$j]}>${arr[$temp_j]} ]]; then
				temp=${arr[j]}
				let "temp_j=$j+1"
				arr[$j]=${arr[$temp_j]}
				arr[$temp_j]=$temp
			fi
		done
	done
	echo ${arr[@]}
}
sortirovochka()
{
	if (( "$2">="$3" )); then
		return
	else
	ii=$2
	jj=$3
	let "z=$jj/2"
	q=${arr[z]}
	while (( "$ii"<="$jj")); do
		while [[ ${arr[ii]}<$q ]]; do
			let "ii = $ii + 1"
		done
		while [[ ${arr[jj]}>$q ]]; do
			let "jj=$jj-1"
		done
		if (( "$ii"<="$jj" )); then
			zam=${arr[ii]}
			arr[$ii]=${arr[jj]}
			arr[$jj]=$zam
			let "ii = $ii + 1"
			let "jj = $jj - 1"
			sortirovochka arr $2 $jj
			sortirovochka arr $ii $3
		fi
	done
	fi

}
sortirovka()
{	
	name=$1[@]
	local a=("${!name}")
	declare -a arr
	for i in "${a[@]}"; do
		arr+=("$i")	
	done
	sortirovochka arr $2 $3
	name=arr[@]
	local a=("${!name}")
	unset url1_tn
	declare -a url1_tn
	for i in "${a[@]}"; do
		url1_tn+=("$i")	
	done
	echo ${url1_tn[@]}
}
razn ()
{
	vichitaem="$1"
	umenshaem="$2"
	raznost=$(echo "$umenshaem-$vichitaem" | bc -l | sed 's/^\./0./')
	echo "$raznost"
	return 0
}
#read url_1
#read url_2
read count_chek
url_1="https://www.google.ru/"
url_2="https://www.yandex.ru/"
i=1
declare -A url1_mas
declare -A url2_mas
for url in $url_1 $url_2; do
	i=1
	url1_tn_sum=0
	echo $url $url_1 $url_2
	if [ "$url" = "$url_1" ]; then
		while [ $i -le $count_chek ]; do
		url1_mas[$i]=$(echo "$(curl -w ""%{time_namelookup}" "%{time_connect}" "%{time_appconnect}" "%{time_pretransfer}" "%{time_starttransfer}"" -so /dev/null $url)" | sed 's/,/./g') 
		read -a url1_data <<< "${url1_mas[$i]}"

		url1_tn+=("${url1_data[0]}")
		url1_tc+=("$(razn ${url1_data[0]} ${url1_data[1]})")
		url1_ta+=("$(razn ${url1_data[1]} ${url1_data[2]})")
		url1_tp+=("$(razn ${url1_data[2]} ${url1_data[3]})")
		url1_ts+=("$(razn ${url1_data[3]} ${url1_data[4]})")
		url1_tn_sum=$(echo "${url1_data[0]}+$url1_tn_sum" | bc -l | sed 's/^\./0./')
		let "i+=1"
		done
		let "count=${#url1_tn[@]}-1"
		read -a url_tn_old <<< ${url1_tn[@]}
		read -a url1_tn <<< $(sort_bubble url1_tn $count)
		read -a url_tc_old <<< ${url1_tc[@]}
		read -a url1_tc <<< $(sort_bubble url1_tc $count)
		read -a url_ta_old <<< ${url1_ta[@]}
		read -a url1_ta <<< $(sort_bubble url1_ta $count)
		read -a url_tp_old <<< ${url1_tp[@]}
		read -a url1_tp <<< $(sort_bubble url1_tp $count)
		read -a url_ts_old <<< ${url1_ts[@]}
		read -a url1_ts <<< $(sort_bubble url1_ts $count)
		read -a perc_25_tn <<< $(perc_25 url1_tn)
		read -a perc_50_tn <<< $(perc_50 url1_tn)
		read -a perc_70_tn <<< $(perc_70 url1_tn)
		read -a perc_95_tn <<< $(perc_95 url1_tn)
		read -a perc_99_tn <<< $(perc_99 url1_tn)
		#read -a url1_tn <<< $(sortirovka url1_tn 0 $count)
	else
		while [ $i -le $count_chek ]; do
		url2_mas[$i]=$(curl -w "["time_namelookup"]="%{time_namelookup}" ["time_connect"]="%{time_connect}" ["time_appconnect"]="%{time_appconnect}" ["time_pretransfer]"="%{time_pretransfer}" ["time_starttransfer"]="%{time_starttransfer}"" -so /dev/null $url)
		let "i+=1"
		done
	fi
done
echo -e "url_tn\n ${url_tn_old[@]}"
echo -e "url_tn\n ${url1_tn[@]}"
#echo -e "url_tc\n ${url_tc_old[@]}"
#echo -e "url_tc\n ${url1_tc[@]}"
#echo -e "url_ta\n ${url_ta_old[@]}"
#echo -e "url_ta\n ${url1_ta[@]}"
#echo -e "url_tp\n ${url_tp_old[@]}"
#echo -e "url_tp\n ${url1_tp[@]}"
#echo -e "url_ts\n ${url_ts_old[@]}"
#echo -e "url_ts\n ${url1_ts[@]}"
echo $perc_25_tn
echo $perc_50_tn
echo $perc_70_tn
echo $perc_95_tn
echo $perc_99_tn
echo $url1_tn_sum
