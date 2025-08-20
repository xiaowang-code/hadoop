# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM apache/hadoop-runner
ARG HADOOP_URL=https://dlcdn.apache.org/hadoop/common/hadoop-3.4.1/hadoop-3.4.1.tar.gzWORKDIR /opt
RUN sudo rm -rf /opt/hadoop \
    && curl -LSs -o hadoop.tar.gz $HADOOP_URL \
    && tar zxf hadoop.tar.gz \
    && rm hadoop.tar.gz \
    && mv hadoop* hadoop \
    && rm -rf /opt/hadoop/share/doc

WORKDIR /opt/hadoop
# RUN mkdir -p /data/hadoop/dfs/name && \
#     sudo chown -R hadoop:hadoop /data/hadoop/dfs/name
ADD log4j.properties /opt/hadoop/etc/hadoop/log4j.properties
RUN sudo chown -R hadoop:users /opt/hadoop/etc/hadoop/*
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop