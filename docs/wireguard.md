title: Wireguard
summary: PiVPN/Wireguard Specific information

# PiVPN Wireguard

## List of commands

```
-a,  add              Create a client conf profile"
-c,  clients          List any connected clients to the server"
-d,  debug            Start a debugging session if having trouble"
-l,  list             List all clients"
-qr, qrcode           Show the qrcode of a client for use with the mobile app"
-r,  remove           Remove a client"
-h,  help             Show this help dialog"
-u,  uninstall        Uninstall pivpn from your system!"
-up, update           Updates PiVPN Scripts"
-bk, backup           Backup VPN configs and user profiles"
```

### Creating new client configuration

`pivpn add`

You will be prompted to enter a name for your client. Pick anything you like and hit 'enter'. The script will assemble the client .conf file and place it in the directory 'configs' within your home directory.

### Removing a client configuration

`pivpn remove`

Asks you for the name of the client to remove.  Once you remove a client, it will no longer allow you to use
the given client config (specifically its public key) to connect.  This is useful for many reasons but some ex:
You have a profile on a mobile phone and it was lost or stolen.  Remove its key and generate a new
one for your new phone.  Or even if you suspect that a key may have been compromised in any way,
just remove it and generate a new one.

### Listing clients

`pivpn list`

If you add more than a few clients, this gives you a nice list of their names and associated keys.

### Creating a server backup

`pivpn backup`

Creates a backup archive of your Wireguard Settings and Client certificates, and places it on your pivpn user home directory

### Help with troubleshooting

`pivpn debug`

Outputs setup information needed when troubleshooting issues


## Importing client profiles

### Windows

Use a program like WinSCP or Cyberduck. Note that you may need administrator permission to move files to some folders on your Windows machine, so if you have trouble transferring the profile to a particular folder with your chosen file transfer program, try moving it to your desktop.

### Mac/Linux

Open the Terminal app and copy the config from the Raspberry Pi to a target directory on your local machine:

`scp pi-user@ip-of-your-raspberry:configs/whatever.conf path/to/target`.

### Android / iOS

Just skip to [Connecting to Wireguard](wireguard.md#androidios) below.

## Connecting to Wireguard

### Windows/Mac

Download the [WireGuard GUI app](https://www.wireguard.com/install/), import the configuration and activate the tunnel.

### Linux

Install [WireGuard](https://www.wireguard.com/install/) following the instructions for your distribution. Now, as root user, create the /etc/wireguard folder and prevent anyone but root to enter it (you only need to do this the first time):
```
mkdir -p /etc/wireguard
chown root:root /etc/wireguard
chmod 700 /etc/wireguard
```
Move the config and activate the tunnel:
```
mv whatever.conf /etc/wireguard/
wg-quick up whatever
```
Run `wg-quick down whatever` to deactivate the tunnel.

### Android/iOS

Run `pivpn -qr` on the PiVPN server to generate a QR code of your config, download the Wireguard app [Android link](https://play.google.com/store/apps/details?id=com.wireguard.android) / [iOS link](https://apps.apple.com/it/app/wireguard/id1441195209), click the '+' sign and scan the QR code with your phone's camera. Flip the switch to activate the tunnel.

!!! note
    If you are having deformed or weirdly formatted qrcodes, please try using `pivpn -qr -a256` to generate a qrcode in ansi256, this will generate a substantially bigger qrcode but plays nicely when using other types of fonts on your terminal.



## Pi-hole with PiVPN

You can safely install PiVPN on the same Raspberry Pi as your Pi-hole install, and point your VPN clients to the IP of your Pi-hole so they get ad blocking, etc. (replace `192.168.23.211` with the LAN IP of your Raspberry Pi).

!!! note
    if you install PiVPN **after** Pi-hole, your existing Pi-hole installation will be detected and the script will ask if you want to use it as the DNS for the VPN, so you won't need to go through the following steps.

If you installed PiVPN **before** pi-hole:

1. Edit the PiVPN configuration with `/etc/pivpn/wireguard/setupVars.conf`
2. Remove the `pivpnDNS1=[...]` and `pivpnDNS2=[...]` lines
3. Add this line `pivpnDNS1=192.168.23.211` to point clients to the Pi-hole IP
4. Save the file and exit
5. Run `pihole -a -i local` to tell Pi-hole to listen on all interfaces

New clients you generate will use Pi-hole but you need to manually edit existing clients:

1. Open your configuration, for example whatever.conf
2. Replace the line `DNS = [...], [...]` with this line `DNS = 192.168.23.211`
4. Save the file and connect again


## Changing the public IP/DNS

1. Edit the PiVPN configuration with `sudo nano /etc/pivpn/wireguard/setupVars.conf`
2. Update the `pivpnHOST=[...]` line
3. Save and exit

New clients you generate will use the new endpoint but you need to manually edit existing clients:

1. Open your configuration, for example whatever.conf
2. Update the line `Endpoint = [...]:51820`
3. Save the file and connect again

## Blocking internet access

Replace the following line in your client configuration: `AllowedIPs = 0.0.0.0/0, ::0/0` with `AllowedIPs = <your-lan-ip/netmask>, <wireguard-ipv4/netmask>, <wireguard-ipv6/netmask>`.

- `your-lan-ip/netmask` might be something like `192.168.0.1/24` (check your network settings to confirm);
- `wireguard-ipv4/netmask` will likely be `10.19.17.0/24`; and 
- `wireguard-ipv6/netmask` will likely be `fd11:5ee:bad:c0de::/64`.

The final line might look like `AllowedIPs = 192.168.0.1/24, 10.19.17.0/24, fd11:5ee:bad:c0de::/64`.

If your PiVPN installation is older, it’s likely that Wireguard’s IPv4/netmask will be `10.6.0.0/24` instead. To confirm the exact values, check the `/etc/pivpn/wireguard/setupVars.conf` file, paying attention to the values of the `pivpnNET`, `subnetClass`, `pivpnNETv6` and `subnetClassv6` variables.

The client configuration files are located in `/etc/wireguard/configs` and are only readable by the `root` user. After altering the file, `pivpn -qr` will generate QR code containing the altered value of `AllowedIPs`.

To make PiVPN generate split-tunnels by default, alter the value of `ALLOWED_IPS` variable in `/etc/pivpn/wireguard/setupVars.conf` instead. All profiles generated after the change will be of a split-tunnel type.

## Migrating PiVPN & Wireguard

Backup your server with `pivpn -bk`
copy the tar archive to your computer.
example using scp on Linux:

`scp <user>@<server>:~/pivpnbackup/<archivename> <path/on/local>`

1. Backup the current (new instance) install: `sudo cp -r /etc/wireguard /etc/new_wireguard_backup`  
2. Extract the backup archive: `tar xzpfv <archive name>`  
3. Copy the extracted content: `sudo cp -r etc/wireguard /etc`  
4. Restart the wireguard service: `sudo systemctl restart wg-quick@wg0`  

!!! warning
    Please be aware of the difference between `/etc/` and `etc/`!!!

    `/etc` with the starting slash is a system directory

    `etc/` without starting slash and tailing slash means its a directory in your current working dir.  

## Resolving local hostnames


All you have to do is to use your router as DNS Server instead of using other public DNS providers.
If you have already a working installation of WireGuard, all you need to do is to edit your client config and change the line `DNS = [...], [...]` to `DNS = 192.168.23.1` (assuming 192.168.23.1 is your gateway IP).

Alternatively you can change `/etc/hosts` file and add `<IPAddress> <hostname>`
Example:
```
192.168.1.1   JohnDoeRouter
192.168.1.2   JohnDoePC
192.168.1.3   JaneDoePC
192.168.1.4   CatPC
192.168.1.5   DogPC
```

## Keep Wireguard connected / Connection issues / PersistentKeepalive

Per default Wireguard connects on-demand which is fine for most situations.
It's also the recommended configuration for mobile devices because of energy consumption.

But it might be useful to keep the Wireguard connection up to avoid certain connection
issues that can occur e.g. when NAT is being used which forces undesired disconnections.
Keeping the connection up can also reduce the reconnection time a bit, even though
Wireguard usually connects in under a second.

A good value of thumb for this setting is 25 seconds. You may also put a lower number if required. Setting it to 0 turns the feature off, which is the default. ([Wireguard Quickstart Guide](https://www.wireguard.com/quickstart/#nat-and-firewall-traversal-persistence))

The WireGuard client config file required the config parameter 
`PersistentKeepalive = 25` in the `[Peer]` section.

This setting will be added automatically to the client config profiles when added to 
the `/etc/pivpn/wireguard/setupVars.conf` file (`pivpnPERSISTENTKEEPALIVE=25`).

## Updating Wireguard

!!! note
    if you installed PiVPN on or after March 17th 2020 WireGuard will be upgraded via the package manager (APT)

Run `pivpn -wg` and follow the instructions.
