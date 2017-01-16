#!/bin/sh

# Update the package before installing the current packages
#sudo apt-get update
echo "apt-get update..."

echo "Started Installing packages..."
check="install"

echo "All packages info" > info.txt
echo " " >> info.txt
echo "   package                        status   " >> info.txt
echo "===========================================" >> info.txt

# install git package
p1=`dpkg --get-selections | grep git | head -n 1 | tail -c 8`
if [ "$p1" = "$check" ]
        then echo "git package is already installed"
        echo "    git                           install  " >> info.txt
else
        echo "git package installing..."
        sudo apt-get install git
        if [ $? -eq 0 ]
                then echo "git package - Successfully installed"
                echo "    git                           install  " >> info.txt

        else
                echo "Error in installing git package"
                echo "    git                           error    " >> info.txt

        fi
fi

#install hotspot package
p2=`dpkg --get-selections | grep hostapd | head -n 1 | tail -c 8`
if [ "$p2" = "$check" ]
        then echo "Hotspot package is already installed"
        echo "   hotspot                        install  " >> info.txt

else
	sudo git clone https://github.com/PNPtutorials/PNP_RPi3_AP
        sudo chmod +x PNP_RPi3_AP/install.sh
        sudo chmod +x PNP_RPi3_AP/ap.sh
        echo "installing hotspot package..."
        sudo PNP_RPi3_AP/./install.sh
 	if [ $? -eq 0 ]
                then sudo ap Rectosys password
                echo "hotspot package - Successfully installed"
                echo "   hotspot                        install  " >> info.txt

        else
                echo "Error in installing hotspot package"
	        echo "   hotspot                        error  " >> info.txt
		exit 1

        fi
fi

# install flask package
p3=`dpkg --get-selections | grep python-flask | head -n 1 | tail -c 8`
if [ "$p3" = "$check" ]
        then echo "flask package is already installed"
        echo " python-flask                     install  " >> info.txt

else
        echo "Installing flask package..."
        sudo apt-get install python-flask
        if [ $? -eq 0 ]
                then echo "flask package - Successfully installed"
	        echo " python-flask                     install  " >> info.txt

        else
                echo "Error in installing flask package"
                echo " python-flask                     error    " >> info.txt

        fi
fi

# install PIP package
p4=`dpkg --get-selections | grep python-pip | head -n 1 | tail -c 8`
if [ "$p4" = "$check" ]
        then echo "pip package is already installed"
        echo "  python-pip                      install  " >> info.txt

else
        echo "Installing pip package..."
        sudo apt-get install python-pip
        if [ $? -eq 0 ]
                then echo "pip package - Successfully installed"
	        echo "  python-pip                      install  " >> info.txt

        else
                echo "Error in installing pip package"
                echo "  python-pip                      error    " >> info.txt

        fi
fi

# install picamera package
p5=`dpkg --get-selections | grep python-picamera | head -n 1 | tail -c 8`
if [ "$p5" = "$check" ]
        then echo "picamera package is already installed"
        echo "python-picamera                   install  " >> info.txt

else
        echo "Installing picamera package..."
        sudo apt-get install python-picamera
        if [ $? -eq 0 ]
                then echo "picamera package - Successfully installed"
                echo "python-picamera                   install  " >> info.txt
        else
                echo "Error in installing picamera package"
                echo "python-picamera                   error    " >> info.txt

        fi
fi

# install flask for AutoIndex package
if [ -d /usr/local/lib/python2.7/dist-packages/Flask_AutoIndex-0.6-py2.7.egg ]
        then echo "Flask-AutoIndex package is already installed"
	echo "Flask-AutoIndex                   install  " >> info.txt
else
        echo "Installing Flask-AutoIndex package..."
        sudo pip install Flask-AutoIndex
        if [ $? -eq 0 ]
                then echo "Flask-AutoIndex package - Successfully installed"
		echo "Flask-AutoIndex                   install  " >> info.txt
        else
                echo "Error in installing picamera package"
		echo "Flask-AutoIndex                   error    " >> info.txt
        fi
fi

# install flask for fpdf package
if [ -d /usr/local/lib/python2.7/dist-packages/fpdf ]
        then echo "fpdf package is already installed"
	echo "    fpdf                          install  " >> info.txt
else
        echo "Installing fpdf package..."
        sudo pip install fpdf
        if [ $? -eq 0 ]
                then echo "fpdf package - Successfully installed"
		echo "    fpdf                          install  " >> info.txt
        else
                echo "Error in installing fpdf package"
		echo "    fpdf                          error    " >> info.txt
        fi
fi

# install MP4Box package
p6=`dpkg --get-selections | grep gpac | head -n 1 | tail -c 8`
if [ "$p6" = "$check" ]
        then echo "MP4Box package is already installed"
	echo "   MP4Box                         install  " >> info.txt
else
        echo "Installing MP4Box package..."
        sudo apt-get install gpac
        if [ $? -eq 0 ]
                then echo "MP4Box package - Successfully installed"
		echo "   MP4Box                         install  " >> info.txt
        else
                echo "Error in installing MP4Box package"
		echo "   MP4Box                         error    " >> info.txt
	fi
fi


#Editing a netwok-pre.conf file for reducing booting time upto 50%
Fpath=`sudo find /lib -name network-pre.conf`
echo "RST = $Fpath"
echo "[Service]" >> $Fpath
echo "TimeoutStartSec=10" >> $Fpath

#Download the python files
echo "checking if directory present"
if [ -d /mmr ]
	then echo "already Python files downloaded"
	echo "Python download                   Success" >> info.txt
else
	sudo git clone https://github.com/sharanu-g/mmr /mmr
	if [ $? -eq 0 ]
		then echo "downloaded Successfully"
		echo "Python download                   Success" >> info.txt
	else
		echo "Error in python file downloading"
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
sudo chmod 777 /etc/rc.local

#create folder
if [ -d /media/pi/internal ]
	then echo "already created"
else
	sudo mkdir /media/pi
	sudo mkdir /media/pi/internal
	sudo chmod 777 /media/pi/internal
	sudo mkdir /media/pi/external
	sudo chmod 777 /media/pi/external
fi
