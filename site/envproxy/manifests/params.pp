# envproxy::params
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include envproxy::params
class envproxy::params {
  $proxy_lookup = {
    name       => 'proxy_config',
    value_type => Hash,
    merge      => 'first',
  }

  $proxy_data = lookup($proxy_lookup)
  $protocol   = $proxy_data['protocol']
  $s_protocol = $proxy_data['s_protocol']
  $port       = $proxy_data['port']
  $s_port     = $proxy_data['s_port']
  $host       = $proxy_data['host']
  $proxyuser  = $proxy_data['user']
  $proxypass  = $proxy_data['pass']
  $no_proxy   = $proxy_data['no_proxy']

  case $host {
    #no host set:
    undef: {
      case $protocol {
        #no protocol set:
        undef: {
          case $s_protocol {
            #no secureprotocol set:
            undef: {
              case $port {
                #no port set
                undef: {
                  case $s_port {
                    #no secure port set:
                    undef: {
                      case $proxyuser {
                        #no proxy user set:
                        undef: {
                          case $proxypass {
                            #no proxy pass set:
                            undef: {
                              $http_proxy  = ''
                              $https_proxy = ''
                            }
                            #proxy pass set but nothing else
                            default: {
                              fail ('Proxy host, protocol, and user must be defined if proxy password is set in hiera')
                            }
                          }
                        }
                        #secure protocol set but nothing else
                        default: {
                          fail ('Proxy host and protocol must be defined if proxy user is set in hiera')
                        }
                      }
                    }
                    #secure port set but no host or protocol
                    default: {
                      fail ('Proxy host, protocol and secure protocol must be defined if proxy secure port is set in hiera')
                    }
                  }
                }
                #port set but no host or protocol
                default: {
                  fail ('Proxy host and protocol must be defined if proxy port is set in hiera')
                }
              }
            }
            #s_protocol is set:
            default: {
              fail ('Proxy host must be defined if proxy secure protocol is set in hiera')
            }
          }
        }
        #proxy port set:
        default: {
          fail ('Proxy host must be defined if proxy protocol is set in hiera')
        }
      }
    }
    #host is defined
    default: {
      case $protocol {
        #no protocol set:
        undef: {
          fail ('Proxy protocol must be set in hieradata')
        }
        #host and protocol is set
        default: {
          case $s_protocol {
            #no secure protocol set
            undef: {
              fail ('Proxy secure protocol must be set in hieradata')
            }
            #host, protocol, and secure protocol set
            default: {
              case $port {
                #optional port not set
                undef: {
                  case $s_port {
                    #optional secure port not set
                    undef: {
                      case $proxyuser {
                        #optional proxy user not set
                        undef: {
                          case $proxypass {
                            #optional pass not set, required if user exists
                            undef: {
                              $http_proxy  = "${protocol}://${host}"
                              $https_proxy = "${s_protocol}://${host}"
                            }
                            default: {
                              fail ('Proxy user must be set if password is set in hieradata')
                            }
                          }
                        }
                        #optional proxy user exists
                        default: {
                          case $proxypass {
                            #optional pass not set, required if user exists
                            undef: {
                              fail ('Proxy password must be set if user is set in hieradata')
                            }
                            #proxy user and password exists but no ports
                            default: {
                              $http_proxy  = "${protocol}://${proxyuser}:${proxypass}@${host}"
                              $https_proxy = "${s_protocol}://${proxyuser}:${proxypass}@${host}"
                            }
                          }
                        }
                      }
                    }
                    #secure port set and regular port is not set
                    default: {
                      case $proxyuser {
                        #optional proxy user not set
                        undef: {
                          case $proxypass {
                            #optional pass not set, required if user exists
                            undef: {
                              $http_proxy  = "${protocol}://${host}"
                              $https_proxy = "${s_protocol}://${host}:${s_port}"
                            }
                            default: {
                              fail ('Proxy user must be set if password is set in hieradata')
                            }
                          }
                        }
                        #optional proxy user exists
                        default: {
                          case $proxypass {
                            #optional pass not set, required if user exists
                            undef: {
                              fail ('Proxy password must be set if user is set in hieradata')
                            }
                            #proxy user and password exists but only secure port set
                            default: {
                              $http_proxy  = "${protocol}://${proxyuser}:${proxypass}@${host}"
                              $https_proxy = "${s_protocol}://${proxyuser}:${proxypass}@${host}:${s_port}"
                            }
                          }
                        }
                      }
                    }
                  }
                }
                #optional port set
                default: {
                  case $s_port {
                    #optional secure port not set
                    undef: {
                      case $proxyuser {
                        #optional proxy user not set
                        undef: {
                          case $proxypass {
                            #optional pass not set, required if user exists
                            undef: {
                              $http_proxy  = "${protocol}://${host}:${port}"
                              $https_proxy = "${s_protocol}://${host}"
                            }
                            default: {
                              fail ('Proxy user must be set if password is set in hieradata')
                            }
                          }
                        }
                        #optional proxy user exists
                        default: {
                          case $proxypass {
                            #optional pass not set, required if user exists
                            undef: {
                              fail ('Proxy password must be set if user is set in hieradata')
                            }
                            #proxy user and password exists but no secure port
                            default: {
                              $http_proxy  = "${protocol}://${proxyuser}:${proxypass}@${host}:${port}"
                              $https_proxy = "${s_protocol}://${proxyuser}:${proxypass}@${host}"
                            }
                          }
                        }
                      }
                    }
                    #secure port and regular port is set.
                    default: {
                      case $proxyuser {
                        #optional proxy user not set
                        undef: {
                          case $proxypass {
                            #optional pass not set, required if user exists
                            undef: {
                              $http_proxy  = "${protocol}://${host}:${port}"
                              $https_proxy = "${s_protocol}://${host}:${s_port}"
                            }
                            default: {
                              fail ('Proxy user must be set if password is set in hieradata')
                            }
                          }
                        }
                        #optional proxy user exists
                        default: {
                          case $proxypass {
                            #optional pass not set, required if user exists
                            undef: {
                              fail ('Proxy password must be set if user is set in hieradata')
                            }
                            #proxy user and password exists with ports
                            default: {
                              $http_proxy  = "${protocol}://${proxyuser}:${proxypass}@${host}:${port}"
                              $https_proxy = "${s_protocol}://${proxyuser}:${proxypass}@${host}:${s_port}"
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
