
# mac_setup.sh

su

# mac setup
defaults write -g InitalKeyRepeat -int 0
defaults write -g KeyRepeat -int 0
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.Dock autohide-delay -float 0
defaults write com.apple.desktopservices DSDontWriteNetworkStores True
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

# homebrew install 
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 

brew update
brew upgrade

# Brewfile install
brew bundle

# set zsh default shell
echo "/usr/local/bin/zsh" | sudo tee /etc/shells
chsh -s /usr/local//bin/zsh

# install prezto
cd ~
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.prezto"
setpot EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

#set prompt
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/el1t/statusline/master/prezto/install)"
