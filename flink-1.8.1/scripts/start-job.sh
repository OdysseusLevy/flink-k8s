#!/bin/sh
# Sample script to start up a job.
# Assumes variables JOB_JAR, NUM_SLOTS, and MAIN_CLASS are set. For example:
# JOB_JAR=$FLINK_HOME/mnt/osiris-events-0.0.62.jar
# MAIN_CLASS=com.sony.sie.kamaji.osiris.events.adlog.sbahnpublisher.AdLogSbahnPublisherMainKt
# NUM_SLOTS=4

SAVEPOINT=$(ls -td $FLINK_HOME/mnt/save/*/ | head -1)

if [-z $JOB_JAR]; then
  echo "No job jar found. Nothing to start. "
elif [-z $SAVEPOINT]; then
  echo "No savepoint found, starting fresh; jar: $JOB_JAR, main: $MAIN_CLASS, slots: $NUM_SLOTS"
  $FLINK_HOME/bin/flink run -d -c $MAIN_CLASS -p $NUM_SLOTS $JOB_JAR
else
  echo "Starting from save point: $SAVEPOINT; jar: $JOB_JAR, main: $MAIN_CLASS, slots: $NUM_SLOTS"
  $FLINK_HOME/bin/flink run -d -c $MAIN_CLASS -p $NUM_SLOTS $JOB_JAR -s $SAVEPOINT
fi