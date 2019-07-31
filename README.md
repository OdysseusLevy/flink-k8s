# kamaji-flink

## Overview

This is meant to be a base flink image that works for Kamaji

## Changes from vanilla Flink

* Configured to support prometheus reporting
* Added NUM_SLOTS environment variable that controls slots per task machine (this is configurable from k8s)
* Uses default hadoop libraries
* Removed docker compose complexity (we only use k8s)

## How to build

First build the image

```docker build -t <image-name>:<image-version>``` 

So for example:

```docker build -t kamaji-flink:0.0.4```

This creates the image and will assign a tag number. Take that tag number and then run the docker tag command

```docker tag <tag>  kamaji-dtr.tools.kmb.sonynei.net/<your-user-name>/kamaji-flink:0.0.1```

Finally push this up to our servers. The production user name is "raptor" but devs can't push directly to that so you 
need to first create the image name in your user account. Then push your local image up to the global server:

```docker push kamaji-dtr.tools.kmb.sonynei.net/<your-user-name>/kamaji-flink```

