# envproxy
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include envproxy
class envproxy {
  case $::osfamily {
    'windows': {
      contain class { 'envproxy::windows': }
    }
    'RedHat': {
      contain class { 'envproxy::linux' : }
    }
    default: { fail ('Operating system not yet supported by this module.') }
  }
}
