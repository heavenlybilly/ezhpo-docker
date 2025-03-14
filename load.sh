#!/bin/sh

# store start date to a variable
start=`date`

echo "Import started: OK"
dumpfile="./dump.sql"

ddl="set names utf8;"
ddl="$ddl set global net_buffer_length=1000000;"
ddl="$ddl set global max_allowed_packet=1000000000;"
ddl="$ddl SET foreign_key_checks = 0;"
ddl="$ddl SET UNIQUE_CHECKS = 0;"
ddl="$ddl SET AUTOCOMMIT = 0;"
# if your dump file does not create a database, select one
ddl="$ddl USE jetdb;"
ddl="$ddl source $dumpfile;"
ddl="$ddl SET foreign_key_checks = 1;"
ddl="$ddl SET UNIQUE_CHECKS = 1;"
ddl="$ddl SET AUTOCOMMIT = 1;"
ddl="$ddl COMMIT;"

echo "Import started: OK"

time mysql -u root -proot -e "$ddl"

# store end date to a variable
end=`date`

echo "Start import: $start"
echo "End import: $end"