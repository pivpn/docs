title: Cloud instance user data
summary: How to run the script on cloud instance user data
Authors: 4s3ti

# Cloud instance user data

PiVPN can be used to install OpenVPN or Wireguard completely unattended during a cloud instance boot (example AWS)

!!! Note
    This info is focused at more advanced users that wish to have their own VPN in the cloud or spin up VPN servers on demand with PiVPN.

      * You should be comfortable reading bash and understanding what the provided scripts below are doing.
      * You should know what a cloud instance is
      * You should know what user data is



Configuration file examples can be found here [here](https://github.com/pivpn/pivpn/tree/master/examples)

You can use the following script as an example and adjust the values to suit your needs

```
#!/bin/bash

# Create options file
cat << EOF > /tmp/options.conf
USING_UFW=0
IPv4dev=ens5
install_user=admin
install_home=/home/admin
VPN=openvpn
pivpnPROTO=udp
pivpnPORT=1194
pivpnDNS1=8.8.8.8
pivpnDNS2=8.8.4.4
TWO_POINT_FOUR=1
pivpnENCRYPT=256
USE_PREDEFINED_DH_PARAM=1
INPUT_CHAIN_EDITED=0
FORWARD_CHAIN_EDITED=0
pivpnDEV=tun0
pivpnNET=10.8.0.0
subnetClass=24
UNATTUPG=1
EOF

# Install git and clone pivpn repo
apt update && apt install -y git
git clone https://github.com/pivpn/pivpn /tmp/pivpn

# Install PiVPN from options.conf
cd /tmp/ || exit
bash pivpn/auto_install/install.sh --unattended /tmp/options.conf
```
