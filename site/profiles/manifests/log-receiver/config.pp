# == Class log-receiver::config
# =============================
#
#
# Description of the Class:
#
#   This class is meant to be called from init.pp only.
#
#
# ===========================
#
class log-receiver::config (
  $user               = $log-receiver::params::user,
  $group              = $log-receiver::params::group,
  $config_dir         = $log-receiver::params::config_dir,
  $ssl_dir            = $log-receiver::params::ssl_dir,
  $ssl_key            = $log-receiver::params::ssl_key,
  $ssl_cert           = $log-receiver::params::ssl_cert,
  $rabbit_key         = $log-receiver::params::rabbit_key,
  $rabbit_crt         = $log-receiver::params::rabbit_crt,
  $service            = $log-receiver::params::service,
  $rabbit_address     = $log-receiver::params::rabbit_address,
  $package_name       = $log-receiver::params::package_name
  ) inherits log-receiver::params {

  notify { "Creating config files for: ${package_name}": }

  $config_input       = "$config_dir/02_logstash-beats-input.conf"
  $config_output      = "$config_dir/31_logstash-mq-output.conf"
  $rabbitmq_cert      = "$ssl_dir/$rabbit_cert"
  $rabbitmq_key       = "$ssl_dir/$rabbit_key"
  $filebeat_cert      = "$ssl_dir/$ssl_cert"
  $filebeat_key       = "$ssl_dir/$ssl_key"

  file { $config_dir:
    ensure            => directory,
    owner             => $user,
    group             => $group,
    mode              => '0755'
  }

  file { $ssl_dir:
    ensure            => directory,
    owner             => $user,
    group             => $group,
    mode              => '0755'
  }

  file { $config_input: 
    ensure            => file,
    owner             => $user,
    group             => $group,
    mode              => '0644',
    content           => template('log-receiver/02_logstash-beats-input-conf.erb'),
    notify            => Service[$service]
  }

  file { $config_output: 
    ensure            => file,
    owner             => $user,
    group             => $group,
    mode              => '0644',
    content           => template('log-receiver/31_logstash-mq-output-conf.erb'),
    notify            => Service[$service]
  }

  file { "$ssl_dir/$ssl_key":
    ensure            => file,
    owner             => $user,
    group             => $group,
    mode              => '0644',
    content           => hiera('elk_stack_filebeat_key')
  }

  file { "$ssl_dir/$ssl_cert":
    ensure            => file,
    owner             => $user,
    group             => $group,
    mode              => '0644',
    content           => hiera('elk_stack_filebeat_cert')
  }

  file { "$ssl_dir/$rabbit_key":
    ensure            => file,
    owner             => $user,
    group             => $group,
    mode              => '0644',
    content           => hiera('elk_stack_rabbitmq_client_key')
  }

  file { "$ssl_dir/$rabbit_crt":
    ensure            => file,
    owner             => $user,
    group             => $group,
    mode              => '0644',
    content           => hiera('elk_stack_rabbitmq_client_cert')
  }

}


2# vim: set ts=2 sw=2 et :
