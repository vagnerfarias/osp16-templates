#!/usr/bin/env bash
if [ $PWD != $HOME ] ; then echo "USAGE: $0 Must be run from $HOME"; exit 1 ; fi

source ~/stackrc
cd ~

stack_name=predeployed

time openstack overcloud deploy --templates \
  --stack $stack_name \
  --disable-validations \
  --overcloud-ssh-user stack \
  --overcloud-ssh-key ~/.ssh/id_rsa \
  --log-file ~/templates/$stack_name/$stack_name-install.log \
  --stack-only \
  -n ~/templates/$stack_name/network_data.yaml \
  -r ~/templates/$stack_name/roles_data.yaml \
  -e $THT/environments/deployed-server-environment.yaml \
  -e $THT/environments/network-isolation.yaml \
  -e $THT/environments/network-environment.yaml \
  -e ~/templates/containers-prepare-parameter.yaml \
  -e ~/templates/$stack_name/ips-from-pool-all.yaml \
  -e ~/templates/$stack_name/ctlplane-assignments.yaml \
  -e ~/templates/$stack_name/site-environment.yaml


