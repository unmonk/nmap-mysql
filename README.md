nmap to mysql

REQUIRES:

Python
nmaptocsv.py (https://github.com/maaaaz/nmaptocsv)


USAGE:

./nmaptomysql 127.0.0.1/24
(IP + Subnet)


INFO:

This will run an xml nmap on the ip specified.
An xml nmap output will be placed in /tmp/nmap and then converted to csv using maaaaz's nmaptocsv python script. This will then be converted to a mysql insert statement and placed in the mysql database specified at the start of the script.


To automate for multiple IPs just make a loop xx.xx.$i.1/24

There is debug echos, but those can be commented out for more streamlined automation. 



