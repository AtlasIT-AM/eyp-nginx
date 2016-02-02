define nginx::stubstatus (
                          $stubstatus_url='/nginx_status',
                          $servername=$name,
                        ) {

  concat::fragment{ "${nginx::params::sites_dir}/${servername} ${stubstatus_url} stubstatus":
    target  => "${nginx::params::sites_dir}/${servername}",
    order   => '09',
    content => template("${module_name}/vhost/stubstatus/stubstatus.erb"),
  }

}
