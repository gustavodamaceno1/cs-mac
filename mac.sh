#!/bin/bash
#
# exec: curl -sSL https://raw.githubusercontent.com/cs-tiago-almeida/cs-codes/development/environment/macox.sh | sh
#

figlet "Install OSX Deps with Ansible"

printf "Checking Environment Integrity.\n\n"
printf "I will always choose a lazy person to do a difficult job because a lazy person will find an easy way to do it.
Bill Gates :)"

echo
echo
sleep 3
echo

command_exists () {
  if type "$1" &> /dev/null; then
    echo "[" $1 "] already installed. Skipping."
  else
    echo "[" $1 "] not found. Starting Setup."
    return 1
  fi
}

brew_package_exists () {
  if brew list "$1" &> /dev/null; then
    echo "[" $1 "] already installed. Skipping."
  else
    echo "[" $1 "] not found. Starting Setup."
    return 1
  fi
}

## Install Brew
if ! command_exists brew; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew doctor
  echo "Updating BREW"
  brew update
  echo "Instaling Brew Services."
  brew tap homebrew/services
fi

## Install Xcode
if ! command_exists xcode-select -p; then
  echo "[ xcode ] not found. Starting Setup."
  sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
  sudo xcodebuild -license accept
fi

## Install Wget
if ! command_exists wget -V; then
  echo "[ Wget ] not found. Starting Setup."
  brew install wget
  echo "Done"
fi

## Install Ansible
if ! command_exists ansible --version; then
  sudo easy_install pip
  sudo ARCHFLAGS=-Wno-error=unused-command-line-argument-hard-error-in-future pip install pycrypto
  sudo pip install ansible --quiet
  sudo pip install ansible --upgrade
fi
# Create Ansible directory structure
if   [[ -d ~/ansible ]]; then
    echo "Directory $HOME/ansible exists."
else
    echo "[Create Ansible Directory]"
    mkdir ~/ansible
fi

cd ~/ansible/
echo "[Download Fred's_playbook]"
wget https://raw.githubusercontent.com/cs-tiago-almeida/cs-codes/development/environment/freds_qa_dep.yml && ansible-playbook freds_qa_dep.yml -vvvv

echo
echo "Successfully"
