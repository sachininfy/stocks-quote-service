#!/bin/bash
#  Copyright 2014 IBM
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

FROM codenvy/jdk8_maven3_tomcat8
MAINTAINER Sachin Junghare "sachin.junghare@infosys.com"

USER root

#Install the application
WORKDIR /stocks-service		
RUN git clone https://github.com/sachininfy/stocks-quote-service.git /stocks-service
RUN ls -ltr

# Prepare by downloading dependencies
ADD pom.xml /stocks-service/pom.xml  
RUN ["mvn", "dependency:resolve"]  
RUN ["mvn", "verify"]

# Adding source, compile and package into a fat jar
ADD src /stocks-service/src  
RUN ["mvn", "package"]

RUN ["rm", "-fr", "/usr/local/tomcat/webapps/*.war"]

COPY ./target/ /usr/local/tomcat/webapps/Stock*.war

#Define command to run the application when the container starts
EXPOSE 8080
CMD ["catalina.sh", "run"]