#laravel-vagrant

Laravel Vagrant is a package to install a vagrant that can be used by laravel.

##What it gives you
- You can define the php version you wish to use in ``vagrant_config.yaml``
- Installs
  - `ubuntu/xenial64`
  - `redis`
  - `mailcatcher`
  - `mysql 5.7`
  - `nginx`
  - `postfix`
  - `git`
  - `xdebug`
  - `composer`
  - `zsh`
- Stops all outgoing mail from the vagrant, and catches it with `mailcatcher`


##Requirements
- virtualbox 5.2.22
- vagrant 2.2.2
- laravel 5.7

##Installation

1. run ``composer require rjacobsen/laravel-vagrant``
2. run ``php artisan vendor:publish``
3. add ``.vagrant`` to ``.gitignore``
4. add ``vagrant_config.yaml`` to ``.gitignore``
5. modify ``vagrant_config.yaml`` to your defined parameters
6. run ``vagrant up``

##Usage
- access your database at your selected ``vagrant_ip`` in your ``vagrant_config.yaml``
- set your host in ``/etc/hosts`` to point to the same ``vagrant_ip``
- access `mailcatcher` at your http://``vagrant_ip``:1080 (example: `http://10.0.0.110:1080`)