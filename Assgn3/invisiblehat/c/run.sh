#!/bin/bash

echo -e "please install dependencies before running this\n\n"


gcc -o hms hms.c -I/usr/include/postgresql -lpq -std=c99
./hms
