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
cp /local/repositoty/cgroup.conf /etc/slurm/cgroup.conf
systemctl enable slurmctld
systemctl restart slurmctld
systemctl enable slurmd
systemctl restart slurmd