
# shell_setup.sh

echo "/usr/local/bin/zsh" | sudo tee /etc/shells
chsh -s /usr/local/bin/zsh
exec $SHELL

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
