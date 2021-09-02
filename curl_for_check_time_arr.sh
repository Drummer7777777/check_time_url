#!/bin/bash
set -euo pipefail
#set fileformat=unix
if [[ ! -d "~/git_repos/curl-metrics" ]]; then
	mkdir -p "~/git_repos/curl-metrics"
fi
exec 1>~/git_repos/curl-metrics/tmp_data.txt
print_url_in_total()
{
	num=1
	for url in ${url_arr[*]}; do
		echo -n "| URL $num "
		let "num=$num+1"
	done
}
total()
{
	echo "$count_chek Retries with inteval $interval"
	#echo "Test estimated time: $DIFF"	
	number=1
	#for url in ${url_arr[*]}; do
	#	echo $number $url
	#	let "number=$number+1"
	#done
	#echo -n "Metric: time_namelookup "
	#print_url_in_total
	echo -e 99: ${perc_99_tn[@]}
	echo -e 95: ${perc_95_tn[@]}
	echo "70: ${perc_70_tn[@]}"
	echo "50: ${perc_50_tn[@]}"
	echo 25: ${perc_25_tn[@]}
	echo MEAN: ${url1_tn_mean[@]}
	echo MIN: ${url1_tn_min[@]}
	echo MAX: ${url1_tn_max[@]}
	#echo -n "Metric: time_connect "
	#print_url_in_total
	echo -e "99: ${perc_99_tc[@]}"
	echo 95: ${perc_95_tc[@]}
	echo 70: ${perc_70_tc[@]}
	echo 50: ${perc_50_tc[@]}
	echo 25: ${perc_25_tc[@]}
	echo MEAN: ${url1_tc_mean[@]}
	echo MIN: ${url1_tc_min[@]}
	echo MAX: ${url1_tc_max[@]}
	#echo -n "Metric: time_appconnect "
	#print_url_in_total
	echo -e "99: ${perc_99_ta[@]}"
	echo 95: ${perc_95_ta[@]}
	echo 70: ${perc_70_ta[@]}
	echo 50: ${perc_50_ta[@]}
	echo 25: ${perc_25_ta[@]}
	echo MEAN: ${url1_ta_mean[@]}
	echo MIN: ${url1_ta_min[@]}
	echo MAX: ${url1_ta_max[@]}
	#echo -n "Metric: time_pretransfer "
	#print_url_in_total
	echo -e "99: ${perc_99_tp[@]}"
	echo 95: ${perc_95_tp[@]}
	echo 70: ${perc_70_tp[@]}
	echo 50: ${perc_50_tp[@]}
	echo 25: ${perc_25_tp[@]}
	echo MEAN: ${url1_tp_mean[@]}
	echo MIN: ${url1_tp_min[@]}
	echo MAX: ${url1_tp_max[@]}
	#echo -n "Metric: time_starttransfer "
	#print_url_in_total
	echo -e "99: ${perc_99_ts[@]}"
	echo 95: ${perc_95_ts[@]}
	echo 70: ${perc_70_ts[@]}
	echo 50: ${perc_50_ts[@]}
	echo 25: ${perc_25_ts[@]}
	echo MEAN: ${url1_ts_mean[@]}
	echo MIN: ${url1_ts_min[@]}
	echo "MAX: ${url1_ts_max[@]}"
}
percen()
{
	local -n arr=$1
	count_el=${#arr[@]}
	let ""el_perc=$(echo "scale=3; ("$2"/100*($count_el-1)+1)" | bc | awk '{ print int($1) }')-1"" 
	echo ${arr[$el_perc]}
}
sort_bubble()
{
	local -n arr=$1
	for (( i=0; i<=$count; i++ )); do
		let "count2=$count-$i-1"
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
razn ()
{
	vichitaem="$1"
	umenshaem="$2"
	raznost=$(echo "$umenshaem-$vichitaem" | bc -l | sed 's/^\./0./')
	echo "$raznost"
	return 0
}
#echo "Enter count url:"
read count_url
#echo "Enter urls:"
declare -a url_arr
count=1
while (( "$count"<=$count_url )); do
	#echo "$count:"
	read url
	url_arr+=("$url")
	let "count+=1"
done
#echo "Enter count check:"
read count_chek
#echo "Enter interval between requests:"
read interval
START=$(date +%s)
len_url_arr=${#url_arr[@]}
num_url_tot=0
i=1
declare -A url1_mas
declare -a url1_tn_sum
declare -a url1_tc_sum
declare -a url1_ta_sum
declare -a url1_tp_sum
declare -a url1_ts_sum
declare -a url1_tn_mean
declare -a url1_tc_mean
declare -a url1_ta_mean
declare -a url1_tp_mean
declare -a url1_ts_mean
num_url=0
for url in ${url_arr[@]}; do
	#echo $url
	i=1
	unset url1_tn
	unset url1_tc
	unset url1_ta
	unset url1_tp
	unset url1_ts
	url1_tn_sum+=("0")
	url1_tc_sum+=("0")
	url1_ta_sum+=("0")
	url1_tp_sum+=("0")
	url1_ts_sum+=("0")
		while [ $i -le $count_chek ]; do
		sleep $interval
		url1_mas[$i]=$(echo "$(curl -w ""%{time_namelookup}" "%{time_connect}" "%{time_appconnect}" "%{time_pretransfer}" "%{time_starttransfer}"" -so /dev/null $url)" | sed 's/,/./g') 
		read -a url1_data <<< "${url1_mas[$i]}"

		url1_tn+=("${url1_data[0]}")
		url1_tc+=("$(razn ${url1_data[0]} ${url1_data[1]})")
		url1_ta+=("$(razn ${url1_data[1]} ${url1_data[2]})")
		url1_tp+=("$(razn ${url1_data[2]} ${url1_data[3]})")
		url1_ts+=("$(razn ${url1_data[3]} ${url1_data[4]})")
		url1_tn_sum[$num_url]=$(echo ""${url1_tn[-1]}"+"${url1_tn_sum[$num_url]}"" | bc -l | sed 's/^\./0./')
		url1_tc_sum[$num_url]=$(echo ""${url1_tc[-1]}"+"${url1_tc_sum[$num_url]}"" | bc -l | sed 's/^\./0./')
		url1_ta_sum[$num_url]=$(echo ""${url1_ta[-1]}"+"${url1_ta_sum[$num_url]}"" | bc -l | sed 's/^\./0./')
		url1_tp_sum[$num_url]=$(echo ""${url1_tp[-1]}"+"${url1_tp_sum[$num_url]}"" | bc -l | sed 's/^\./0./')
		url1_ts_sum[$num_url]=$(echo ""${url1_ts[-1]}"+"${url1_ts_sum[$num_url]}"" | bc -l | sed 's/^\./0./')
		let "i+=1"
		done
		url1_tn_mean[$num_url]=$(echo "scale=6; "${url1_tn_sum[$num_url]}"/"$count_chek"" | bc -l | sed 's/^\./0./')
		url1_tc_mean[$num_url]=$(echo "scale=6; "${url1_tn_sum[$num_url]}"/"$count_chek"" | bc -l | sed 's/^\./0./')
		url1_ta_mean[$num_url]=$(echo "scale=6; "${url1_tn_sum[$num_url]}"/"$count_chek"" | bc -l | sed 's/^\./0./')
		url1_tp_mean[$num_url]=$(echo "scale=6; "${url1_tn_sum[$num_url]}"/"$count_chek"" | bc -l | sed 's/^\./0./')
		url1_ts_mean[$num_url]=$(echo "scale=6; "${url1_tn_sum[$num_url]}"/"$count_chek"" | bc -l | sed 's/^\./0./')
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
		url1_tn_min[$num_url]=${url1_tn[0]}
		url1_tc_min[$num_url]=${url1_tc[0]}
		url1_ta_min[$num_url]=${url1_ta[0]}
		url1_tp_min[$num_url]=${url1_tp[0]}
		url1_ts_min[$num_url]=${url1_ts[0]}
		url1_tn_max[$num_url]=${url1_tn[-1]}
		url1_tc_max[$num_url]=${url1_tc[-1]}
		url1_ta_max[$num_url]=${url1_ta[-1]}
		url1_tp_max[$num_url]=${url1_tp[-1]}
		url1_ts_max[$num_url]=${url1_ts[-1]}
		perc_25_tn[$num_url]=$(percen url1_tn 25)
		perc_50_tn[$num_url]=$(percen url1_tn 50)
		perc_70_tn[$num_url]=$(percen url1_tn 70)
		perc_95_tn[$num_url]=$(percen url1_tn 95)
		perc_99_tn[$num_url]=$(percen url1_tn 99)
		perc_25_tc[$num_url]=$(percen url1_tc 25)
		perc_50_tc[$num_url]=$(percen url1_tc 50)
		perc_70_tc[$num_url]=$(percen url1_tc 70)
		perc_95_tc[$num_url]=$(percen url1_tc 95)
		perc_99_tc[$num_url]=$(percen url1_tc 99)
		perc_25_ta[$num_url]=$(percen url1_ta 25)
		perc_50_ta[$num_url]=$(percen url1_ta 50)
		perc_70_ta[$num_url]=$(percen url1_ta 70)
		perc_95_ta[$num_url]=$(percen url1_ta 95)
		perc_99_ta[$num_url]=$(percen url1_ta 99)
		perc_25_tp[$num_url]=$(percen url1_tp 25)
		perc_50_tp[$num_url]=$(percen url1_tp 50)
		perc_70_tp[$num_url]=$(percen url1_tp 70)
		perc_95_tp[$num_url]=$(percen url1_tp 95)
		perc_99_tp[$num_url]=$(percen url1_tp 99)
		perc_25_ts[$num_url]=$(percen url1_ts 25)
		perc_50_ts[$num_url]=$(percen url1_ts 50)
		perc_70_ts[$num_url]=$(percen url1_ts 70)
		perc_95_ts[$num_url]=$(percen url1_ts 95)
		perc_99_ts[$num_url]=$(percen url1_ts 99)
		let "i+=1"
		let "num_url+=1"
done
END=$(date +%s)
DIFF=$(($END - $START))
total
mv ~/git_repos/curl-metrics/tmp_data.txt ~/git_repos/curl-metrics/data.txt
