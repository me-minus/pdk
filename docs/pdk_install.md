# Installing PDK

Before you install Puppet Development Kit (PDK), make sure you meet the system
and language version requirements.

By default, PDK installs to the following locations:

-   On *nix and macOS systems: `/opt/puppetlabs/pdk/`

-   On Windows systems: `C:\Program Files\Puppet Labs\DevelopmentKit`


PDK uses the latest versions of Puppet 7 and 8 available at the time of release.
Modules created with PDK work with all Puppet and Ruby version combinations currently under maintenance.
See [open source Puppet](https://puppet.com/docs/puppet/latest/about_agent.html) and
[Puppet Enterprise](https://www.puppet.com/docs/pe/2023.0/getting_support_for_pe.html#getting_support_for_pe) lifecycle pages for details.

PDK functions, such as creating classes, testing, and validation, are supported only on modules created or converted with PDK.

## Supported operating systems

PDK is compatible with *nix, Windows, and macOS systems. For detailed version compatibility, see the table below.

|Operating system|Versions|Arch|Package type|
|----------------|--------|----|------------|
|Debian|9, 10, 11|x86_64|DEB|
|Fedora|36|x86_64|RPM|
|OSX|11, 12|x86_64|DPKG|
|Red Hat Enterprise Linux (RHEL)|6, 7, 8, 9|x86_64|RPM|
|SUSE Linux Enterprise Server|12, 15|x86_64|N/A|
|Ubuntu|18.04, 20.04, 22.04|x86_64|DEB|
|Windows (Consumer OS)|10, 11|x86_64|MSI|
|Windows (Server OS)|2016, 2019, 2022|x86_64|MSI|

## Install PDK on Linux

On *nix systems, you can install PDK either from with the YUM or Apt package
managers.

By default, PDK installs to `/opt/puppetlabs/pdk/` .

### Install on RHEL, SLES, or Fedora

Install PDK with the YUM package manager.

1.  Download and install the software and its dependencies. Use the commands
    appropriate to your system.

    -   RHEL 6

        ```
        sudo rpm -Uvh https://yum.puppet.com/puppet-tools-release-el-6.noarch.rpm
        sudo yum install pdk
        ```

    -   RHEL 7

        ```
        sudo rpm -Uvh https://yum.puppet.com/puppet-tools-release-el-7.noarch.rpm
        sudo yum install pdk
        ```

    -   RHEL 8

        ```
        sudo rpm -Uvh https://yum.puppet.com/puppet-tools-release-el-8.noarch.rpm
        sudo yum install pdk
        ```

    -   RHEL 9

        ```
        sudo rpm -Uvh https://yum.puppet.com/puppet-tools-release-el-9.noarch.rpm
        sudo yum install pdk
        ```

    -   SUSE Linux Enterprise Server 15

        ```
        sudo rpm -Uvh https://yum.puppet.com/puppet-tools-release-sles-15.noarch.rpm
        sudo zypper install pdk
        ```

    -   Fedora 36

        ```
        sudo rpm -Uvh https://yum.puppet.com/puppet-tools-release-fedora-36.noarch.rpm
        sudo dnf install pdk
        ```

2.  Open a terminal to re-source your shell profile and make PDK available to your PATH.


#### What to do next:

To upgrade your PDK installation to the most recent release, run

```
sudo yum upgrade pdk
```

### Install on Debian or Ubuntu

Install PDK with the Apt package manager.

1.  Download and install the software and its dependencies. Use the commands
    appropriate to your system.

    -   Debian 9

        ```
        wget https://apt.puppet.com/puppet-tools-release-stretch.deb
        sudo dpkg -i puppet-tools-release-stretch.deb
        sudo apt-get update
        sudo apt-get install pdk
        ```

    -   Debian 10

        ```
        wget https://apt.puppet.com/puppet-tools-release-buster.deb
        sudo dpkg -i puppet-tools-release-buster.deb
        sudo apt-get update
        sudo apt-get install pdk
        ```

    -   Debian 11

        ```
        wget https://apt.puppet.com/puppet-tools-release-bullseye.deb
        sudo dpkg -i puppet-tools-release-bullseye.deb
        sudo apt-get update
        sudo apt-get install pdk
        ```

    -   Ubuntu 18.04

        ```
        wget https://apt.puppet.com/puppet-tools-release-bionic.deb
        sudo dpkg -i puppet-tools-release-bionic.deb
        sudo apt-get update
        sudo apt-get install pdk
        ```

    -   Ubuntu 20.04

        ```
        wget https://apt.puppet.com/puppet-tools-release-focal.deb
        sudo dpkg -i puppet-tools-release-focal.deb
        sudo apt-get update
        sudo apt-get install pdk
        ```

    -   Ubuntu 22.04

        ```
        wget https://apt.puppet.com/puppet-tools-release-jammy.deb
        sudo dpkg -i puppet-tools-release-jammy.deb
        sudo apt-get update
        sudo apt-get install pdk
        ```


2.  Open a terminal to re-source your shell profile and make PDK available to
    your PATH.


#### What to do next:

To upgrade your PDK installation to the most recent release, run:

```
sudo apt-get update
sudo apt-get install pdk
```

## Install PDK on macOS

To install PDK on macOS, download and install the package or install with
Homebrew.

By default, PDK installs to `/opt/puppetlabs/pdk/`.

### Install with Homebrew

Install and upgrade PDK with Homebrew, a package manager for macOS.

> **Before you begin**
> You must have Homebrew installed. See the [Homebrew](https://brew.sh/) page for
download and installation information.

If you've already installed PDK with the main Homebrew cask, see the topic about
migrating your PDK installation to the Puppet Homebrew cask.

1.  Install PDK by running `brew install --cask puppetlabs/puppet/pdk`

2.  Open a terminal to re-source your shell profile and make PDK available to
    your PATH.


#### What to do next:

To update PDK to the most recent release, run `brew upgrade --cask pdk`

### Migrate PDK installation to the Puppet Homebrew cask

If you previously installed PDK with the main Homebrew cask instead of the
Puppet cask, migrate your PDK installation to the Puppet cask.

> **Before you begin**
> If this is the first time you are installing PDK with Homebrew, see the topic
about installing PDK with Homebrew.

1.  Update Homebrew by running `brew update`

2.  Add the Puppet cask by running `brew tap puppetlabs/puppet`


#### What to do next:

To update PDK to the most recent release, run `brew upgrade --cask pdk`

### Download and install the package

Download and install the package for macOS systems.

1.  Download the package for your operating system from the PDK
    [download](https://puppet.com/download-puppet-development-kit) site.

2.  Double click on the downloaded package to install.

3.  Open a terminal to re-source your shell profile and make PDK available to
    your PATH.


## Install PDK on Windows

Download and install the PDK package for Windows systems, or install with
Chocolatey, a package manager for Windows.

By default, PDK installs into `C:\Program Files\Puppet Labs\DevelopmentKit`

### Install with Chocolatey

Install and upgrade PDK with Chocolatey, a package manager for Windows.

> **Before you begin**
> To install and upgrade PDK with the Chocolatey package manager for Windows, you
must have Chocolatey installed. See the [Chocolatey
documentation](https://chocolatey.org/docs/installation) for installation
instructions.

1.  Install PDK by running `choco install pdk`

2.  Open a new PowerShell window to re-source your profile and make PDK
    available to your PATH.

#### What to do next:

To upgrade PDK to the most recent release, run `choco upgrade pdk`

### Download and install the package

Download and install the PDK package for Windows systems.

1.  Download the package for your operating system from the PDK
    [download](https://puppet.com/download-puppet-development-kit) site.

2.  Double click on the downloaded package to install.

3.  Open a new PowerShell window to re-source your profile and make PDK
    available to your PATH.

## Setting up PDK behind a proxy

If you are using PDK behind a proxy, you must set environment variables to
enable PDK to communicate.

You can set these variables on the command line before each working session, or
you can add them to your system configuration, which varies depending on the
operating system.

On *nix or macOS systems, run:

```no-highlight
export http_proxy="http://user:password@proxy.domain.com:port"

export https_proxy="http://user:password@proxy.domain.com:port"

```

On Windows systems, run:

```no-highlight
$env:http_proxy="http://user:password@proxy.domain.com:port"

$env:https_proxy="http://user:password@proxy.domain.com:port"
```

## Analytics

### PDK data collection

PDK collects usage data to help us understand how it's being used and how we can
improve it. You can opt out of data collection at any time; see the section
below about opting out.

We collect these values for every analytics event:

-   A random non-identifying user ID. This ID is shared with Bolt analytics, if
    you've installed Bolt and enabled analytics.
-   PDK installation method (`package` or `gem`).
-   Version of PDK.
-   Operating system and version.

For every successful command line invocation of PDK, we collect:

-   The PDK command executed, such as `pdk new module` or ``pdk validate``.
-   Anonymised command options and arguments.
-   The version of Ruby used to execute the command.
-   The output formats for the command.
-   `PDK_*` environment variables and their values, if set.
-   Whether a template repository, if used, is `default` or `custom` — we do not
    record the path to the template repo itself.
-   If the default template repo is used, we collect events for each file
    rendered, recording whether the file is `unmanaged`, `deleted`,
    `customized`, or `default`. For customized files, we do not record what
    changed, only that it was changed in the `.sync.yml` file.

> **Note:** All arguments and non-Boolean option values, except `--puppet-version` are redacted in our collected data

Invalid commands are submitted as a distinct analytics events with the arguments
and option values redacted.

To see the data PDK collects, add the `--debug` option to any `pdk` command. We
test the analytics calls strictly to ensure that no unexpected data is
accidentally passed in.

### Opting out of PDK data collection

The first time you run PDK, it asks you if you want to opt out of data
collection. To opt out of data collection after that, edit the `analytics.yml`
file, setting the `disabled` key to `true`.

```
disabled: true
```

The location of this configuration file depends on your operating system and
configuration:

-   For most \*nix systems, where the `$XDG_CONFIG_HOME` variable is set:
    `${XDG_CONFIG_HOME}/puppet/analytics.yml`.
-   For most macOS systems, where the `$XDG_CONFIG_HOME` variable is not set:
    `~/.config/puppet/analytics.yml`.
-   For Windows: `%LOCALAPPDATA%/puppet/analytics.yml`.

You can also opt out of analytics by setting the environment variable
`PDK_DISABLE_ANALYTICS=true`. This is useful if you are using PDK in your CI
system.
