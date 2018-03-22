
# mac_setup.sh

su

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

make
cd ~

git config --global user.name "po-lar"
git config --global user.email k.shoma.0810.mf@gmail.com

# homebrew install 
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 

brew update
brew upgrade

# Brewfile install
brew bundle
