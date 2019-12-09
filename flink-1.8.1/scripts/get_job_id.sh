#!/bin/sh
# Assumes there is just one job running, saves the flink job_id into mnt/job_id.txt
# NOTE -- this script is pretty fragile! If the output format of bin/flink list changes, this script will break.

$FLINK_HOME/bin/flink list > $FLINK_HOME/mnt/flink_list.txt
/usr/bin/awk '/RUNNING/ {print $4}' $FLINK_HOME/mnt/flink_list.txt > $FLINK_HOME/mnt/job_id.txt
export JOB_ID=`cat $FLINK_HOME/mnt/job_id.txt` # Example of how to load the value
echo "Found JOB_ID=$JOB_ID"