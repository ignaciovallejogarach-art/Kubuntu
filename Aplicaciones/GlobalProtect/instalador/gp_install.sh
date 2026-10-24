#!/bin/bash

if [ "$(id -u)" == "0" ]; then
    echo -e "\nGlobalProtect cannot be installed as a root user."
    echo -e "Please install the agent as a user with admin privileges.\n"
    exit 1
fi

# Determine Package Manager
pkg_mgr_type="undefined"
if which apt-get >/dev/null 2>&1; then
    pkg_mgr_type="debian"
elif which rpm >/dev/null 2>&1; then
    pkg_mgr_type="rpm"
else
    echo "Error: gp_install.sh: Unable to determine package manager type"
    exit 1
fi

# Determine command type
cmd_type="ui"
if [ $# -gt 0 ]; then
    case $1 in
        --cli-only)
            cmd_type="cli-only";;
        --arm)
            cmd_type="arm";;
        --aarch64)
            cmd_type="aarch64";;
        --help)
            ;&
        *)
            cmd_type="usage";;
    esac
fi

# Determine Linux Distro and Version
. /etc/os-release

if [ $ID == "ubuntu" ]; then
    linux_ver=${VERSION_ID:0:2}
elif [[ $ID == "rhel" || $ID == "centos" ]]; then
    linux_ver=${VERSION_ID:0:1}
elif [ $ID == "ol" ]; then
    linux_ver=${VERSION_ID:0:1}
fi

install_success=true

case $cmd_type in
    cli-only)
        # CLI Only Install
        if [ $pkg_mgr_type == "debian" ]; then
            # Install GlobalProtect Debian Image
            if ! sudo -E apt-get install -y ./GlobalProtect_deb-*.deb; then
                install_success=false
            fi
        elif [ $pkg_mgr_type == "rpm" ]; then
            # Check if old GP package installed
            yum_output=$(yum list installed | grep globalprotect)
            if [[ $yum_output == *"globalprotect.x86"* ]]; then
                echo "Older globalprotect detected...uninstalling..."
                if ! sudo yum -y remove globalprotect; then
                    install_success=false
                fi
            fi

            # Install GlobalProtect RPM Image
            if ! sudo -E yum -y install ./GlobalProtect_rpm-*; then
                install_success=false
            fi
        fi
        ;;	

    arm)
        # ARM Install
        if [ $pkg_mgr_type == "debian" ]; then
            # Install GlobalProtect Debian Image
            if ! sudo -E apt-get install -y ./GlobalProtect_deb_arm*.deb; then
                install_success=false
            fi
        elif [ $pkg_mgr_type == "rpm" ]; then
            # Check if old GP package installed
            yum_output=$(yum list installed | grep globalprotect)
            if [[ $yum_output == *"globalprotect.x86"* ]]; then
                echo "Older globalprotect detected...uninstalling..."
                if ! sudo yum -y remove globalprotect_arm; then
                    install_success=false
                fi
            fi

            # Install GlobalProtect RPM Image
            if ! sudo -E yum -y install ./GlobalProtect_rpm_arm*; then
                install_success=false
            fi
        fi
        ;;
		
    aarch64)
        # AARCH64 Install
        if [ $pkg_mgr_type == "debian" ]; then
            # Install GlobalProtect Debian Image
            if ! sudo -E apt-get install -y ./GlobalProtect_deb_aarch64*.deb; then
                install_success=false
            fi
        elif [ $pkg_mgr_type == "rpm" ]; then
            # Check if old GP package installed
            yum_output=$(yum list installed | grep globalprotect)
            if [[ $yum_output == *"globalprotect.x86"* ]]; then
                echo "Older globalprotect detected...uninstalling..."
                if ! sudo yum -y remove globalprotect_aarch64; then
                    install_success=false
                fi
            fi

            # Install GlobalProtect RPM Image
            if ! sudo -E yum -y install ./GlobalProtect_rpm_aarch64*; then
                install_success=false
            fi
        fi
        ;;

    ui)
        # UI Install
        case $ID in
            ubuntu)
                case $linux_ver in
                    14)
                        ;&
                    16)
                        ;&
                    18)
                        echo "Error: Unsupported Ubuntu version: $linux_ver"
                        exit 1
                        ;;
                    20)
                        if ! sudo apt-get install -y gnome-tweak-tool gnome-shell-extension-top-icons-plus; then
                            install_success=false
                        fi
                        gnome-extensions enable TopIcons@phocean.net
                        gsettings set org.gnome.shell.extensions.topicons tray-pos 'right'
                        ;;
                    22)
                        dpkg -s gnome-shell-extension-appindicator >/dev/null 2>&1
                        if [ $? -eq 0 ]; then
                            echo "GP Install WARNING: gnome-shell-extension-appindicator is installed."
                            echo "This package may cause issues with GP UI and is not recommended."
                        fi
                        if ! sudo apt-get install -y gnome-shell-extension-manager >/dev/null 2>&1; then
                            install_success=false
                        fi
                        ;;
                    *)
                        ;;
                esac
                ;;
            *)
                ;;
        esac

        if [ $pkg_mgr_type == "debian" ]; then
            # Install GlobalProtect Debian Image
            if ! sudo -E apt-get install -y ./GlobalProtect_UI_deb*.deb >/dev/null 2>&1; then
                install_success=false
            fi
        elif [ $pkg_mgr_type == "rpm" ]; then
            # Package Dependencies
            if ! sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm; then
                install_success=false
            fi

	    # Qt Install
            if ! sudo yum -y install qt5-qtwebkit wmctrl; then
                install_success=false
            fi

            # Gnome Shell Extensions Install
            if [[ $ID == "rhel" || $ID == "ol" ]]; then
                if ! sudo yum -y install gnome-shell-extension-appindicator gnome-shell-extension-top-icons gnome-tweaks; then
                    install_success=false
                fi
                gnome-extensions enable top-icons@gnome-shell-extensions.gcampax.github.com
            elif [ $ID == "fedora" ]; then
                if ! sudo yum -y install gnome-shell-extension-appindicator gnome-tweaks; then
                    install_success=false
                fi
                gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
            fi

            # Check if old GP package installed
            yum_output=$(yum list installed | grep globalprotect)
            if [[ $yum_output == *"globalprotect.x86"* ]]; then
                echo "Older globalprotect detected...uninstalling..."
                if ! sudo yum -y remove globalprotect_UI; then
                    install_success=false
                fi
            fi

            # Install GlobalProtect RPM Image
            if [ "$ID" = "fedora" ]; then
                if ! sudo -E rpm -ivh ./GlobalProtect_UI_rpm-*; then
                    install_success=false
                fi
            else
                if ! sudo -E yum -y install ./GlobalProtect_UI_rpm-*; then
                    install_success=false
                fi
            fi
        fi

        # Set GlobalProtect Icon in the Favorites Bar	
        gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed s/.$//), 'globalprotect.desktop']"

        if [ "$install_success" = true ]; then
            echo "GlobalProtect Installation Completed"
        else
            echo "GlobalProtect Installation Failed - insufficient privileges or package manager error"
            exit 1
        fi
        ;;
    
    usage)
        ;&
    *)
        echo "Usage: $ ./gp_install [--cli-only | --arm | --help]"
        echo "  --cli-only: CLI Only"
        echo "  --arm:      ARM           (32 bit)"
        echo "  --aarch64:  ARM64/aarch64 (64 bit)"
        echo "  default:    UI"
        ;;	
esac
