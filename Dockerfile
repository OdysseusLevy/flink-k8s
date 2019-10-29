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

FROM openjdk:8-jre-alpine

# Install requirements
RUN apk add --no-cache bash curl snappy libc6-compat

# Flink environment variables
ENV FLINK_HOME /opt/flink
ENV FLINK_DIST flink-1.8.1
ENV NUM_SLOTS 2


# Install build dependencies and flink
ADD $FLINK_DIST /opt/$FLINK_DIST
RUN set -x && \
  ln -s /opt/$FLINK_DIST $FLINK_HOME && \
  addgroup -S flink && adduser -D -S -H -G flink -h $ flink && \
  chown -R flink:flink /opt/$FLINK_DIST && \
  chown -h flink:flink $FLINK_HOME

COPY docker-entrypoint.sh /

USER flink
EXPOSE 8081 8090 6123
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["--help"]
