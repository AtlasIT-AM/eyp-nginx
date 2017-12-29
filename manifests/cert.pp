
define nginx::cert (
                      $pk_source           = undef,
                      $pk_file             = undef,
                      $cert_source         = undef,
                      $cert_file           = undef,
                      $intermediate_source = undef,
                      $certname            = $name,
                      $version             = '',
                    ) {

  include ::nginx

  if($pk_source==undef and $pk_file==undef)
  {
    fail('both pk_source and pk_file are undefined')
  }

  if($cert_source==undef and $cert_file==undef)
  {
    fail('both cert_source and cert_file are undefined')
  }

  if($pk_source!=undef)
  {
    file { "${nginx::params::ssl_dir}/${certname}_pk${version}.pk":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Class['nginx'],
      source  => $pk_source,
      notify  => Class['::nginx::service'],
    }
  }
  else
  {
    file { "${nginx::params::ssl_dir}/${certname}_pk${version}.pk":
      ensure => 'link',
      target => $pk_file,
      notify => Class['::nginx::service'],
    }
  }


  if($cert_source!=undef)
  {
    file { "${nginx::params::ssl_dir}/${certname}_cert${version}.cert":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => [ Package[$nginx::params::package], File[$nginx::params::ssl_dir] ],
      source  => $cert_source,
      notify  => Class['::nginx::service'],
    }
  }
  else
  {
    file { "${nginx::params::ssl_dir}/${certname}_cert${version}.cert":
      ensure => 'link',
      target => $cert_file,
      notify => Class['::nginx::service'],
    }
  }


  if($intermediate_source!=undef)
  {

    file { "${nginx::params::ssl_dir}/${certname}_intermediate${version}.cert":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => [ Package[$nginx::params::package], File[$nginx::params::ssl_dir] ],
      source  => $intermediate_source,
      notify  => Class['::nginx::service'],
    }
  }

}
