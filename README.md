
# laravel-vagrant  
  
Laravel Vagrant is a package to install a vagrant that can be used by laravel.  
  
## What it gives you   
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
  - `php 7.4`
- Stops all outgoing mail from the vagrant, and catches it with `mailcatcher`  
  
  
## Requirements  
- virtualbox 5.2.22  
- vagrant 2.2.2  
- laravel 5.1+  
  
## Installation  
  
1. run ``composer require rjacobsen/laravel-vagrant``  
2. run ``php artisan vendor:publish`` and select the number corresponding to ``VagrantLoadServiceProvider``  
3. add ``.vagrant`` to ``.gitignore``  
4. add ``config.yaml`` to ``.gitignore``  
5. modify ``config.yaml`` to your defined parameters  
6. run ``vagrant up``  
  
## Usage  
- access your database at your selected ``vagrant_ip`` in your ``config.yaml``  
- set your host in ``/etc/hosts`` to point to the same ``vagrant_ip``  
- access `mailcatcher` at your http://``vagrant_ip``:1080 (example: `http://10.0.0.110:1080`)