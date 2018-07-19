# envproxy::windows
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include envproxy::windows
class envproxy::windows (
  $http_proxy  = $envproxy::params::http_proxy,
  $https_proxy = $envproxy::params::https_proxy,
  $no_proxy    = $envproxy::params::no_proxy,
  ) inherits envproxy::params {

  windows_env { 'http_proxy':
    ensure    => present,
    mergemode => clobber,
    variable  => 'http_proxy',
    value     => $http_proxy,
  }
  windows_env { 'https_proxy':
    ensure    => present,
    mergemode => clobber,
    variable  => 'https_proxy',
    value     => $https_proxy,
  }
  case $no_proxy {
    nil: {
      notify { 'The no_proxy value is NOT set for this node!' :
        withpath => true,
      }
    }
    default: {
      windows_env { 'no_proxy':
        ensure    => present,
        mergemode => clobber,
        variable  => 'no_proxy',
        value     => $no_proxy,
      }
    }
  }
}
