#!/bin/bash

# DISCLAIMER
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# INITIALIZATION ##############################################################
set -o xtrace

debug=true

updateSystem=false
packages=""
repos=()
taskNames=()
taskMessages=()
taskDescriptions=()
taskRecipes=()
taskPostInstallations=()
taskSelectedList=()


# TASK LIST ###################################################################
#------------------------------------------------------------------------------
taskNames+=("Update system")
taskMessages+=("Updating system")
taskDescriptions+=("Install the latest version of all your software")
taskRecipes+=("updateSystem")
taskPostInstallations+=("")
taskSelectedList+=("FALSE")

updateSystem()
{
  updateSystem=true
}
#------------------------------------------------------------------------------
taskNames+=("Install automatic drivers")
taskMessages+=("Processing drivers")
taskDescriptions+=("Install drivers that are appropriate for automatic installation")
taskPostInstallations+=("")
taskRecipes+=("autoInstallDrivers")
taskSelectedList+=("FALSE")

autoInstallDrivers()
{
  ubuntu-drivers autoinstall
}
#------------------------------------------------------------------------------
taskNames+=("Install Java, Flash and codecs")
taskMessages+=("Processing Java, Flash and codecs")
taskDescriptions+=("Install non-open-source packages like Java, Flash plugin, Unrar, and some audio and video codecs like MP3/AVI/MPEG")
taskRecipes+=("installRestrictedExtras")
taskPostInstallations+=("")
taskSelectedList+=("FALSE")

installRestrictedExtras()
{
  addPackage "ubuntu-restricted-extras"
}
#------------------------------------------------------------------------------
taskNames+=("Install Chrome")
taskMessages+=("Processing Chrome")
taskDescriptions+=("The web browser from Google")
taskRecipes+=("installChrome")
taskPostInstallations+=("")
taskSelectedList+=("FALSE")

installChrome()
{
  if [[ $OSarch == "x86_64" ]]; then
      installPackage "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
  else
      >&2 echo "Your system is not supported by Google Chrome"
      return 1
  fi
}
#------------------------------------------------------------------------------
taskNames+=("Install Chromium")
taskMessages+=("Processing Chromium")
taskDescriptions+=("The open-source web browser providing the code for Google Chrome.")
taskRecipes+=("installChromium")
taskPostInstallations+=("")
taskSelectedList+=("FALSE")

installChromium()
{
  echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
  addPackage "chromium-browser"
}
#------------------------------------------------------------------------------
taskNames+=("Install Firefox")
taskMessages+=("Processing Firefox")
taskDescriptions+=("The web browser from Mozilla")
taskRecipes+=("installFirefox")
taskPostInstallations+=("")
taskSelectedList+=("FALSE")

installFirefox()
{
  addRepo "ppa:ubuntu-mozilla-security/ppa"
  addPackage "firefox firefox-locale-$(locale | grep LANGUAGE | cut -d= -f2 | cut -d_ -f1)"
}
#------------------------------------------------------------------------------
taskNames+=("Install Opera")
taskMessages+=("Processing Opera")
taskDescriptions+=("Just another web browser")
taskRecipes+=("installOpera")
taskPostInstallations+=("")
taskSelectedList+=("FALSE")

installOpera()
{
  echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
  echo opera-stable opera-stable/add-deb-source boolean true | debconf-set-selections

  if [[ $OSarch == "x86_64" ]]; then
    wget -O /tmp/opera.deb "https://download1.operacdn.com/pub/opera/desktop/52.0.2871.40/linux/opera-stable_52.0.2871.40_amd64.deb"
  else
    wget -O /tmp/opera.deb "https://download1.operacdn.com/pub/opera/desktop/52.0.2871.40/linux/opera-stable_52.0.2871.40_i386.deb"
  fi
  
  DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/opera.deb # Needs dpkg and variable set to avoid prompt
  rm /tmp/opera.deb
}
#------------------------------------------------------------------------------
taskNames+=("Install Transmission")
taskMessages+=("Processing Transmission")
taskDescriptions+=("A light bittorrent download client")
taskRecipes+=("installTransmission")
taskPostInstallations+=("")
taskSelectedList+=("FALSE")

installTransmission()
{
  addRepo "ppa:transmissionbt/ppa"
  addPackage "transmission-gtk"
}
#------------------------------------------------------------------------------
taskNames+=("Install Dropbox")
taskMessages+=("Processing Dropbox")
taskDescriptions+=("A cloud hosting service to store your files online")
taskRecipes+=("installDropbox")
taskPostInstallations+=("")
taskSelectedList+=("FALSE")

installDropbox()
{
  # Handle elementary OS with wingpanel support
  if [[ $OSname == "elementary" ]]; then
    installPackage git
    apt-get --purge remove -y dropbox*
    installPackage python-gpgme
    git clone https://github.com/zant95/elementary-dropbox /tmp/elementary-dropbox
    bash /tmp/elementary-dropbox/install.sh -y
  else
    if [[ $OSarch == "x86_64" ]]; then
        wget -O /tmp/dropbox.tar.gz "https://www.dropbox.com/download?plat=lnx.x86_64"
    else
        wget -O /tmp/dropbox.tar.gz "https://www.dropbox.com/download?plat=lnx.x86"
    fi

    tar -xvzf /tmp/dropbox.tar.gz -C /home/"$SUDO_USER"
    /.dropbox-dist/dropboxd
  fi
}
#------------------------------------------------------------------------------
taskNames+=("Install VirtualBox")
taskMessages+=("Processing VirtualBox")
taskDescriptions+=("A virtualization software to run other OSes on top of your current OS")
taskRecipes+=("installVirtualBox")
taskPostInstallations+=("")
taskSelectedList+=("FALSE")

installVirtualBox()
{
  addPackage "virtualbox"
}
#------------------------------------------------------------------------------
taskNames+=("Install Skype")
taskMessages+=("Processing Skype")
taskDescriptions+=("A videocall software from Microsoft")
taskRecipes+=("installSkype")
taskPostInstallations+=("")
taskSelectedList+=("FALSE")

installSkype()
{
  installPackage "https://go.skype.com/skypeforlinux-64.deb"
}
#------------------------------------------------------------------------------
taskNames+=("Install Thunderbird")
taskMessages+=("Processing Thunderbird")
taskDescriptions+=("A mail client from Mozilla")
taskRecipes+=("installThunderbird")
taskPostInstallations+=("")
taskSelectedList+=("FALSE")

installThunderbird()
{
  addPackage "thunderbird"
}
#------------------------------------------------------------------------------
taskNames+=("Install Telegram")
taskMessages+=("Processing Telegram")
taskDescriptions+=("A chat client, similar to Whatsapp, Viber, Facebook Messenger or Google Hangouts")
taskRecipes+=("installTelegram")
taskPostInstallations+=("")
taskSelectedList+=("FALSE")


      exit 0
    fi
fi

exit 0
