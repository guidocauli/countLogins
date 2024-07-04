#!/bin/bash
# Count Logins in a system in a given timespan
# by Guido Cauli
# v 1.04 02/07/2024, dd/mm/yyyy

# **** START USER CONFIGURABLE PARAMETERS ****

# default User ID for searching from
STARTID=39300000
# default User ID for searching end
ENDID=39301999

# **** END USER CONFIGURABLE PARAMETERS ****

OPTIND=1;DEBUG=0;SINCEMONTH="";UNTILMONTH=`date -d "$(date +%Y%m01)+1month-1day" +%Y-%m-%d`;SEP=";";IFS=$'\n'
while getopts "h?ds:t:p:f:l:" opt; do
  case "$opt" in
    h|\?)
        echo -e "Login counter by Guido Cauli\n"
        echo -e "Usage: $0 -s -t -f -l -d  > filename.csv\n\n     -s YYYY-MM     set a specific year-month start date\n     -t YYYY-MM     set a specific year-month end date\n     -f             set the first UID for the search range\n     -l             set the last UID for the search range\n     -d             debug mode";exit 0;;
    d ) DEBUG=1;;
    s ) SINCEMONTH=$OPTARG"-01";;
    t ) UNTILMONTH=`date -d "$(date -d $OPTARG'-01' +%Y-%m-%d)+1month-1day" +%Y-%m-%d`;;
    f ) STARTID=$OPTARG;;
    l ) ENDID=$OPTARG;;
  esac
done
if [[ ! -z "$SINCEMONTH" ]]; then SINCEMONTH=" --since="$SINCEMONTH; fi
UNTILMONTH=" --until="$UNTILMONTH;user='';userFullName='';value=0
if [ "$DEBUG" -eq 1 ]
  then
   echo $SINCEMONTH
   echo $UNTILMONTH
   echo "Search from ID: " $STARTID
   echo "to ID: " $ENDID
fi
echo -e "\"login\"$SEP\"Name\"$SEP\"value\""
for userLine in `eval getent passwd {$STARTID..$ENDID}| awk 'BEGIN{FS=":"} {print $1,$5}'` 
do
  [ $DEBUG -eq 1 ] && echo $userLine
  user=`echo $userLine |cut -f 1 -d ' '`
  userFullName=`echo $userLine |cut -f 2- -d ' ' | sed -e "s/,//g"`
  value="last -R $user $SINCEMONTH $UNTILMONTH |grep $user |wc -l"; logins=`eval "$value"`
  echo -e \"$user\"$SEP\"$userFullName\"$SEP$logins
done
