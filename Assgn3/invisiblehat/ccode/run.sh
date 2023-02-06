#!/bin/bash
gcc -o hms hms.c -I/usr/include/postgresql -lpq -std=c99
./hms
