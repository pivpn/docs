title: Install Samba for easily downloading SSL cerficates
summary: How to install Samba on PiVPN so that you are able to download VPN certificates with SMB protocol
Authors: Dretech

# Easily download VPN certificates

Installation of VPN clients can be a lot easier when Samba is active and enabled to share the home directory of the user that is used with PiVPN. With a file explorer on your desktop computer you can easily go to de Wireguard or OpenVPN configuration files stored on your PiVPN server.

# Install Samba

You can install Samba with the following command:

sudo apt install samba

# Make Samba user

This user must have de same username as the user for which PiVPN is configured. With the following command you can make de Samba user:

sudo smbpasswd -a pivpnuser

Where pivpnuser is the username for which is PiVPN is configured.

# Make home directories of PiVPN computer browseable for Samba

Edit de smb.conf file (nano /etc/samba/smb.conf) Under section [homes] set the value to 'yes' after 'browseable ='

# Restart Samba server

With the following command the Samba software will restart en read the changed configuration:

sudo systemctl restart smbd

# Connect to the Samba share with your filebrowser

In Windows Explorer you type: \\ip-address-of-pi-vpn

With Linux computers you connect to a Windows share and enter the IP address of pi VPN

Double click on the 'homes' folder and enter your username and password. Now you can download your VPN certificates.
