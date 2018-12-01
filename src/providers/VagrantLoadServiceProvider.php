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
            __DIR__.'/../config/config.yaml.example' => base_path('vagrant_config.yaml'),
            __DIR__.'/../config/db_setup.sql' => base_path('vagrant/config/db_setup.sql'),
            __DIR__.'/../config/nginx_vhost' => base_path('vagrant/config/nginx_vhost'),
            __DIR__.'/../Vagrantfile' => base_path('Vagrantfile'),
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
