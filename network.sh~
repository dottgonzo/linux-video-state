#!/bin/bash
net=false
quality="unknown"
for (( n=0; n<$(ifconfig -s | awk '{print($1)}' | grep -v Iface | grep -v lo | wc -l); n++ )); do

nni=$(( $n + 1 ))
n_label=$(ifconfig -s | awk '{print($1)}' | grep -v Iface | grep -v lo | sed -n $nni''p)

n_mac=$(ifconfig $n_label | grep 'Link'| awk '{print($5)}')





	if [[ $(ifconfig $n_label | grep -c 'inet') > 0 ]]; then

	n_ip=$(ip a | grep inet | grep $n_label | awk '{print$(2)}'|sed 's/\/24//g')

	n_inuse=true



		if [[ $(route | grep default | awk '{print($8)}') == $n_label ]]; then
		n_connected=true



		else
		n_connected=false
		fi


	else

	n_ip="none"
	n_inuse=false
	n_connected=false
	fi

if iwconfig $n_label > /dev/null 2>&1 ; then
net_essid=$(iwgetid | grep $n_label | sed -e '/ESSID/!d' -e 's/.*ESSID:"/"/' | sed 's/"//g')
else
net_essid=""
fi





if [[ $(iwconfig 2> /dev/null | grep -c $n_label) > 0 ]]; then


iwlist $n_label scan > /tmp/.wifiscan$n_label.tmp


nettest=0
   for (( iw=1;iw<=$(cat /tmp/.wifiscan$n_label.tmp | grep -c ESSID);iw++ )); do


iw_essid=$(cat /tmp/.wifiscan$n_label.tmp | grep ESSID | sed "s/^.*ESSID://g" | sed -s 's/"//g' | sed -n $iw''p )

iw_signal=$(cat /tmp/.wifiscan$n_label.tmp | grep Quality | sed "s/^.*Q/Q/g" | sed -n $iw''p )

iw_mac=$(cat /tmp/.wifiscan$n_label.tmp | grep Cell | awk '{print($5)}' | sed -n $iw''p)

netwifi='{"ESSID":"'$iw_essid'","mac":"'$iw_mac'","signal":"'$iw_signal'"}'

if [[ $nettest == 0 ]];then
netscan="$netwifi"
nettest=1
else
netscan="$netscan,$netwifi"
fi

if [[ $n_connected == true && $n_inuse == true && $iw_essid == $net_essid ]]; then
quality=$iw_signal
fi

done


scan="[$netscan]"
else

scan='"no wifi"'

fi











network='{"dev":"'$n_label'","mac":"'$n_mac'","ip":"'$n_ip'","inuse":'$n_inuse',"connected":'$n_connected',"essid":"'$net_essid'","scan":'$scan'}'

if [[ $n_connected == true && $n_inuse == true ]]; then
net='{"dev":"'$n_label'","mac":"'$n_mac'","ip":"'$n_ip'","essid":"'$net_essid'","quality":"'$quality'"}'
fi

if [[ "$n" == "0" ]]; then
networks="$network"
else
networks="$networks,$network"
fi


done
if [[ $net != false ]]; then
  echo '{"networks":['$networks'],"network":'$net'}'
else
  echo '{"networks":['$networks'],"network":false}'

fi
