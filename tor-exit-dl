#!/bin/bash

CMD=`basename $0`

show_help()
{
    echo "Usage: $CMD <TOP_N> [COUNTRY_CODE={US}]"
}

if [ $# -ne 1 ] && [ $# -ne 2 ]; then
    echo "fail! -- expect 1 or 2 arguments! ==> $@"
    show_help
    exit 1
fi

TOP_N=$1
COUNTRY_CODE=$2

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
CACHED_ROUTERS="./cached_routers/`basename $URL`.`date +%Y-%m-%d`"
if [ ! -f $CACHED_ROUTERS ]; then
    echo "Downloading router list from.. ==> $URL"
    echo "Saving router list to.. ==> $CACHED_ROUTERS"
    mkdir -p `dirname $CACHED_ROUTERS`
    curl $URL > $CACHED_ROUTERS
else
    echo "Using cached router list from.. ==> $CACHED_ROUTERS"
fi
EXIT_NODES=`cat $CACHED_ROUTERS                                           | # download Tor routers CSV using curl
        grep \,$COUNTRY_CODE\,                                        | # filter by country (default: US)
        sort -t "," -k$BANDWIDTH_COL -g -r                            | # sort by bandwidth column (order descending)
        cut -d"," -f$ROUTER_COL,$COUNTRY_COL,$BANDWIDTH_COL,$EXIT_COL | # include fields (preserve order)
        grep -v ".\+,.\+,.\+,0$"                                      | # exclude non-exits
        head -$TOP_N`

if [ "$EXIT_NODES" == "" ]; then
    echo ""
    echo "No routers matching search criteria found!"
    echo "You searched for TOP_N=$TOP_N, COUNTRY_CODE=$COUNTRY_CODE."
    exit 1
fi

echo ""
echo "Search results for TOP_N=$TOP_N, COUNTRY_CODE=$COUNTRY_CODE:"
echo "Format: [Router Name, Country Code, Bandwidth, Flag - Exit]"
echo "$EXIT_NODES"

ROUTER_NAMES=`echo "$EXIT_NODES" | cut -d"," -f1 | tr "\n" ,`

echo ""
echo "New Exitnodes Line:"
echo "exitnodes $ROUTER_NAMES"

echo ""
echo "To update Tor exit nodes:"
echo "1. sudo vi /etc/tor/torrc"
echo "2. Append router names to the line that begins with \"exitnodes\" in file \"torrc\""
echo "3. sudo /etc/init.d/tor restart"
