class MissingConfig < Vagrant::Errors::VagrantError
    error_key = "missing_config"
    error_message("You are missing the config file! Create a setup/config.yaml (copy from config.yaml.example)")
end

class MissingConfiguration < Vagrant::Errors::VagrantError
    def initialize(variable)
        error_key = "missing_configuration"
        error_message = "You are missing the config variable #{variable} in the config.yaml"
        StandardError.instance_method(:initialize).bind(self).call(error_message)
    end
end
