#!/bin/sh -e

# Update the package before installing the current packages
echo " "
echo "========================================= Welcome to the installation package ================================================="
echo " "
echo "Updating rasbian lite os..."
sudo apt-get update

echo "============================================Started Installing packages... ==================================================="
check="install"

echo "All packages info" > info.txt
echo " " >> info.txt
echo "   package                        status   " >> info.txt
echo "===========================================" >> info.txt

# installing packages 
# git, python-flask, python-pip and gpac(MP4box)
for i in git python-flask python-pip gpac; do
	p1=`dpkg --get-selections | grep $i | head -n 1 | tail -c 8`
	if [ $p1 = $check ]
		then echo $i " ================================> already installed"
		echo $i"                      install" >> info.txt
	else
		sudo apt-get -fy install $i
		if [ $? -eq 0 ]
			then echo "============================================" $i" Successfully installed =================================================="
			echo $i"                           install  " >> info.txt
		else
			echo  $i" ============================> error in installing"
			echo $i"                            error   " >> info.txt
		fi
	fi
done

# installing packages
# picamera, Flask-AutoIndex and fpdf
for j in picamera Flask-AutoIndex fpdf; do
	sudo pip install $j
	if [ $? -eq 0 ]
		then echo "========================================== " $j" Successfully installed ================================================="
		echo $j"                           install  " >> info.txt
	else
		echo  $j"==================================> error in installing"
		echo $j"                            error   " >> info.txt
	fi
done

#installing hotspot
p=`dpkg --get-selections | grep hostapd | head -n 1 | tail -c 8`
if [ $p = $check ]
	then echo "hostapd ==============================> already installed"
	echo " hostapd                             install" >> info.txt
else
	sudo git clone https://github.com/PNPtutorials/PNP_RPi3_AP
	if [ $? -eq 0 ]
		then echo "================================================== Hotspot Successfully downloaded ==========================================="
		echo " hostapd                     downloaded" >> info.txt
	else
		echo " hotspot ==============================> Error while downloading"
		echo " hostapd                      error download " >> info.txt
	fi
	sudo chmod +x PNP_RPi3_AP/install.sh
	sudo chmod +x PNP_RPi3_AP/ap.sh
	sudo cp PNP_RPi3_AP/install.sh install.sh
	sudo ./install.sh
fi

#Editing a netwok-pre.conf file for reducing booting time upto 50%
Fpath=`sudo find /lib -name network-pre.conf`
echo "RST = $Fpath"
echo "[Service]" >> $Fpath
echo "TimeoutStartSec=10" >> $Fpath

#Download the python files
echo "checking if directory present"
if [ -d /mmr ]
	then echo " ==================================== already Python files downloaded ==========================================="
	echo "Python download                   Success" >> info.txt
else
	sudo git clone https://github.com/sharanu-g/mmr /mmr
	if [ $? -eq 0 ]
		then echo "======================================= Python files downloaded Successfully ============================================="
		echo "Python download                   Success" >> info.txt
	else
		echo "============================================ Error while downloading python files ======================================="
		echo "python download                     fail" >> info.txt
		exit 1
	fi
fi

#giving path to the python script to run in backround
echo "#!/bin/sh -e" > /etc/rc.local
echo " " >> /etc/rc.local
echo "sudo ap rectosys password" >> /etc/rc.local
echo "sleep 5" >> /etc/rc.local
echo "sudo python /mmr/flask_final.py &" >> /etc/rc.local
echo "sudo python /mmr/memory.py &" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
sudo chmod +x /etc/rc.local

#create folder
if [ -d /media/pi/internal ]
	then echo " ============================= /media/pi/internal/ directory already created ================================="
	echo "================================= /media/pi/external/ directory already created ================================"
else
	sudo mkdir /media/pi
	sudo mkdir /media/pi/internal
	sudo chmod 777 /media/pi/internal
	sudo mkdir /media/pi/external
	sudo chmod 777 /media/pi/external
	echo "================================= /media/pi/internal created Successfully ====================================="
	echo "================================= /media/pi/external created Successfully ====================================="
fi
