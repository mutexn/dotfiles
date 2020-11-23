# alcatraz install

echo"------alcatraz install-----------------------------------------------"

curl -fsSL https://raw.githubusercontent.com/supermarin/Alcatraz/deploy/Scripts/install.sh | sh
gem install update_xcode_plugins
update_xcode_plugins
update_xcode_plugins --unsign

echo"---------------------------------------------------------------------"


# xvim2 install

echo"------alcatraz install-----------------------------------------------"

make
cd ~

echo"---------------------------------------------------------------------"
