
# mac_setup.sh
echo"------super user-----------------------------------------------------"

su

echo"---------------------------------------------------------------------"


# mac setup

echo"------mac setup------------------------------------------------------"

defaults write -g InitalKeyRepeat -int 0
defaults write -g KeyRepeat -int 0
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.Dock autohide-delay -float 0
defaults write com.apple.desktopservices DSDontWriteNetworkStores True
killall Finder
killall Dock

echo"---------------------------------------------------------------------"


# xcode command line tools install 

echo"------xcode command line tools install-------------------------------"

xcode-select --install

echo"---------------------------------------------------------------------"


# homebrew install 

echo"------homebrew install-----------------------------------------------"

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 

brew update
brew upgrade

echo"---------------------------------------------------------------------"


# Brewfile install

echo"------Brewfile install-----------------------------------------------"

brew bundle

echo"---------------------------------------------------------------------"


# set zsh default shell

echo"------zsh defaults setup---------------------------------------------"

echo "/usr/local/bin/zsh" | sudo tee /etc/shells
chsh -s /usr/local//bin/zsh

echo"---------------------------------------------------------------------"


# install prezto

echo"------prezto install-------------------------------------------------"

cd ~
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.prezto"
setpot EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

echo"---------------------------------------------------------------------"


#set prompt

echo"------prompt install-------------------------------------------------"

zsh -c "$(curl -fsSL https://raw.githubusercontent.com/el1t/statusline/master/prezto/install)"

echo"---------------------------------------------------------------------"
