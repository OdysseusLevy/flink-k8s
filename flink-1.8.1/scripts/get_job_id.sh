#!/bin/sh
# Assumes there is just one job running, saves the flink job_id into mnt/job_id.txt

$FLINK_HOME/bin/flink list > $FLINK_HOME/mnt/flink_list.txt
/usr/bin/awk '/RUNNING/ {print $4}' $FLINK_HOME/mnt/flink_list.txt > $FLINK_HOME/mnt/job_id.txt
export JOB_ID=`cat $FLINK_HOME/mnt/job_id.txt`