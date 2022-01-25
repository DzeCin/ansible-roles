Role Name
=========

Role to install docker on RedHat and Debian os families

Requirements
------------

Must use *become=true* in main.yaml

Role Variables
--------------

#### A list of users who will be added to the docker group.
docker_users: []

#### Docker daemon options as a dict
docker_daemon_options: {}


Dependencies
------------

None

Example Playbook
----------------

Usage: 

    - hosts: servers
      become: true
      roles:
         - docker

License
-------

BSD