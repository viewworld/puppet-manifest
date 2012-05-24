
class viewworld::webapp::docs($domain) {

  $src = "${webapp::python::src_root}/docs"

  nginx::site { 'docs':
    domain => $domain,
    root   => $src,
    owner => $viewworld::appserver::user,
    group => $viewworld::appserver::group,
  }

}
