#!/bin/bash
apt update -y
apt install slurmd slurmctld -y
apt install munge libmunge2 libmunge-dev -y

sudo /usr/sbin/mungekey

sudo chown -R munge: /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/ /var/lib/munge/
sudo chmod 0755 /run/munge/
sudo chmod 0700 /etc/munge/munge.key
sudo chown -R munge: /etc/munge/munge.key
systemctl enable munge
systemctl restart munge

sudo apt install slurm-wlm
cp /local/repository/slurm.conf /etc/slurm/slurm.conf
echo "NodeName=node[0] CPUs=32 CoresPerSocket=8 ThreadsPerCore=2 State=UNKNOWN
NodeName=node[1-${1}] CPUs=32 CoresPerSocket=8 ThreadsPerCore=2 State=UNKNOWN
PartitionName=debug Nodes=ALL Default=YES MaxTime=INFINITE State=UP" | sudo tee -a /etc/slurm/slurm.conf

cp /local/repository/cgroup.conf /etc/slurm/cgroup.conf
sleep 1
systemctl enable slurmctld
systemctl restart slurmctld
sleep 1
systemctl enable slurmd
systemctl restart slurmd
