#!/bin/bash


mysqlDomain=""
mysqlUser=""
mysqlPassword=""
mysqlDatabase=""

#function to determine if the IP entered follows the ipv4 format.
function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
	sleep 2
    fi
    return $stat
}

#Checks if subnet is valid
function valid_cidr()
{

	local stat=0
	if [ $1 -ge 1 -a $1 -le 257  ]; then
		
		stat=0	
	else
		echo "Invalid Subnet"
		stat=1
		sleep 2
	fi
	return $stat
}

# Input the domain details for nmap

if [ $# -eq 0 ]; then
    echo "Please specify the IP/Domain as an argument"
    sleep 2
    exit
fi

if [ "$1" != "" ]; then
    domain=$1
else
    echo "Please specify a proper IP/Domain"
    sleep 2
    exit
fi



# Checking for valid ip
echo 
echo "Checking for valid ip.."
sleep 2

ipaddrs=$(echo $domain | cut -d '/' -f1 )
cidr=$(echo $domain | cut -d '/' -f2 )

if valid_ip $ipaddrs
	then 
		echo "Ip Range is ok" ; 
		sleep 2
	else 
		echo "Ip Range is invalid"
		sleep 2

		exit ; 
fi

if valid_cidr $cidr
	then 
		echo "Subnet range is  ok" 
		sleep 2
	else 
		echo "Subnet range is invalid"
		sleep 2
		exit 
fi

echo "Creating Temporary Directory"
if [ ! -d "/tmp/nmap" ]; then
  mkdir /tmp/nmap
fi

#nmap details, outputs nmap to an xml file
nmap $domain -oG /tmp/nmap/currentScan.xml

#formating data( Converts xml to csv using nmaptocsv.py)
echo "Converting to CSV format"
sleep 2
cat /tmp/nmap/currentScan.xml | python nmaptocsv.py| tail -n +2 | tr ';' ','  >/tmp/nmap/tmp.txt

if [ $? -eq 0 ]; then
	echo "CSV converted"
else
	echo "Failed"
	exit
fi

echo "Formatting Data.. "	
sleep 2
awk -v d=$(date '+%Y-%m-%d') '{print d,$0}' OFS=, /tmp/nmap/tmp.txt > /tmp/nmap/data.txt
if [ $? -eq 0 ]; then
        echo "Formatting Completed"
else
        echo "Formatting Failed"
	sleep
        exit
fi

#inserting in mysql
echo "Inserting data to Mysql"
sleep 2

mysql -h$mysqlDomain  -PmysqlPort -u$mysqlUser  -p$mysqlPassword $mysqlDatabase --local-infile<<EOFMYSQL

LOAD DATA LOCAL INFILE '/tmp/nmap/data.txt' INTO TABLE NMAP_TAB FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' (SCAN_DATE,IPADDR,FQDN,PORT,PROTOCOL,SERVICE,VERSION_DTLS);

EOFMYSQL

echo "Data Insertion Completed"
sleep 2

#Do we want to keep these?
echo "Deleting Temporary files"
rm -rf /tmp/nmap

echo "Done"
echo






