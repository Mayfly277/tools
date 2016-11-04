#!/bin/bash

##########################################################################
# Script to skip some tables of an sql dump
#
# usage :
#   -e exclude table
#   -o output file
# ./bdd_dump_skip_table.sh -e exclude_table -o dump_result.sql dump_file.sql
# (if multiple exclusion use multiple -e or edit this script)
# The dump original dump_file is not changed, the new dump is out by default
# on file out.sql if no output is definied
#
# author : Mayfly <https://github.com/Mayfly277>
#
##########################################################################

OUTPUT='out.sql'
EXCLUDE=()

# Add here your own exclusion if you need
# EXCLUDE+=(customer_.*)
# EXCLUDE+=(enterprise_customer_.*)
# EXCLUDE+=(enterprise_logging_.*)
# EXCLUDE+=(enterprise_sales_.*)
# EXCLUDE+=(enterprise_scheduled_.*)
# EXCLUDE+=(log_.*)
# EXCLUDE+=(sales_flat_.*)
# EXCLUDE+=(sales_invoiced_.*)
# EXCLUDE+=(sales_older_.*)
# EXCLUDE+=(sales_payment_.*)
# EXCLUDE+=(sales_recurring_.*)
# EXCLUDE+=(sales_refunded_.*)
# EXCLUDE+=(sales_shipping_.*)
# EXCLUDE+=(tax_.*)
# EXCLUDE+=(weee_.*)
# EXCLUDE+=(whishlist_.*)


# ORGANISE OPTIONS
OPTS=$(getopt -o e:o: -l exclude:,out: -- "$@")

if [ $? != 0 ]
then
    echo "Option Error terminating..." >&2 ;
    exit 1
fi

eval set -- $OPTS

# PARSE OPTIONS
while [ $# -gt 0 ]
do
    case $1 in
    -o|--out) OUTPUT=$2; shift; ;;
    -e|--exclude) EXCLUDE+=($2); shift; ;;
    (--) shift; break;;
    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
    (*) break;;
    esac
    shift
done

# PARSE SQL FILE ARG
SQL_FILE=$1
if [ -z "$SQL_FILE" ]; then
    echo "Missing argument File"
    exit 1
fi

echo 'Copy SQL file to output'
cp $SQL_FILE $OUTPUT

if [ ${#EXCLUDE[*]} -eq 0 ]
then
    echo 'No table to exclude exit'
    exit 0
fi

for exclude_table in ${EXCLUDE[*]}
do
    echo "Start excluding $exclude_table"
    sed -i "/\(DROP TABLE IF EXISTS\|INSERT INTO\) \`$exclude_table\`.*;/d" $OUTPUT
    sed -i "s/CREATE TABLE \`\($exclude_table\)\`/CREATE TABLE IF NOT EXISTS \`\1\`/" $OUTPUT
done

echo 'Finished'
exit 0

