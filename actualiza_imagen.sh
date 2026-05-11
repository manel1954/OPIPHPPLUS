#!/bin/bash
                        #sed -i '4cExec=sh -c '\''cd /home/pi/A108;sudo sh actualizar.sh'\''' /home/pi/.config/autostart/actualizar.desktop
                        git config --global --add safe.directory /home/pi/OPIPHPPLUS
                        cd /home/pi/OPIPHPPLUS                                             
                        git pull --force                      
                        sudo rm -R /home/pi/A108
                        mkdir /home/pi/A108                                                
                        cp -R /home/pi/OPIPHPPLUS/* /home/pi/A108
                        cp -R /home/pi/OPIPHPPLUS/html/ /var/www/
                        sleep 6                                             
                        sudo chmod 777 -R /home/pi/A108   
                        sudo chmod 777 -R /var/www/html
                         
                         