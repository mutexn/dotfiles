
# mac_setup.sh

defaults write -g InitalKeyRepeat -int 0
defaults write -g KeyRepeat -int 0
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.Dock autohide-delay -float 0
killall Finder
killall Dock

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 

brew update
brew upgrade

brew bundle
