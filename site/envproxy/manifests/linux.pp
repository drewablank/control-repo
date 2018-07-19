# envproxy::linux
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include envproxy::linux
class envproxy::linux (
  $http_proxy  = $envproxy::params::http_proxy,
  $http_proxys = $envproxy::params::https_proxy,
  $no_proxy    = $envproxy::params::no_proxy,
  ) inherits envproxy::params {
  file { '/etc/profile.d/proxy.sh':
    ensure  => present,
    content => template('envproxy/linux.proxy.erb'),
  }
}
