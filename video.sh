#! /bin/bash

#  v4l-conf v4l-utils





for (( i=0; i<$(ls /dev/v* | grep video | grep -v 'o6\|o7\|o8\|o9\|o10\|o11\|o12\|o13\|o14\|o15\|o16\|o17\|o18\|o19\|o20\|o21\|o22\|o23\|o24\|o25\|o26\|o27\|o28\|o29\|o30\|o31\|o32\|o33\|o34\|o35\|o36\|o37\|o38\|o39\|o40\|o41\|o50'|grep -c video); i++ )); do


vvi=$(( $i + 1 ))

id=$(ls /dev/v* | grep video | grep -v 'o6\|o7\|o8\|o9\|o10\|o11\|o12\|o13\|o14\|o15\|o16\|o17\|o18\|o19\|o20\|o21\|o22\|o23\|o24\|o25\|o26\|o27\|o28\|o29\|o30\|o31\|o32\|o33\|o34\|o35\|o36\|o37\|o38\|o39\|o40\|o41\|o50' | sed -n $vvi''p | sed 's/\/dev\/video//g') 

device="/dev/video$id"

label=$(udevadm info -p $(udevadm info -q path -n $device) | grep ID_MODEL=| sed 's/E: ID_MODEL=//g')
model_id=$(udevadm info -p $(udevadm info -q path -n $device) | grep ID_MODEL_ID| sed 's/E: ID_MODEL_ID=//g')
vendor_id=$(udevadm info -p $(udevadm info -q path -n $device) | grep ID_VENDOR_ID| sed 's/E: ID_VENDOR_ID=//g')
bus=$(udevadm info -p $(udevadm info -q path -n $device) | grep ID_BUS| sed 's/E: ID_BUS=//g')


if fuser -v $device > /dev/null 2>&1 ; then
v_active=true
else
v_active=false
fi

serial=$(udevadm info -p $(udevadm info -q path -n $device) | grep ID_MODEL=| sed 's/E: ID_MODEL=//g')


v_resolution=$(v4l-info $device | grep fmt.pix.width | awk '{print($3)}')' x '$(v4l-info $device | grep fmt.pix.height | awk '{print($3)}')


c_numbers=$(v4l-info $device | grep -c VIDIOC_ENUMINPUT)

for (( c=0; c<$c_numbers; c++ )); do


c_label=$(v4l-info $device | grep "VIDIOC_ENUMINPUT($c)" -A 5 | grep name | awk '{print($3)}' | sed 's/"//g')

c_dev=$(v4l-info $device | grep "VIDIOC_ENUMINPUT($c)" -A 5 | grep index | awk '{print($3)}' | sed 's/"//g')


        if [[ $(v4l2-ctl -d $device -I | awk '{print($4)}') == $c_dev ]] ; then
c_active='true'
else
c_active='false'
fi



channel='{"dev":"'$c_dev'","label":"'$c_label'","active":"'$c_active'"}'

if [[ "$c" == "0" ]]; then
channels=$channel
else
channels="$channels,$channel"
fi




#$(v4l-info $device | grep -c "VIDIOC_ENUMINPUT($c)" -A 5 | grep name | awk '{print($3)}' | sed 's/"//g' )

done

videoin='{"dev":"'$device'","label":"'$label'","active":"'$v_active'","model_id":"'$model_id'","vendor_id":"'$vendor_id'","resolution":"'$v_resolution'","bus":"'$bus'","serial":"'$serial'","channels":['$channels']}'

if [[ "$i" == "0" ]]; then
videoins="$videoin"
else
videoins="$videoins,$videoin"
fi


done


echo "[$videoins]"



