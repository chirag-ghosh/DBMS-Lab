#!/bin/bash

#build jar file
mvn clean compile assembly:single

#run the jar file
java -jar target/hms-1-jar-with-dependencies.jar