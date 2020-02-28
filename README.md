# Red Hat OpenStack Platform Templates

This repository contains a set of templates and scripts to deploy Red Hat OpenStack Platform for simple demonstrations or POCs.

There are two main set of templates:

- templates/fulldeploy - can be used to deploy an overcloud the usual way, in which the overcloud servers operating system image will be deployed by the OpenStack Director.
- templates/predeployed - can be used to deploy an overcloud on servers which had the operating system previously installed using whatever procedure is supported by Red Hat Enterprise Linux. On top of these "predeployed servers" OpenStack Director will install OpenStack components and configure the overcloud.


## How to use these templates

### Install the Red Hat OpenStack Director

On a Red Hat Enterprise Linux Server 8.1 system that will be used for OpenStack Director, clone this repository.

1. Create the stack user and enable repositories following [documentation instructions](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/16.0/html-single/director_installation_and_usage/index#preparing-the-undercloud).
2. Copy the "templates" directory from the cloned repository to /home/stack/templates.
3. Edit /home/stack/templates/containers-prepare-parameter.yaml to include your credentials at "ContainerImageRegistryCredentials". If you prefer, you may generate this file again, following [documentation instructions](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/16.0/html-single/director_installation_and_usage/index#container-image-preparation-parameters).
4. Copy undercloud/undercloud.conf from the cloned repository to /home/stack/undercloud.conf. It's configured to use network 192.0.2.0/24 on interface eth0. If you'd like to change this or other configurations, check the comments or [documentation](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/16.0/html-single/director_installation_and_usage/index#director-configuration-parameters).
5. Install the director, running "openstack undercloud install"

### Configure Overcloud Templates

Both set of templates have NIC configuration files (templates/.\*/nic-configs/) for servers with 2 network interfaces: first one is used only for provisioning and second one is used for isolating the remaining networks using VLANs. You'll likely have to modify these files to suit your environment.

The IP address range and the VLAN setting for each network is being configured solely on the corresponding network_data.yaml file, located at templates/.\*/network_data.yaml. Edit this file according to your environment.

Most configurations are on the templates/.\*/site-environment.yaml file. Check if there's anything you'd like to change.

These set of templates are configured to use Cinder LVM driver, which is only applicable for demonstrations or Proof of Concepts. Consult documentation to configure other storage backends.

#### Using "fulldeploy" Templates

For this set of templates, you have to [obtain images for the overcloud nodes](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/16.0/html-single/director_installation_and_usage/index#sect-Obtaining_Images_for_Overcloud_Nodes) and [register nodes for the overcloud](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/16.0/html-single/director_installation_and_usage/index#sect-Registering_Nodes_for_the_Overcloud-basic). An example file is available in baremetal/nodes-info.yaml.

After registering the nodes, you'll have to [inspect their hardware](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/16.0/html-single/director_installation_and_usage/index#inspecting-the-hardware-of-nodes-basic).

Copy the file scripts/deploy.sh to /home/stack. Run:

`$ ./deploy.sh`

#### Using "predeployed" Templates

For this set of templates, you'll have to install Red Hat Enterprise Linux Server 8.1 by yourself. A minimal installation will suffice.

Sample kickstart files are available in kickstart directory in the repository, which already create required user and upload public ssh keys.

Registering the servers to Red Hat Customer Portal will be required. The ansible playbook available in the ansible directory applies all the required configuration. Edit ansible/rhsm.conf to add your activation key settings ([create one](https://access.redhat.com/management/activation_keys) if you don't have it).

Edit the hosts file (inventory) as needed.

Run the playbook:

`$ ansible-playbook -i hosts setup-nodes.yaml`

For the "predeployed" scenario, you may need to edit the file templates/predeployed/ctlplane-assignments.yaml to reflect the IP addresses on the provisioning network for your servers.

Finally,copy the file scripts/predeployed-deploy.sh to /home/stack and when the servers are updated and back online, run:

`./predeployed-deploy.sh`

## Multiple Overclouds

The "predeployed" set of templates is configured in a way that you can deploy it by the same Director that deployed the "fulldeploy" stack. It's configured using the [Multiple Overclouds](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/16.0/html-single/director_installation_and_usage/index#deploying-multiple-overclouds) feature.

Main differences may be found at the files:

- network_data.yaml
- ips-from-pool-all.yaml
