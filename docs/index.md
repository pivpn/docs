title: Home
summary: Documentation homepage
Authors: 4s3ti

# Welcome to PiVPN Docs

![Logos](img/pivpnbanner.png)

## About

PiVPN is a set of shell scripts initially developed by **@0-kaladin** that serve to easily turn your Raspberry Pi (TM)
into a VPN server using two free, open-source protocols:
  * [WireGuard](https://www.wireguard.com/)
  * [OpenVPN](https://openvpn.net)

Have you been looking for a good guide or tutorial for setting up a VPN server on a Raspberry Pi or Ubuntu based server?  
Run this script and you don't need a guide or tutorial, this will do it all for you, in a fraction of the time and with hardened security settings in place by default.  

The master branch of this script installs and configures either WireGuard or OpenVPN (or both) on Raspbian, Debian or Ubuntu and it as been tested to run not only on Raspberry Pi but also in any Cloud Provider VPS.  
We recommend using the latest Raspbian Lite image on a Raspberry Pi in your home so you can VPN into your home from a unsecure remote locations and safely use the internet.  
However, the scripts do try to detect different distributions and make adjustments accordingly.  
They should work on the majority of Ubuntu and Debian based distributions including those using UFW by default instead of raw iptables.  

This script's primary mission in life is to allow a user to have a home VPN for as cost effective as possible and without being a technical wizard.  
Hence the design of PiVPN to work on a Raspberry Pi ($35) and then one command installer.  
Followed by easy management of the VPN thereafter with the 'pivpn' command.  
That being said...

> This will also work on a free-tier Amazon AWS server using Ubuntu or Debian.  I don't want to support every scenario there but getting it to run and install successfully on a free server in the cloud was also important.  
Many people have untrustworthy ISP's so running on a server elsewhere means you can connect to the VPN from home and your ISP will just see encrypted traffic as your traffic will now be leaving out the Amazon infrastructure.

## Prerequisites

To follow this guide and use the script to setup a VPN, you will need to have
a Raspberry Pi Model B or later with, an SD or microSD card with Raspbian installed,
a power adapter appropriate to the power needs of your model, and an ethernet cable or wifi
adapter to connect your Pi to your router or gateway.  
It is recommended that you use a fresh image of the latest Raspbian Lite from
the [Raspberry Pi's downloads page](https://raspberrypi.org/downloads), but if you don't, be sure to make a backup
image of your existing installation before proceeding.  
You should also setup your Pi with a static IP address
but it is not required as the script can do this for you.  
You will need to have your router forwarding UDP port 1194 or whatever custom
port you may have chose in the installer
(varies by model & manufacturer; consult your router manufacturer's documentation to do this).
Enabling SSH on your Pi is also highly recommended, so that you can run a very
compact headless server without a monitor or keyboard and be able to access it
even more conveniently.

## How it works

The script will first update your APT repositories, upgrade packages, and install WireGuard (default) or OpenVPN, which will take some time.

It will ask which authentication method you wish the guts of your server to use. If you go for WireGuard, you don't get to choose: you will use a Curve25519 public key, which provides 128-bit security. On the other end, if you prefer OpenVPN, default settings will generate ECDSA certificates, which are based on Elliptic Curves, allowing much smaller keys while providing an equivalent security level to traditional RSA (256 bit long, equivalent to 3072 bit RSA). You can also use 384-bit and 521-bit, even though they are quite overkill.

If you decide to customize settings, you will still be able to use RSA certificates if you need backward compatibility with older gear. You can choose between a 2048-bit, 3072-bit, or 4096-bit certificate. If you're unsure or don't have a convincing reason one way or the other I'd use 2048 today (provides 112-bit security).

From the OpenVPN site:

> For asymmetric keys, general wisdom is that 1024-bit keys are no longer sufficient to protect against well-equipped adversaries. Use of 2048-bit is a good minimum. It is wise to ensure all keys across your active PKI (including the CA root keypair) are using at least 2048-bit keys.

> Up to 4096-bit is accepted by nearly all RSA systems (including OpenVPN), but use of keys this large will dramatically increase generation time, TLS handshake delays, and CPU usage for TLS operations; the benefit beyond 2048-bit keys is small enough not to be of great use at the current time. It is often a larger benefit to consider lower validity times than more bits past 2048, but that is for you to decide.


After this, the script will go back to the command line as it builds the server's own certificate authority (OpenVPN only). The script will ask you if you'd like to change the default port, protocol, client's DNS server, etc. If you know you want to change these things, feel free, and the script will put all the information where it needs to go in the various config files.

If you aren't sure, it has been designed that you can simply hit 'Enter' through all the questions and have a working configuration at the end.

Finally, if you are using RSA, the script will take some time to build the server's Diffie-Hellman key exchange (OpenVPN only). If you chose 2048-bit encryption, it will take about 40 minutes on a Model B+, and several hours if you choose a larger size.

The script will also make some changes to your system to allow it to forward internet traffic and allow VPN connections through the Pi's firewall. When the script informs you that it has finished configuring PiVPN, it will ask if you want to reboot. I have it where you do not need to reboot when done but it also can't hurt.

After the installation is complete you can use the command `pivpn` to manage the server. Have a look at the [OpenVPN](https://github.com/pivpn/pivpn/wiki/OpenVPN) or [WireGuard](https://github.com/pivpn/pivpn/wiki/WireGuard) wiki for some example commands, connection instructions, FAQs, [troubleshooting steps](https://github.com/pivpn/pivpn/wiki/FAQ#how-do-i-troubleshoot-connection-issues).

## Feedback & Support

PiVPN is purely community driven, and we are interested in making this script work for as many people as possible, we welcome any feedback on your experience.
Please be respectful and be aware that this is maintained with our free time!

### General Guidelines

* Please check our documentation
* Please carefully read the [contributors' guide](https://github.com/pivpn/pivpn/blob/master/CONTRIBUTING.md)
* Please read the pinned posts on [Github Discussions](https://github.com/pivpn/pivpn/discussions)
* Please use Github [Github Discussions](https://github.com/pivpn/pivpn/discussions) instead of Issues
* Please provide as much information as you can
  * Fill the adequate template and provide all the requested data
  * If you can't find the adequate template, please ask first in any of our official channels
* The Github issues page is not intended for general support usage or feature requests
* PiVPN team may close any Discussion/Issue without any warning if they don't follow the Guidelines

### Official PiVPN Community support

If you have any questions or need any support, feel free to reach out at any of the following platforms

* [Github Discussions](https://github.com/pivpn/pivpn/discussions)
* Reddit at [r/pivpn](https://www.reddit.com/r/pivpn/)
* \#pivpn at [libera.chat](https://libera.chat) IRC network
* \#pivpn:matrix.org at [matrix.org](https://matrix.org)


### Feature requests

Feature requests are very welcome, please do so at:

* [Feature requests](https://github.com/pivpn/pivpn/discussions/categories/feature-requests)

### Bug reports

* [Open Github Issue](https://github.com/pivpn/pivpn/issues)

!!! Note
    Because it didn't work doesn't mean its a bug!
    please make sure you have read all the documentation and you have reached out through the official channels! before claiming a bug!

## contributions

PiVPN is not taking donations at this time but if you want to show your appreciation, then contribute or leave feedback on suggestions or improvements.

Contributions can come in all kinds of different ways and you don't need to be a developer to be able to help out, here are some ways you can help out:

* Please check the current [issues](https://github.com/pivpn/pivpn/issues) and [discussions](https://github.com/pivpn/pivpn/discussions)
to see where you can help.
* Help improving [documentation](https://github.com/pivpn/docs), either with new content or improving the existing writing.
* Testing!! Run pivpn in different ways, different systems, different configurations and let us know if you find something!
* Assisting other users in any of our official channels is also very welcomed


Still if you have found this tool to be useful and want to Donate instead, then consider the following sources.

1. [OpenVPNSetup](https://github.com/StarshipEngineer/OpenVPN-Setup)
2. [pi-hole.net](https://github.com/pi-hole/pi-hole)
3. [OpenVPN](https://openvpn.net)
4. [WireGuard](https://www.wireguard.com/)
5. [EFF](https://www.eff.org/)
