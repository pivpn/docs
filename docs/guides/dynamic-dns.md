title: Dynamic DNS with DuckDNS
summary: Setting up a dynamic dns so that your wireguard always connects.
Authors: chriscn

# Dynamic DNS
After running PiVPN for a while you may notice that you are unable to connect anymore. This may be due to your Public IP being changed. You then have a dilema, in order to connect to your VPN you need to known the IP; however you can't get that information unless you are on your internal network.  

The solution comes through [Dynamic DNS](https://en.wikipedia.org/wiki/Dynamic_DNS). Which will automatically update an A record on a specific domain name allowing you to always connect.

There are several DynamicDNS providers, some free some not. This tutorial will cover [DuckDNS](https://www.duckdns.org/) however the same principles can apply to other providers. 

## DuckDNS
1. Head to [DuckDNS](https://www.duckdns.org/) and Sign In with an account.
2. Head to [DuckDNS/Subdomains](https://www.duckdns.org/domains) and register a subdomain name. It can be whatever you like.
3. Head to [DuckDNS/Install](https://www.duckdns.org/install.jsp) and select **Linux CRON** and your domain name and follow the install instructions; you can run this on the same Raspberry Pi that you run PiVPN. You should end up with a file and cronjob running at `~/duckdns/duck.sh`
4. Once you've installed the script you need to change your configuration files and your setup variables.
    1. `configs` - Within each configuration file change the `Endpoint` line from your old ip to your new domain name. Most likely `[].duckdns.org`
    2. `setupVars` - Changing the values here will mean next time you create a client they'll have the new dynamic dns. 
        1. Change directory using `cd` to `/etc/pivpn/wireguard` and open the file `setupVars.conf` in your favourite text editor (you may need sudo), e.g. `sudo nano setupVars.conf`.
        2. Change the `pivpnHOST` value to your new domain name.
5. Enjoy. You now have a dynamic dns setup on your raspberry pi ensuring that you can always connect to your VPN.
