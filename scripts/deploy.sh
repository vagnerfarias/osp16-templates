#!/usr/bin/env bash
if [ $PWD != $HOME ] ; then echo "USAGE: $0 Must be run from $HOME"; exit 1 ; fi

source ~/stackrc
cd ~

stack_name=fulldeploy

time openstack overcloud deploy --templates \
  --stack $stack_name \
  -n ~/templates/$stack_name/network_data.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/network-environment.yaml \
  -e ~/templates/$stack_name/containers-prepare-parameter.yaml \
  -e ~/templates/$stack_name/ips-from-pool-all.yaml \
  -e ~/templates/$stack_name/node-info.yaml \
  -e ~/templates/$stack_name/site-environment.yaml

