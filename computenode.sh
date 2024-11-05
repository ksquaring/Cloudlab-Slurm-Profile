#!/bin/bash
apt update -y
apt install slurmd slurmctld -y
apt install munge libmunge2 libmunge-dev -y
ssh-keyscan -H node0 >> ~/.ssh/known_hosts #add key to known_hosts so scp works
sleep 1
echo "here"
scp -o StrictHostKeyChecking=no root@node0:/etc/munge/munge.key /etc/munge/munge.key
sleep 1
sudo chown -R munge: /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/ /var/lib/munge/
sudo chmod 0755 /run/munge/
sudo chmod 0700 /etc/munge/munge.key
sudo chown -R munge: /etc/munge/munge.key
systemctl enable munge
systemctl restart munge

sudo apt install slurm-wlm
cp /local/repository/slurm.conf /etc/slurm/slurm.conf
cp /local/repository/cgroup.conf /etc/slurm/cgroup.conf
sleep 1
systemctl enable slurmd
systemctl restart slurmd