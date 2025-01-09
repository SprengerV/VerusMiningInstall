#!/bin/bash

echo -e "\n------------------------\nUpdating system...\n------------------------\n" &&
sudo apt-get update &&
echo -e "\n------------------------\nBeginning system upgrade...\n------------------------\n" &&
sudo apt-get upgrade -y &&
echo -e "\n------------------------\nInstalling dependencies...\n------------------------\n" &&
sudo apt-get install nano git libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential -y &&
echo -e "\n------------------------\nMoving to src directory...\n------------------------\n" &&
cd /usr/src &&
echo -e "\n------------------------\nCloning git repo...\n------------------------\n" &&
git clone --single-branch -b ARM https://github.com/monkins1010/ccminer.git &&
echo -e "\n------------------------\nMoving to ccminer directory...\n------------------------\n" &&
cd ccminer &&
echo -e "\n------------------------\nChanging permissions...\n------------------------\n" &&
sudo chmod +x build.sh &&
sudo chmod +x configure.sh &&
sudo chmod +x autogen.sh &&
echo -e "\n------------------------\nRunning build script...\n------------------------\n" &&
./build.sh &&
echo -e "\n------------------------\nCreating config directory...\n------------------------\n" &&
mkdir ~/.ccminer &&
echo -e "\n------------------------\nCreating config file...\n------------------------\n" &&
echo -e "{\n\t\"_note\": \"Custom Configuration: SprengerV\",\n\n\t\"pools\":[{\n\t\t\"name\": \"Verus Community Pool\",\n\t\t\"url\": \"stratum+tcp://pool.verus.io:9999\",\n\t\t\"user\": \"RXbFFysmgJD5npM8HJVnqaXsJ8xBde7QcG.NewPhone\",\n\t\t\"pass\": \"x\"\n\t},\n\t{\n\t\t\"name\": \"Luck Pool\",\n\t\t\"url\": \"stratum+tcp://na.luckpool.net:3957\",\n\t\t\"user\": \"RXbFFysmgJD5npM8HJVnqaXsJ8xBde7QcG.NewPhone\",\n\t\t\"pass\": \"x\"\n\t}],\n\n\t\"algo\": \"verus\",\n\t\"threads\": $(( $(nproc) - 2 )),\n\n\t\"timeout\": 60,\n\n\t\"api-bind\": \"0.0.0.0\",\n\t\"api-remote\": true,\n\n\t\"no-gbt\": true\n}" > ~/.ccminer/ccminer.conf &&
echo -e "\n------------------------\nCreating mining script...\n------------------------\n" &&
echo -e "#!/bin/bash\n\n$(pwd)/ccminer -c ~/.ccminer/ccminer.conf" > mine.sh &&
echo -e "\n------------------------\nChanging script permissions\n------------------------\n" &&
sudo chmod +x mine.sh &&
echo -e "\n------------------------\nInstalling script...\n------------------------\n" &&
sudo cp mine.sh /usr/local/bin/mine &&
echo -e "\n------------------------\nReturning to HOME...\n------------------------\n" &&
cd ~ &&
echo -e "Miner installed. To begin, type \"mine\"."