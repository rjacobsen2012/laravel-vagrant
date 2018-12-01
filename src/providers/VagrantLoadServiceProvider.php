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
            __DIR__.'/../setup' => base_path('setup'),
            __DIR__.'/../setup/config/config.yaml.example' => base_path('vagrant_config.yaml'),
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
