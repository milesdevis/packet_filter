#control forward_icmp

python ../../cli/pd_cli.py -p packet_filter -i p4_pd_rpc.packet_filter -s $PWD/tests/pd_thrift:$PWD/../../testutils -m "add_entry send_frame 1 rewrite_mac 00:aa:bb:00:00:00" -c localhost:22222

python ../../cli/pd_cli.py -p packet_filter -i p4_pd_rpc.packet_filter -s $PWD/tests/pd_thrift:$PWD/../../testutils -m "add_entry send_frame 2 rewrite_mac 00:aa:bb:00:00:01" -c localhost:22222

python ../../cli/pd_cli.py -p packet_filter -i p4_pd_rpc.packet_filter -s $PWD/tests/pd_thrift:$PWD/../../testutils -m "add_entry send_frame 3 rewrite_mac 00:aa:bb:00:00:02" -c localhost:22222

python ../../cli/pd_cli.py -p packet_filter -i p4_pd_rpc.packet_filter -s $PWD/tests/pd_thrift:$PWD/../../testutils -m "add_entry forward 10.0.0.10 set_dmac 00:04:00:00:00:00" -c localhost:22222

python ../../cli/pd_cli.py -p packet_filter -i p4_pd_rpc.packet_filter -s $PWD/tests/pd_thrift:$PWD/../../testutils -m "add_entry forward 10.0.1.3 set_dmac 00:04:00:00:00:02" -c localhost:22222

python ../../cli/pd_cli.py -p packet_filter -i p4_pd_rpc.packet_filter -s $PWD/tests/pd_thrift:$PWD/../../testutils -m "add_entry forward 10.0.1.2 set_dmac 00:04:00:00:00:01" -c localhost:22222


python ../../cli/pd_cli.py -p packet_filter -i p4_pd_rpc.packet_filter -s $PWD/tests/pd_thrift:$PWD/../../testutils -m "add_entry ipv4_lpm 10.0.0.10 32 set_nhop 10.0.0.10 1" -c localhost:22222

python ../../cli/pd_cli.py -p packet_filter -i p4_pd_rpc.packet_filter -s $PWD/tests/pd_thrift:$PWD/../../testutils -m "add_entry ipv4_lpm 10.0.1.2 32 set_nhop 10.0.1.2 2" -c localhost:22222

python ../../cli/pd_cli.py -p packet_filter -i p4_pd_rpc.packet_filter -s $PWD/tests/pd_thrift:$PWD/../../testutils -m "add_entry ipv4_lpm 10.0.1.3 32 set_nhop 10.0.1.3 3" -c localhost:22222

#control filter

python ../../cli/pd_cli.py -p packet_filter -i p4_pd_rpc.packet_filter -s $PWD/tests/pd_thrift:$PWD/../../testutils -m "add_entry ipv4_protocol_match 6 set_nhop 10.0.1.3 3" -c localhost:22222

python ../../cli/pd_cli.py -p packet_filter -i p4_pd_rpc.packet_filter -s $PWD/tests/pd_thrift:$PWD/../../testutils -m "add_entry ipv4_protocol_match 17 set_nhop 10.0.1.2 2" -c localhost:22222

