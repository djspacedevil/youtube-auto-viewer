#!/bin/bash
cd /home/pi/youtube_viewer
sudo pkill chromium
#https://www.sslproxies.org/
#https://peter.sh/experiments/chromium-command-line-switches/
#sudo apt-get install screen wmctrl
# Use Chromium with VPN Plugin, and auto User-Agent Switcher
PROXYLISTFILE='proxylist.txt'
YOUTUBEVIDEOLIST='youtubevideos.txt';
WINDOWSIZEFILE='viewportslist.txt'
LANGUAGELIST='languagelist.txt'
MINOPENTIME=30
MAXOPENTIME=$(( $MINOPENTIME + 550 ))
counter=0

loadvideo() {
	
	RANDOMVIDEO=$(shuf -n 1 $YOUTUBEVIDEOLIST)
	#RANDOMWAIT=$(shuf -i $MINOPENTIME-$MAXOPENTIME -n 1)
	RANDOMPLAYTIME=$(shuf -i 0-62 -n 1)
	echo "Play Video $counter Thread $1 $RANDOMVIDEO for $2sec over $4 with $3 with $5"
	if [ "$RANDOMPLAYTIME" -gt 37 ]; then
		screen -d -m -S ytviewer chromium-browser $5 --proxy-server="$4" --new-window "$3" "$RANDOMVIDEO&t=$RANDOMPLAYTIME"
	else
		screen -d -m -S ytviewer chromium-browser $5 --proxy-server="$4" --new-window "$3" "$RANDOMVIDEO"
	fi
	
	sleep $2
	echo "Close Thread $1 after $2sec $RANDOMVIDEO"
	wmctrl -c Chromium
}

while true
  do
		echo -n 'Kill running Chromium...'
		sudo pkill chromium
		sudo pkill chromium
		echo 'OK'
		
		echo -n 'New Turn on ' 
		date
		echo -n 'Clear Caches...'
		rm -f /home/pi/.config/chromium/Default/Cookies
		rm -rf /home/pi/.cache/chromium/Default/Cache/*
		rm -rf "rm -rf /home/pi/.cache/chromium/Default/Media\ Cache/*"
		sudo dphys-swapfile swapoff && sudo dphys-swapfile swapon 
		echo 'OK'
		RANDOWNPROXY=$(shuf -n 1 $PROXYLISTFILE)
		RANDOMVIEWSIZE=$(shuf -n 1 $WINDOWSIZEFILE)
		RANDOWMLANGUAGE=$(shuf -n 1 $LANGUAGELIST)
		
		if [ -z "$RANDOWNPROXY" ]; then
			RANDOWNPROXY='' 
		fi
		RANDOMWAIT1=$(shuf -i $MINOPENTIME-$MAXOPENTIME -n 1)
		RANDOMWAIT=$RANDOMWAIT1
		sleep 2
		counter=$((counter+1))
		loadvideo 1 $RANDOMWAIT1 $RANDOMVIEWSIZE $RANDOWNPROXY $RANDOWMLANGUAGE &
		
		RANDOMWAIT2=$(shuf -i $MINOPENTIME-$MAXOPENTIME -n 1)
		RANDOMWAIT=$(( $RANDOMWAIT > $RANDOMWAIT2 ? $RANDOMWAIT : $RANDOMWAIT2))
		sleep 1
		counter=$((counter+1))
		loadvideo 2 $RANDOMWAIT2 $RANDOMVIEWSIZE $RANDOWNPROXY $RANDOWMLANGUAGE &
		
		#RANDOMWAIT3=$(shuf -i $MINOPENTIME-$MAXOPENTIME -n 1)
		#RANDOMWAIT=$(( $RANDOMWAIT > $RANDOMWAIT3 ? $RANDOMWAIT : $RANDOMWAIT3))
		#sleep 1
		#counter=$((counter+1))
		#loadvideo 3 $RANDOMWAIT3 $RANDOMVIEWSIZE $RANDOWNPROXY $RANDOWMLANGUAGE &
		
		#RANDOMWAIT4=$(shuf -i $MINOPENTIME-$MAXOPENTIME -n 1)
		#RANDOMWAIT=$(( $RANDOMWAIT > $RANDOMWAIT4 ? $RANDOMWAIT : $RANDOMWAIT4))
		#sleep 1
		#counter=$((counter+1))
		#loadvideo 4 $RANDOMWAIT4 $RANDOMVIEWSIZE $RANDOWNPROXY $RANDOWMLANGUAGE &
		
		
		#Loop Ende 
		RANDOMWAIT=$(($RANDOMWAIT+2))
		sleep 0.5
		echo "Max Waittime $RANDOMWAIT"
		sleep $RANDOMWAIT
		sudo pkill chromium
	done
	
