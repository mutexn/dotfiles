
# mac_setup.sh

# mac setup
defaults write -g InitalKeyRepeat -int 0
defaults write -g KeyRepeat -int 0
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.Dock autohide-delay -float 0
killall Finder
killall Dock

# xcode command line tools install 
xcode-select --install

# alcatraz install
curl -fsSL https://raw.githubusercontent.com/supermarin/Alcatraz/deploy/Scripts/install.sh | sh
gem install update_xcode_plugins
update_xcode_plugins
update_xcode_plugins --unsign

# xvim2 install
cd ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins/
git clone git://github.com/XVimProject/XVim2 XVim2
cd XVim2
make
cd ~

# homebrew install 
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 

brew update
brew upgrade

# Brewfile install
brew bundle
