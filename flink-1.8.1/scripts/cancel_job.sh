#!/bin/sh
# Assumes there is just one job running, save its state and then cancel it

$FLINK_HOME/scripts/get_job_id.sh
JOB_ID=`cat $FLINK_HOME/mnt/job_id.txt`
echo "Canceling job: $JOB_ID"
$FLINK_HOME/bin/flink cancel -s $FLINK_HOME/mnt/save $JOB_ID

