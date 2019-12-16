# kamaji-flink

## Overview

Shows simple HA for flink using k8s and a pvc

## Changes from vanilla Flink

* Changed config to turn on prometheus, and copied prometheus library from opt to lib
* Prometheus port is set to 8090
* Added a scripts directory which contains scripts for things like safely cancelling the current job
* Added NUM_SLOTS environment variable that controls slots per task machine (this is configurable from k8s)
* Added Persistent Volume Claim (pvc) to mnt store for the flink jar and to store saves across restarts
* Added ServiceMonitor resource to turn on prometheus scraping
* Added Taskmanager service to distinguish between jobmanager and taskmanager pods
* Set blob.server.port to 6124 (default is random port and that doesn't work with the jobmanager service)
* Use default hadoop libraries
* Removed some docker compose complexity (we only use k8s)

## k8 scripts

The jenkins job is here:

https://one-jenkins.tools.kmb.sonynei.net/job/KMJ-CICD/job/kamaji-flink/job/one-jenkins/

Images are pushed here:

https://kamaji-dtr.tools.kmb.sonynei.net/repositories/raptor/kamaji-flink/tags

## How to build manually

First build the image

```docker build -t <image-name>:<image-version> .``` 

So for example:

```docker build -t kamaji-flink:0.0.5 .```

This creates the image and will assign a tag number. Take that tag number and then run the docker tag command

```docker tag <tag>  kamaji-dtr.tools.kmb.sonynei.net/<your-user-name>/kamaji-flink:0.0.5```

Finally push this up to our servers. The production user name is "raptor" but devs can't push directly to that so you 
need to first create the image name in your user account. Then push your local image up to the global server:

```docker push kamaji-dtr.tools.kmb.sonynei.net/<your-user-name>/kamaji-flink:0.0.5```

