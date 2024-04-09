#!/bin/bash
## Installing the application and dependencies with userdata.
yum install ansible python3.11-pip.noarch -y | tee -a /opt/userdata.log
pip3.11 install botocore boto3 | tee -a /opt/userdata.log
ansible-pull -i localhost, -U https://github.com/Pavanbalubadi/expense-ansible expense.yml -e role_name=${role_name} -e env=${env} | tee -a /opt/userdata.log