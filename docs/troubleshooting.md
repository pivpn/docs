title: Troubleshooting
summary: Debugging common problems with PiVPN

# Troubleshooting


## Preliminary checks

Before going any further, use the built in debug script to verify your PiVPN installation.

- Run `pivpn -d`.
- Confirm that all checks are [OK].

In our case:

```
$ pivpn -d
[...]
::::		Self check		 ::::
:: [OK] IP forwarding is enabled
:: [OK] Iptables MASQUERADE rule set
:: [OK] OpenVPN is running
:: [OK] OpenVPN is enabled (it will automatically start on reboot)
:: [OK] OpenVPN is listening on port 1194/udp
=============================================
[...]
```

If your debug log shows some [ERR], accept the [Y/n], run `pivpn -d` again and verify that all checks pass. If not, stop here and look up the error (if you get any) among existing issues or open a new issue.


## Connection Issues

***

- Verify that the server is running.
  - OpenVPN, restart the server with `sudo systemctl restart openvpn`, run `pivpn -d` and confirm that the snippet of the server log ends with `Initialization Sequence Completed`.
  - WireGuard, restart the server with `sudo systemctl restart wg-quick@wg0`. Run `lsmod | grep wireguard` and confirm that you get at least this output (numbers don't matter).

```
wireguard             225280  0
ip6_udp_tunnel         16384  1 wireguard
udp_tunnel             16384  1 wireguard
```

***

- Acquire the installation settings using `cat /etc/pivpn/wireguard/setupVars.conf` if using WireGuard or `cat /etc/pivpn/openvpn/setupVars.conf` if using OpenVPN.

```
[...]
IPv4dev=eth0                  <--- Network interface you have chosen

IPv4addr=192.168.23.211/24    <--- IP address of the Raspberry Pi at the time of installation
                                   (only consider the 192.168.23.211 part)

IPv4gw=192.168.23.1           <--- Gateway IP, which you will type into a web browser to open
                                   the management interface

pivpnPROTO=udp                <--- Protocol you need to use in the port forwarding entry

pivpnPORT=1194                <--- Port you need to forward

pivpnHOST=192.0.2.48          <--- Public IP or DNS name your clients will use to connect to
                                   the PiVPN
[...]
```

***

- Check that the current IP address of the interface `IPv4dev` is the same as `IPv4addr`. You can see the current IP with `ip -f inet address show IPv4dev`.

In our case:

```
$ ip -f inet address show eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    `inet 192.168.23.211/24 brd 192.168.23.255 scope global dynamic eth0
       valid_lft 84694sec preferred_lft 84694sec
```

Confirmed: `192.168.23.211` is the same as the content of the `IPv4addr` variable.

If it's not the same, go to your router admin webpage and reserve the static IP `IPv4addr` to the MAC address of the `IPv4dev` interface. To show the MAC address: `cat /sys/class/net/IPv4dev/address`. Then reboot the Raspberry Pi.

***

- Check that the current public IP of your connection is the same as `pivpnHOST`. To check the current public IP: `curl -s https://checkip.amazonaws.com`.

In our case:

```
$ curl -s https://checkip.amazonaws.com
192.0.2.48
```

Confirmed: `192.0.2.48` is the same as the content of the `pivpnHOST` variable.

If the IP is different, then update the IP using the [OpenVPN](openvpn.md#changing-the-public-ipdns) or [WireGuard](wireguard.md#changing-the-public-ipdns) guide. If your IP changes frequently, the norm on most home connections, consider using a [Dynamic DNS](faq.md#my-isp-doesnt-give-me-a-static-external-ip-address-and-my-server-ip-address-keeps-changing).

If you are already using a DDNS, and thus `pivpnHOST` contains your domain name, use `dig +short yourdomain.example.com` to check whether the returned IP matches `curl -s https://checkip.amazonaws.com`.

### Packet capture

We will use `tcpdump` to take a peek into the network interface to see if packets are reaching our Raspberry Pi.

First off, if you want to test the connection using your smartphone as a client, make sure to use MOBILE DATA, do not test from the same network where the Raspberry Pi is located. If you want to use a PC, connect to the internet via TETHERING/HOTSPOT.

Connecting from the same network as the server not only doesn't make sense (you are already inside the network the VPN is supposed to connect you to) but may not work with many routers.

From your device, go to https://ipleak.net and check what's your IP address, let's say we have 192.0.2.45.

1. Open a root shell: `sudo -s`
2. Install tcpdump: `apt install tcpdump -y`
3. Run `tcpdump -n -i IPv4dev pivpnPROTO port pivpnPORT` (it will block the terminal but don't worry)
4. Try to connect from your device
5. Shortly after you should see some packets being exchanged between your Raspberry Pi and your device

In our case:

```
# tcpdump -n -i eth0 udp port 1194
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
10:57:38.952503 IP 192.0.2.45.28050 > 192.168.23.211.1194: UDP, length 32    <--- Your device sent a packet to the Raspberry Pi
10:57:49.109202 IP 192.168.23.211.1194 > 192.0.2.45.28050: UDP, length 128   <--- Your Raspberry Pi responded to your device
10:57:49.144774 IP 192.0.2.45.28050 > 192.168.23.211.1194: UDP, length 128
10:57:59.490185 IP 192.168.23.211.1194 > 192.0.2.45.28050: UDP, length 32
```

You are looking at udp or tcp packets coming to your Raspberry Pi on the port you specified, via the network interface (ethernet or wifi) you chose. The example output above is a successful conversation.

Here's an unsuccessful one (no packets reach the Raspberry Pi):

```
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
```

6. Press CTRL-C to stop the capture
7. Exit the root shell: `exit`

### Tweaking MTU

On some networks, you may see that packets are being exchanged, data transfer occurs in both directions (Rx/Tx) as seen in the WireGuard app or `pivpn -c`, but can't browse the web or connect to servers in the LAN. This is sometimes caused by improper [MTU](https://en.wikipedia.org/wiki/Maximum_transmission_unit). To attempt a fix, start from the default MTU of 1420 and lower the value by 10 until you find the highest that works. The MTU can be changed by adding/editing the `MTU = something` line of the `[Interface]` section of the client `.conf` file, or by changing the MTU section in the WireGuard app on Android and iOS.

### What to do if I see no packets?

- If you set up PiVPN with ethernet and later switched to wifi, you will have a different IP. Easiest way to fix is to reinstall and pick the new network interface.
- Check if your ISP uses Carrier-grade NAT (check online). With CGNAT, your router gets a private IP, making port forwarding ineffective. This is mostly the norm if your router connects via 4G/LTE. If that's the case, you need to ask the ISP for a public IP.
- If you see packets coming, but no response from the Pi, it may indicate routing issues (such as NAT), attempts to block the connection (on either side), or poor connectivity. In all cases, try to connect from a different network.
- If you have multiple chained routers, then you need to configure multiple port forwardings. Example: `(192.0.2.48) ISP router (192.168.1.1)` ---> `(192.168.1.2) Own router (192.168.23.1)` ---> `(192.168.23.211) Raspberry Pi`. Given that, on the ISP router port forward 1194 udp to 192.168.1.2 and on your own router port forward 1194 UDP to 192.168.23.211.
- You may have misconfigured firewall rules on your Pi, open an issue and add the output of `sudo iptables -S` and `sudo iptables -t nat -S`.

If you performed all the following steps and suggestions, but you still can't connect, open a new issue showing all the steps you followed to troubleshoot. Include the packet capture as well (censor client IPs if you want). Remember to follow the ISSUE TEMPLATE.