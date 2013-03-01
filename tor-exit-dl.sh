#!/bin/bash

CMD=`basename $0`

show_help()
{
    echo "Usage: $CMD [COUNTRY_CODE [TOP_N]]"
}

if [ $# -ne 0 ] && [ $# -ne 1 ] && [ $# -ne 2 ]; then
    echo "fail! -- expect 0, 1 or 2 arguments! ==> $@"
    show_help
    exit 1
fi

COUNTRY_CODE=$1
TOP_N=$2

if [ "$COUNTRY_CODE" == "" ]; then
    COUNTRY_CODE=US
fi

# hard code Tor router CSV URL
URL=http://torstatus.blutmagie.de/query_export.php/Tor_query_EXPORT.csv

# hard code columns
ROUTER_COL=1
COUNTRY_COL=2
BANDWIDTH_COL=3
EXIT_COL=10

echo ""
echo "Extracting router list from.. ==> $URL"
EXIT_NODES=`curl $URL                                                 | # download Tor routers CSV using curl
        grep \,$COUNTRY_CODE\,                                        | # filter by country (default: US)
        sort -t "," -k$BANDWIDTH_COL -g -r                            | # sort by bandwidth column (order descending)
        cut -d"," -f$ROUTER_COL,$COUNTRY_COL,$BANDWIDTH_COL,$EXIT_COL | # include fields (preserve order)
        grep -v ".\+,.\+,.\+,0$"`                                       # exclude non-exits
if [ "$TOP_N" == "" ]; then
    TOP_N=`echo "$EXIT_NODES" | wc -l` # grab all routers if top-n not specified
fi
EXIT_NODES=`echo "$EXIT_NODES" | head -$TOP_N`

if [ "$EXIT_NODES" == "" ]; then
    echo ""
    echo "No routers matching search criteria found!"
    echo "You searched for COUNTRY_CODE=$COUNTRY_CODE, TOP_N=$TOP_N."
    exit 1
fi

echo ""
echo "Search results for COUNTRY_CODE=$COUNTRY_CODE, TOP_N=$TOP_N:"
echo "Format: [Router Name, Country Code, Bandwidth, Flag - Exit]"
echo "$EXIT_NODES"

ROUTER_NAMES=`echo "$EXIT_NODES" | cut -d"," -f1 | tr "\n" ,`

echo ""
echo "Only router names:"
echo "$ROUTER_NAMES"

echo ""
echo "To update Tor exit nodes:"
echo "1. sudo vi /etc/tor/torrc"
echo "2. Append router names to the line that begins with \"exitnodes\" in file \"torrc\""
echo "3. sudo /etc/init.d/tor restart"
