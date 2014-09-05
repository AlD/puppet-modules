class apt-sources {
  exec { 'apt-get update':
    path => $path,
    refreshonly => true,
  }
  
  define list_line ($dist, $repo, $components) {
    file_line { "apt_sources.list_${dist}_${repo}":
      path => '/etc/apt/sources.list',
      line => template("${module_name}/sources.list.erb"),
      match => "^deb +.+${dist}/? +${repo}( .*)?$",
    }
  }

  define list ($dist = $title, $release = '', $repos = [], $components = []) {
    #workaround to have Exec resource available
    include apt-sources

    $defaults = {
      notify => Exec['apt-get update'],
    }
    create_resources(apt-sources::list_line, getrepos($dist, $release, $repos, $components), $defaults)
  }
}
