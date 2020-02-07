# discovery-server

Role that setup a discovery server to be in use by a [Presto](https://prestodb.io) cluster.

> The solutions provided were designed for Proof of Concepts. Hence, are not to be treated as production ready, especially because of the lack of Security settings.

## Requirements

This role was created using [Ansible 2.9](https://docs.ansible.com/ansible/2.9/) for macOS and tested using the [centos/7](https://app.vagrantup.com/centos/boxes/7) boxes for [Vagrant v.2.2.6](https://www.vagrantup.com/docs/index.html) with [VirtualBox](https://www.virtualbox.org/) as a Provider.

The [Ansible modules](https://docs.ansible.com/ansible/2.9/modules/modules_by_category.html) used in the role are:

- [package](https://docs.ansible.com/ansible/latest/modules/package_module.html#package-module)
- [group](https://docs.ansible.com/ansible/2.9/modules/group_module.html#group-module)
- [user](https://docs.ansible.com/ansible/2.9/modules/user_module.html#user-module)
- [get_url](https://docs.ansible.com/ansible/2.9/modules/get_url_module.html#get_url-module)
- [unarchive](https://docs.ansible.com/ansible/2.9/modules/unarchive_module.html#unarchive-module)
- [file](https://docs.ansible.com/ansible/2.9/modules/file_module.html#file-module)
- [template](https://docs.ansible.com/ansible/2.9/modules/template_module.html#template-module)
- [meta](https://docs.ansible.com/ansible/2.9/modules/meta_module.html#meta_module.html)
- [service](https://docs.ansible.com/ansible/2.9/modules/service_module.html#service-module)

> We are using `systemd` to control the service.

## Role Variables

The next variables are set in [defaults](./defaults/main.yml) in order to be [easily overwrite](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable) and fetch a different version:

- `discovery_server_user`: to setup `username`, `group`, `uid` and `gid` for the user to run the service.
- `discovery_server_version`: version of the discovery server to be installed.
- `discovery_server_tarball_checksum`: if a different version is needed.

Some of the settings can also be tweaked using variables which also are in [defaults](./defaults/main.yml):

- `discovery_server_port`: port used to listen.
- `discovery_server_heap_size`: heap size to allocate to the service.
- `discovery_server_env`: name of the environment.

Other variables are available in [vars](vars/main.yml), usually don't need to be changed, unless we have a need to use a different mirror, for example.

## Dependencies

This role doesn't have any dependencies.

## Example Playbook

A working example using Vagrant and Virtual Box is setup under [tests](./tests/).
