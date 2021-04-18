title: OpenVPN
summary: PiVPN/OpenVPN Specific information

# PiVPN OpenVPN

## List of commands

```
-a, add [nopass]     Create a client ovpn profile, optional nopass"
-c, clients          List any connected clients to the server"
-d, debug            Start a debugging session if having trouble"
-l, list             List all valid and revoked certificates"
-r, revoke           Revoke a client ovpn profile"
-h, help             Show this help dialog"
-u, uninstall        Uninstall PiVPN from your system!"
-up, update          Updates PiVPN Scripts"
-bk, backup          Backup Openvpn and ovpns dir"
```

### Creating new client certificate

`pivpn add`

You will be prompted to enter a name for your client. Pick anything you like and hit 'enter'.
You will be asked to enter a pass phrase for the client key; make sure it's one you'll remember.
The script will assemble the client .ovpn file and place it in the directory 'ovpns' within your
home directory.

If you need to create a client certificate that is not password protected (IE for use on a router),
then you can use the 'pivpn add nopass' option to generate that.

### Revoking a client certificatae

`pivpn revoke`

Asks you for the name of the client to revoke.  Once you revoke a client, it will no longer allow you to use
the given client certificate (ovpn config) to connect.  This is useful for many reasons but some ex:
You have a profile on a mobile phone and it was lost or stolen.  Revoke its cert and generate a new
one for your new phone.  Or even if you suspect that a cert may have been compromised in any way,
just revoke it and generate a new one.

### Listing clients

`pivpn list`

If you add more than a few clients, this gives you a nice list of their names and whether their certificate
is still valid or has been revoked.  Great way to keep track of what you did with 'pivpn add' and 'pivpn revoke'.

### Creating a server backup

`pivpn backup`

Creates a backup archive of your OpenVPN Settings and Client certificates, and places it on your pivpn user home directory

### Help with troubleshooting

`pivpn debug`

Outputs setup information needed when troubleshooting issues

## Importing client profiles

### Windows

Use a program like WinSCP or Cyberduck. Note that you may need administrator permission to move files to some folders on your Windows machine, so if you have trouble transferring the profile to a particular folder with your chosen file transfer program, try moving it to your desktop.

### Mac/Linux

Open the Terminal app and copy the config from the Raspberry Pi to a target directory on your local machine:

`scp pi-user@ip-of-your-raspberry:ovpns/whatever.ovpn path/to/target`.

### Android

You can either retrieve it on PC and then move it to your device via USB, or you can use an app like Turbo FTP & SFTP client to retrieve it directly from your Android device.

### iOS

You can use an app that supports SFTP like Documents by Readdle to retrieve it directly from your iOS device.

## Connecting to OpenVPN

### Windows

Download the [OpenVPN GUI](https://openvpn.net/community-downloads/), install it, and place the profile in the 'config' folder of your OpenVPN directory, i.e., in 'C:\Program Files\OpenVPN\config'. After importing, connect to the VPN server on Windows by running the OpenVPN GUI with administrator permissions, right-clicking on the icon in the system tray, and clicking 'Connect'.

### Linux

Install OpenVPN using your package manager (APT in this example). Now, as root user, create the /etc/openvpn/client folder and prevent anyone but root to enter it (you only need to do this the first time):
```
apt install openvpn
mkdir -p /etc/openvpn/client
chown root:root /etc/openvpn/client
chmod 700 /etc/openvpn/client
```
Move the config and connect (input the pass phrase if you set one):
```
mv whatever.ovpn /etc/openvpn/client/
openvpn /etc/openvpn/client/whatever.ovpn
```
Press CTRL-C to disconnect.

### Mac

You can use an OpenVPN client like [Tunnelblick](https://tunnelblick.net/downloads.html). Here's a [guide](https://tunnelblick.net/czUsing.html) to import the configuration.

### Android

Install the [OpenVPN Connect app](https://play.google.com/store/apps/details?id=net.openvpn.openvpn), select 'Import' from the drop-down menu in the upper right corner of the main screen, choose the directory on your device where you stored the .ovpn file, and select the file. Connect by selecting the profile under 'OpenVPN Profile' and pressing 'Connect'.

### iOS

Install the [OpenVPN Connect app](https://apps.apple.com/it/app/openvpn-connect/id590379981). Then go to the app where you copied the .ovpn file to, select the file, find an icon or button to 'Share' or 'Open with', and choose to open with the OpenVPN app.

## Pi-hole with PiVPN
You can safely install PiVPN on the same Raspberry Pi as your Pi-hole install, and point your VPN clients to the IP of your Pi-hole so they get ad blocking, etc. (replace `192.168.23.211` with the LAN IP of your Raspberry Pi).

Note that if you install PiVPN after Pi-hole, your existing Pi-hole installation will be detected and the script will ask if you want to use it as the DNS for the VPN, so you won't need to go through all these steps.

1. Edit the server config with `sudo nano /etc/openvpn/server.conf`
2. Remove every `push "dhcp-option DNS [...]"` line
3. Add this line `push "dhcp-option DNS 192.168.23.211"` to point clients to the PiVPN IP
4. Save the file and exit
5. Restart openvpn with `sudo systemctl restart openvpn`
6. Run `pihole -a -i local` to tell Pi-hole to listen on all interfaces

## Changing the public IP/DNS
You will need to change `/etc/openvpn/easy-rsa/pki/Default.txt` and your `.ovpn` files if you have already generated them.

## Blocking internet access

If you want clients to have access to your network but not route internet traffic through VPN, edit `/etc/openvpn/server.conf` and replace:

 `push "redirect-gateway def1"` with `push "route 192.168.23.0 255.255.255.0"`

 **OBS:** Replace `192.168.23.0` and `255.255.255.0` with the correct values for your network

 Restart the openvpn service: `sudo systemctl restart openvpn`.

## Migrating PiVPN & OpenVPN

Backup your server with `pivpn -bk`
copy the tar archive to your computer.
example using scp on linux:

`scp <user>@<server>:~/pivpnbackup/<archivename> <path/on/local>`

**Install OpenVPN on the new pi/server**

1. Backup the current install: `sudo cp -r /etc/openvpn /etc/openvpn_backup`  
2. Extract the backup archive: `tar xzpfv <archive name>`  
3. Copy the extracted content: `sudo cp -r etc/openvpn /etc`  
4. Restart the openvpn service: `sudo systemctl restart openvpn`

**OBS:** Please be aware of the difference between `/etc/` and `etc/`!  
/etc with the starting slash is a system directory  
etc/ without starting slash and tailing slash means its a directory in your current working dir.  

## Resolving local hostnames

All you have to do is to use your router as DNS Server instead of using other public DNS providers.
If you have already a working installation of OpenVPN, all you need to do is to edit `/etc/openvpn/server.conf` and replace every `push "dhcp-option DNS [...]"` line, with A SINGLE `push "dhcp-option DNS 192.168.23.1"` (assuming 192.168.23.1 is your gateway IP). Then restart the openvpn service: `sudo systemctl restart openvpn`.

Alternatively you can change `/etc/hosts` file and add `<IPAddress> <hostname>`
Example:
```
192.168.1.1   JohnDoeRouter
192.168.1.2   JohnDoePC
192.168.1.3   JaneDoePC
192.168.1.4   CatPC
192.168.1.5   DogPC
```
## Updating OpenVPN

**PC/Desktop only!!**

If you installed an earlier version of PiVPN and wish to update OpenVPN to a newer version just do the following steps:

```
sudo -s
wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg | apt-key add -
echo "deb http://build.openvpn.net/debian/openvpn/stable [osrelease] main" > /etc/apt/sources.list.d/openvpn-aptrepo.list
exit
```

Where [osrelease] should be replaced with:
- **stretch** (Debian 9.x)
- **buster** (Debian 10.x)
- **xenial** (Ubuntu 16.04)
- **bionic** (Ubuntu 18.04)

More information can be found here: <https://community.openvpn.net/openvpn/wiki/OpenvpnSoftwareRepos>

## Setting up static IP for clients

**If you installed PiVPN on or after Feb 17th 2020 static IPs are set by default.**

1. Add this line `client-config-dir /etc/openvpn/ccd` in `/etc/openvpn/server.conf`
2. Create client config directory: `sudo mkdir /etc/openvpn/ccd`
3. Fix permissions: `sudo chown -R openvpn:openvpn /etc/openvpn/ccd`
4. Adding clients: `sudo nano /etc/openvpn/ccd/exampleuser` (Add clients with their common name, in this case `exampleuser.ovpn`)
5. Configuring static IP: add this line `ifconfig-push 10.8.0.3 255.255.255.0` to `/etc/openvpn/ccd/exampleuser`
6. Restart openvpn with `sudo systemctl restart openvpn`

(Here 10.8.0.3 is going to be static IP for user `exampleuser`, if you want to configure additional users, repeat from step 4)

**Note: You have to assign static IP for all clients in order to avoid IP address conflict.**

## kicking a connected client

From issue [#577](https://github.com/pivpn/pivpn/issues/577)

1. Stop the server with `sudo systemctl openvpn stop`
2. Edit the server config with `sudo nano /etc/openvpn/server.conf`
3. Add this line`management 127.0.0.1 PORT` (replace PORT with a port number, like 1234)
3. Save the file and exit
5. Start the server with `sudo systemctl openvpn start`

To connect to the management interface, use `nc 127.0.0.1 PORT`, then disconnect a client with `kill CLIENTNAME`, use CTRL-C to exit.

More info [here](https://openvpn.net/community-resources/management-interface/). Consider also setting a password on the management interface as suggested on the [manual](https://community.openvpn.net/openvpn/wiki/Openvpn24ManPage).

## Connecting over mobile data

Trouble connecting over mobile data?  Try [this](https://github.com/pivpn/pivpn/issues/54)

## Trouble with Telekom Hybrid

If you have problems with the connections you can test the following:

Add `tun-mtu 1316` in `/etc/openvpn/easy-rsa/pki/Default.txt` to set a hybrid compatible MTU size (for newly created .ovpn files). For already existing .ovpn files `tun-mtu 1316` can also be inserted there manually. With Telekom hybrid connections, you may have to experiment a little with MTU (`tun-mtu`, `link-mtu` and `mssfix`).


## OpenVPN Technical Information

### Info on TLS

'Modern' OpenVPN (2.x, using the TLS mode) basically sets up two connections:

The 'control channel'. This is a low bandwidth channel, over which e.g. network parameters and key material for the 'data channel' is exchanged'. OpenVPN uses TLS to protect control channel packets.
The 'data channel'. This is the channel over which the actual VPN traffic is sent. This channel is keyed with key material exchanged over the control channel.
Both these channels are duplexed over a single TCP or UDP port.

--tls-cipher controls the cipher used by the control channel. --cipher together with --auth control the protection of the data channel.

And regarding security, OpenVPN uses encrypt-then-mac for its data channel, rather than mac-then-encrypt like TLS. All the CBC-related issues you hear about are due to the combination mac-then-encrypt + CBC. This means that AES-CBC for the data channel is perfectly fine from a security perspective.

(And there is no GCM support for the data channel yet. That will arrive in OpenVPN 2.4.)

If I wanted to specify ciphers, this is the list I'd use (I think):

```
TLS-ECDHE-RSA-WITH-AES-256-GCM-SHA384
TLS-ECDHE-ECDSA-WITH-AES-256-GCM-SHA384
TLS-ECDHE-RSA-WITH-AES-256-CBC-SHA384
TLS-ECDHE-ECDSA-WITH-AES-256-CBC-SHA384
TLS-DHE-RSA-WITH-AES-256-GCM-SHA384
TLS-DHE-RSA-WITH-AES-256-CBC-SHA256
TLS-DHE-RSA-WITH-AES-128-GCM-SHA256
TLS-DHE-RSA-WITH-AES-128-CBC-SHA256
```
