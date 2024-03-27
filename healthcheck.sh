# usage: ./healthcheck.sh hostname
host=$1
echo "netcat $host:"
nc -w 5 -z $host 22
nc -w 5 -z $host 443

echo ""
ping -c10 $host

#echo ""
#traceroute -q 1 -m 32 $host
