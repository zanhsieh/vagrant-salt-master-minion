# vagrant-salt-master-minion

This repo launches 3 VMs: 1 salt-master 2 salt-minion with Docker preinstalled, and with salt-minion Dockerfile. The purpose for this setup is to try to verify if salt-master is able to control salt-minion in both type VMs (provider VirtualBox and Docker) and how salt-master see / control salt-minion-in-docker within another 'physical' machine (VirtualBox).

This repo also includes code snippet on setting up private docker registry using official docker registry image. The code snippet also includes how to setup server CA, generate server key + CSR, sign with pre-gen server CA, and how to use it to launch SSL docker registry image.
