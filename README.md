nmap to mysql


REQUIRES:

-Python

-nmaptocsv.py (https://github.com/maaaaz/nmaptocsv)

-mysql-server



USAGE:

./nmaptomysql 127.0.0.1/24

(IP + Subnet)


INFO:

This will run an xml nmap on the ip specified.
An xml nmap output will be placed in /tmp/nmap and then converted to csv using maaaaz's nmaptocsv python script. This will then be converted to a mysql insert statement and placed in the mysql database specified at the start of the script.


To automate for multiple IPs just make a loop xx.xx.$i.1/24

There is debug echos, but those can be commented out for more streamlined automation. 


To create the table
CREATE TABLE NMAP_TAB
( 
SRL_NO INT  NOT NULL  AUTO_INCREMENT, 
IPADDR  VARCHAR(16),
FQDN   VARCHAR(100) ,
PORT   VARCHAR(40) ,
PROTOCOL   VARCHAR(40) ,
SERVICE   VARCHAR(100) ,
VERSION_DTLS  VARCHAR(100) ,
SCAN_DATE   DATE,
PRIMARY KEY ( SRL_NO ));



