#!/usr/bin/python

from mininet.net import Mininet
from mininet.topo import Topo
from mininet.log import setLogLevel, info
from mininet.cli import CLI

from p4_mininet import P4Switch, P4Host

import argparse
from time import sleep

parser = argparse.ArgumentParser(description='Mininet demo')
parser.add_argument('--behavioral-exe', help='Path to behavioral executable',
                    type=str, action="store", required=True)
parser.add_argument('--thrift-port', help='Thrift server port for table updates',
                    type=int, action="store", default=22222)
parser.add_argument('--num-hosts', help='Number of hosts to connect to switch',
                    type=int, action="store", default=2)

args = parser.parse_args()


class SingleSwitchTopo(Topo):
    "Single switch connected to n (< 256) hosts."
    def __init__(self, sw_path, thrift_port, n, **opts):
        # Initialize topology
        Topo.__init__(self, **opts)

        switch = self.addSwitch('s1',
                                sw_path = sw_path,
                                thrift_port = thrift_port,
                                pcap_dump = True)
	h1 = self.addHost('h1', 
			ip = "10.0.0.10/24", 				mac='00:04:00:00:00:00')	
         

        
        for h in xrange(1,n+1):
            host = self.addHost('h%d' % (h + 1),
                                ip = "10.0.1.%d/24" % (h+1),
                      		mac = '00:04:00:00:00:%02x' %h)
	for h in xrange(0,n+1):	
            self.addLink('h%d' % (h+1), switch)

def main():
    num_hosts = args.num_hosts

    topo = SingleSwitchTopo(args.behavioral_exe,
                            args.thrift_port,
                            num_hosts
    )
    net = Mininet(topo = topo,
                  host = P4Host,
                  switch = P4Switch,
                  controller = None )
    net.start()


    sw_mac = ["00:aa:bb:00:00:%02x" % n for n in xrange(num_hosts+1)]

    sw_addr = ["10.0.%d.1" % n for n in xrange(num_hosts)]

    for n in xrange(num_hosts+1):
        h = net.get('h%d' % (n + 1))
	if (n>=1):
        	h.setARP(sw_addr[1], sw_mac[n])
        	h.setDefaultRoute("dev eth0 via %s" % sw_addr[1])
	else:	
		h.setARP(sw_addr[0], sw_mac[0])
		h.setDefaultRoute("dev eth0 via %s" % sw_addr[0])

    for n in xrange(num_hosts+1):
        h = net.get('h%d' % (n + 1))
        h.describe()

    sleep(1)

    print "Ready !"

    CLI( net )
    net.stop()

if __name__ == '__main__':
    setLogLevel( 'info' )
    main()
