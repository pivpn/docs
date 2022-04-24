title: Installation
summary: How to install
Authors: 4s3ti

# Installation

## Method 1
```Shell
curl -L https://install.pivpn.io | bash
```

## Method 2 (direct link)
```Shell
curl https://raw.githubusercontent.com/pivpn/pivpn/master/auto_install/install.sh | bash
```

## Method 3 (clone repo)
```Shell
git clone https://github.com/pivpn/pivpn.git
bash pivpn/auto_install/install.sh
```

## To install from Test/Development branch

`curl -L https://test.pivpn.io | TESTING= bash`


## Non-interactive installation

You can run the PiVPN installer from within scripts using the `--unattended` command line option provided with a .conf file. You can find examples [here](https://github.com/pivpn/pivpn/tree/master/examples).

```
curl -L https://install.pivpn.io > install.sh
chmod +x install.sh
./install.sh --unattended options.conf
```

It's not required to specify all options. If some of them are missing, they will be filled with defaults or generated at runtime if it can be done unambiguously. For example if you have just one network interface, such interface will be used but if you have more, the script will stop.

If not specified, `IPv4addr` and `IPv4gw` default to the current network settings, `pivpnHOST` to the public IP, `pivpnSEARCHDOMAIN` to empty. Rest of the default options are in the examples.

The options provided must make sense in relation to each other, for example you can't use `TWO_POINT_FOUR=1` with `pivpnENCRYPT=2048`.

## To install from custom git url and branch (for DEV)

This is inteded to be used when testing changes during
development and **not** for standard installations.
Without this the script will always checkout the master branch.

- Git repo can be pivpn or any other git repo (e.g. a fork).
- Git branch can be specified as required

#### Syntax

```shell
git clone < customgitrepourl >
bash pivpn/auto_install/install.sh --giturl < customgitrepourl > --gitbranch < customgitbranch >
```

#### Example
```shell
git clone https://github.com/userthatforked/pivpn.git
bash pivpn/auto_install/install.sh --giturl https://github.com/userthatforked/pivpn.git --gitbranch myfeaturebranch
```

The unattended setup config also supports a custom giturl and branch.

```shell
pivpnGitUrl="https://github.com/userthatforked/pivpn.git"
pivpnGitBranch="myfeaturebranch"
```

### Updating pivpn

VPN protocols are updated via system package manager

!!! note
    Read [Updating OpenVPN](openvpn.md#updating-openvpn) or [Updating Wireguard](wireguard.md#updating-wireguard) for information on how to update the VPN protocol.

## Uninstall

If at any point you wish to remove PiVPN from your Pi and revert it to a pre-installation state, such as if you want to undo a failed installation to try again or you want to remove PiVPN without installing a fresh Raspbian image, just run `pivpn uninstall`.
