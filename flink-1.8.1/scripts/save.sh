#!/bin/sh
# Assumes that there is just one job running. It saves this job's state to our mounted directory before cancelling

$FLINK_HOME/script/get_job_id.sh
JOB_ID=`cat $FLINK_HOME/mnt/job_id.txt`
$FLINK_HOME/bin/flink savepoint $JOB_ID $FLINK_HOME/mnt/save
