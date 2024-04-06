title: Home
summary: Documentation homepage
Authors: 4s3ti

# Welcome to PiVPN Docs

[![Logos](img/pivpnbanner.png)](https://pivpn.io)

!!! WARNING

    PiVPN is no longer maintained! you can find more information about it [here](https://github.com/pivpn/pivpn/releases/tag/v4.6.0)

## How does PiVPN work?

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

---
## Feedback & Support

Our prefered contact method is through [Github Discussions page](https://github.com/pivpn/pivpn/discussions), please make sure you read the  [General Guidelines](https://github.com/pivpn/pivpn/blob/master/README.md#feedback--support) before opening any new issue or discussion. 

You can also reach out at: 

* \#pivpn at [libera.chat](https://libera.chat) IRC network
* \#pivpn:matrix.org at [matrix.org](https://matrix.org)
* Reddit at [r/pivpn](https://www.reddit.com/r/pivpn/)


---
## contributions

PiVPN is not taking donations but if you want to show your appreciation, then contribute or leave feedback on suggestions or improvements.

Contributions can come in all kinds of different ways! You don't need to be a developer to help out. 

* Please check the current [issues](https://github.com/pivpn/pivpn/issues) and [discussions](https://github.com/pivpn/pivpn/discussions). Maybe there is something you can help with
* [Documentation](https://github.com/pivpn/docs)! Documentation is never good enough! There is always something missing, or typos, or better English!
* Our [website](https://pivpn.io) is also Open Source. feel free to suggest any changes or improvements [here](https://github.com/pivpn/pivpn.io)
* Testing!! Run pivpn in different ways, different systems, different configurations! Let us know if you find something!
* Assisting other users in any of our official channels is also very welcomed

Still, if you consider PiVPN useful and want to Donate instead, then consider donating to:

1. [PiVPN Contributors](https://github.com/pivpn/pivpn/graphs/contributors)
2. [OpenVPNSetup](https://github.com/StarshipEngineer/OpenVPN-Setup)
3. [pi-hole.net](https://github.com/pi-hole/pi-hole)
4. [OpenVPN](https://openvpn.net)
5. [WireGuard](https://www.wireguard.com/)
6. [EFF](https://www.eff.org/)
