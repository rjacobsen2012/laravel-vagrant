<?php

namespace Rjacobsen\Laravel\Vagrant\Providers;

use Illuminate\Support\ServiceProvider;

class VagrantLoadServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap services.
     *
     * @return void
     */
    public function boot()
    {
        $this->publishes([
            __DIR__.'/src/config/config.yaml.example' => base_path('vagrant/config/config.yaml'),
            __DIR__.'/src/config/db_setup.sql' => base_path('vagrant/config/db_setup.sql'),
            __DIR__.'/src/config/nginx_vhost' => base_path('vagrant/config/nginx_vhost'),
            __DIR__.'/src/scripts/' => base_path('vagrant/scripts/'),
            __DIR__.'/src/Vagrantfile' => base_path('Vagrantfile'),
        ]);
    }

    /**
     * Register services.
     *
     * @return void
     */
    public function register()
    {
        //
    }
}
