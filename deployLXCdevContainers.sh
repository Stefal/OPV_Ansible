#!/bin/bash

lxcExist=`command -v lxc`
sshKey=`cat ~/.ssh/id_rsa.pub`

poil1Name="master"
poil2Name="slave"

if ! [ -x "$lxcExistb"]
then
  echo "You must install lxc and lxd before using this script"
  exit 1
fi

if [ -z "$sshKey" ]
then
  echo "You must generate an ssh key before using this script"
  exit 1
fi

echo "Creating lxc container"
lxc launch ubuntu:16.04 $poil1Name
lxc launch ubuntu:16.04 $poil2Name

echo "Setup ssh"
lxc exec $poil1Name -- bash -c "echo $sshKey > ~/.ssh/authorized_keys"
lxc exec $poil2Name -- bash -c "echo $sshKey > ~/.ssh/authorized_keys"

ipPoil1=`lxc info $poil1Name | grep -P "eth0:\tinet\t" | awk '{print $3}'`
ipPoil2=`lxc info $poil2Name | grep -P "eth0:\tinet\t" | awk '{print $3}'`

ssh root@$ipPoil1 -o StrictHostKeyChecking=no exit
ssh root@$ipPoil2 -o StrictHostKeyChecking=no exit

echo "Installing python on lxc container"
lxc exec $poil1Name -- apt-get install python -y
lxc exec $poil2Name -- apt-get install python -y

echo "Finish !"
echo "You are now ready to use this container with ansible"
echo "Ip of $poil1Name : $ipPoil1 Ip of $poil2Name : $ipPoil2"
