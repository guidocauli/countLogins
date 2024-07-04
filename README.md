# countLogins
## V1.04 by Guido Cauli

A bash (relatively simple) BASH script for counting logins in a system.
~~~
Usage: ./countlogins.sh -s -t -f -l -d  > filename.csv

     -s YYYY-MM     set a specific year-month start date
     -t YYYY-MM     set a specific year month end date
     -f             set the first UID for the search range
     -l             set the last UID for the search range
     -d             debug mode
~~~

It is preferable to redirect output into a CSV file in order to import data into any common spreadsheet.
