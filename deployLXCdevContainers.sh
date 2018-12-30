#!/bin/bash

lxcExist=`command -v lxc`
sshKey=`cat ~/.ssh/id_rsa.pub`

poil1Name="master"
poil2Name="worker0"

if ! [ -x "$lxcExistb"]
then
  echo ------------------------------------
  echo "You must install lxc and lxd before using this script"
  echo ------------------------------------
  exit 1
fi

if [ -z "$sshKey" ]
then
  echo ------------------------------------
  echo "You must generate an ssh key before using this script"
  echo ------------------------------------
  exit 1
fi

echo ------------------------------------
echo "Creating lxc container"
lxc launch ubuntu:16.04 $poil1Name
lxc launch ubuntu:16.04 $poil2Name
echo Done

echo ------------------------------------
echo "Wait for container to start"
ipPoil1=`lxc info $poil1Name | grep -P "eth0:\tinet\t" | awk '{print $3}'`
ipPoil2=`lxc info $poil2Name | grep -P "eth0:\tinet\t" | awk '{print $3}'`

while [ -z $ipPoil1 ] || [ -z $ipPoil2 ]
do
	ipPoil1=`lxc info $poil1Name | grep -P "eth0:\tinet\t" | awk '{print $3}'`
	ipPoil2=`lxc info $poil2Name | grep -P "eth0:\tinet\t" | awk '{print $3}'`
done
echo Done

echo -----------------------------------
echo "Removing existing public key in ssh known_hosts"
ssh-keygen -f ~/.ssh/known_hosts -R $ipPoil1
ssh-keygen -f ~/.ssh/known_hosts -R $ipPoil2
echo Done

echo ------------------------------------
echo "Installing python on lxc container"
lxc exec $poil1Name -- apt-get update -y
lxc exec $poil2Name -- apt-get update -y
lxc exec $poil1Name -- apt-get install python -y
lxc exec $poil2Name -- apt-get install python -y
echo Done

echo ------------------------------------
echo "Setup ssh key"
lxc exec $poil1Name -- bash -c "echo $sshKey > /root/.ssh/authorized_keys"
lxc exec $poil2Name -- bash -c "echo $sshKey > ~/.ssh/authorized_keys"
echo Done


echo ------------------------------------
echo "Add container to ssh know host"
ssh root@$ipPoil1 -o StrictHostKeyChecking=no exit
ssh root@$ipPoil2 -o StrictHostKeyChecking=no exit
echo Done

echo ------------------------------------
echo "Add opv_master line in /etc/host"
lineOpvMaster=`cat /etc/hosts | grep opv_master -n | awk '{print $1}' FS=":"`

for i in $lineOpvMaster
do
  sudo sed -i "${i}s/.*/#&/" /etc/hosts
done

echo $ipPoil1 opv_master | sudo tee -a /etc/hosts
echo Done

echo ------------------------------------
echo "Make hosts file of ansible"

cat /dev/null > hosts
echo "[Master]" >> hosts
echo "$poil1Name ansible_host=$ipPoil1" >> hosts
echo "" >> hosts
echo "[Worker]" >> hosts
echo "$poil2Name ansible_host=$ipPoil2" >> hosts
echo Done

echo ------------------------------------
echo "Finish !"
echo "You are now ready to use this container with ansible"
echo "Ip of $poil1Name : $ipPoil1 Ip of $poil2Name : $ipPoil2"
echo ------------------------------------
