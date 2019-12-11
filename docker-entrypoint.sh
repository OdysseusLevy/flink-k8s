#!/bin/sh

################################################################################
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

### If unspecified, the hostname of the container is taken as the JobManager address
JOB_MANAGER_RPC_ADDRESS=${JOB_MANAGER_RPC_ADDRESS:-$(hostname -f)}
###

if [ "$1" == "--help" -o "$1" == "-h" ]; then
    echo "Usage: $(basename $0) (jobmanager|taskmanager)"
    exit 0
elif [ "$1" == "jobmanager" ]; then

    echo "Starting Job Manager"
    sed -i -e "s/jobmanager.rpc.address: localhost/jobmanager.rpc.address: ${JOB_MANAGER_RPC_ADDRESS}/g" $FLINK_HOME/conf/flink-conf.yaml

    if [ -f "$FLINK_HOME/mnt/start-job.sh" ]; then
      echo "Restarting existing JobManager"
      $FLINK_HOME/bin/jobmanager.sh start
      /bin/sleep 10
      echo "Starting installed flink job..."
      $FLINK_HOME/mnt/start-job.sh start
      echo "Tailing the logs"
      exec /usr/bin/tail -f $FLINK_HOME/log/*.log   # Note the "exec". We do this to force the container to not simply finish (which looks like an error to k8s)
                                                    # The tail outputs the flink logs to stdout to make k8s happy
    else
      echo "Could not find $FLINK_HOME/mnt/start-job.sh. The flink job will need to be started manually"
      exec $FLINK_HOME/bin/jobmanager.sh start-foreground
    fi

elif [ "$1" == "taskmanager" ]; then

    sed -i -e "s/jobmanager.rpc.address: localhost/jobmanager.rpc.address: ${JOB_MANAGER_RPC_ADDRESS}/g" $FLINK_HOME/conf/flink-conf.yaml
    sed -i -e "s/taskmanager.numberOfTaskSlots: 1/taskmanager.numberOfTaskSlots: ${NUM_SLOTS}/g" $FLINK_HOME/conf/flink-conf.yaml

    echo "Starting Task Manager"
    exec $FLINK_HOME/bin/taskmanager.sh start-foreground
else
  echo "This command needs an argument!"
  echo "Usage: $(basename $0) (jobmanager|taskmanager)"
  exit 1
fi

