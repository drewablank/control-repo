class profile::base {

  #the base profile should include component modules that will be on all nodes

  #Manage Node's ENV variables for PROXY
  class { 'envproxy' : }

}
