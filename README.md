PACKET FILTER:
 	
First clone this repo.

Then in a seperate location, install P4, clone the P4 repo and follow installation procedure from here : 

https://github.com/p4lang/p4factory

Then create support functionality for this switch: 
```
cd p4factory/tools 
./newtarget.py packet_filter
```
Then you should have a directory named "packet_filter" in the targets directory of the main folder.

Remove the contents "packet_filter" folder in targets and paste the contents of this repo over there.

Then cut the "pf_demo.py" file from here and go to p4factory/mininet/ and paste it there


Then, to build and run the packet filter:
```
cd targets/packet_filter
make bm
```
This should result in an executable in the same directory called "behavioral model"

Functionality:
		The packet filter has protocol dependent control behaviour. Specifically, it forwards ICMP packets based on IP destination but segregates TCP traffic and UDP traffic into their respective ports, irrespective of source or destination IP. It drops all other IP packets. Therefore, based on the ingressed packet, the control behaviour of the switch alternates between forwarding and filtering of IP packets. 

Functionality has been provided for IPV4 only, for the purposes of simplicity of demonstration.

To run the demo, do the following
```
./run_demo.bash
```
To install table entries, run the following in a different terminal,
```
./run_add_demo_entries.bash
```
ICMP Forwarding behaviour:

Now, in the mininet console go ahead and run pingall. h1 should be able to reach both h2 and h3. Both h2 and h3 should be able to reach h1, however, h2 should not be able to reach h3 and vice versa. Because in practise you wouldn't usually want traffic-segregated ports communicating with each other, its not intended for that purpose. 


TCP and UDP filtering:

In the mininet console go ahead and open up xterms for h1, h2 and h3. Then, start up wireshark on h2 and h3 to view  traffic flow. 

Then, from h1's xterm, to view the TCP filtering, generate TCP traffic using hping3 to an arbitrary destination. Specifically, do the following:
```
hping3 <valid IP address>     (Hping3 default option is TCP)
```
And you'd see the wireshark instance running on h3 capturing the traffic. (h3 corresponds to port 3 on the switch and all TCP traffic is diverted to port 3; Similarly h2 corresponds to port 2 on the switch and all UDP traffic is diverted to port 2)

*You would also be able to see ICMP errors flowing back to h1 from h2 or h3 (that depends on what traffic was generated, if the generated traffic was TCP, then h3 would reply with the ICMP error, if the generated traffic was UDP  then h2 would reply back with the ICMP error). This demonstrates the alternating forwarding and filtering behaviours of the switch.

Note that even if the destination IP provided for the traffic generation was one of the hosts h1, h2 or h3 the reply back from the destination wouldn't reach the source because of the protocol filtering behavior of the switch. You can try this out by making the destination IP one of the hosts. In Wireshark, you would see a reply from the host destination but the packet wouldn't reach the source because of the switch's behaviour.

Of course you would never be able to make TCP connections using this switch because the protocol filtering properties of the switch directly imply that TCP handshakes would never be able to complete . 

But a packet filter is meant to capture packets (a rudimentary Wireshark), not serve as a tool for communication and for that purpose, the switch functions nicely.

To convince yourself of the workings of the switch and get a better understanding of how the control behavior dynamically changes with the ingressed packet, I encourage you to experiment with traffic generation from h2 or h3 and then see the traffic flow.
