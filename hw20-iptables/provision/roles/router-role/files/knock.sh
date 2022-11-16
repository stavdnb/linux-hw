#!/bin/bash
nmap -Pn --host-timeout 100 --max-retries 0 -p 8881 10.10.255.1
nmap -Pn --host-timeout 100 --max-retries 0 -p 7777 10.10.255.1
nmap -Pn --host-timeout 100 --max-retries 0 -p 9991 10.10.255.1
ssh -o StrictHostKeyChecking=no vagrant@10.10.255.1