require "spec_helper"

describe service("firewalld") do
  it { should be_enabled }
  it { should be_running }
end

require "spec_helper"

describe "fwrules rules" do
  describe command('sudo /usr/bin/firewall-cmd --list-all') do
    its(:stdout) { should match 'ssh' }
    its(:stdout) { should match 'http' }
    its(:stdout) { should match '3000' }
    its(:stdout) { should match '3443' }
    its(:stdout) { should match '5060/tcp' }
    its(:stdout) { should match '192.168.0.0' }
    its(:stdout) { should match '5060/udp' }
  end

  describe command('sudo /usr/bin/firewall-cmd --direct --get-all-rules') do
    its(:stdout) { should contain 'ipv4 mangle OUTPUT 1 -j DSCP --set-dscp-class CS2' }
    its(:stdout) { should contain 'ipv6 mangle OUTPUT 0 -j DSCP --set-dscp 0x14' }
  end
end
