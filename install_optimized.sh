#!/bin/bash

echo -e "\n--------------------------------\n Updating system...             \n--------------------------------\n" &&
sudo apt-get update &&
echo -e "\n--------------------------------\n Beginning system upgrade...    \n--------------------------------\n" &&
sudo apt-get upgrade -y &&
echo -e "\n--------------------------------\n Installing dependencies...     \n-------------------------------\n" &&
sudo apt-get install nano git libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential -y &&
sudo apt-get install libllvm-16-ocaml-dev libllvm16 llvm-16 llvm-16-dev llvm-16-doc llvm-16-examples llvm-16-runtime clang-16 clang-tools-16 clang-16-doc libclang-common-16-dev libclang-16-dev libclang1-16 clang-format-16 python3-clang-16 clangd-16 clang-tidy-16 libclang-rt-16-dev libpolly-16-dev libfuzzer-16-dev lldb-16 lld-16 libc++-16-dev libc++abi-16-dev libomp-16-dev libclc-16-dev libunwind-16-dev libmlir-16-dev mlir-16-tools flang-16 libclang-rt-16-dev-wasm32 libclang-rt-16-dev-wasm64 libclang-rt-16-dev-wasm32 libclang-rt-16-dev-wasm64 -y &&
echo -e "\n--------------------------------\n Moving to src directory...     \n--------------------------------\n" &&
cd /usr/src &&
echo -e "\n--------------------------------\n Cloning git repo...            \n--------------------------------\n" &&
git clone https://github.com/Oink70/CCminer-ARM-optimized.git &&
echo -e "\n--------------------------------\n Moving to ccminer directory... \n--------------------------------\n" &&
cd CCminer-ARM-optimized &&
echo -e "\n--------------------------------\n Changing permissions...        \n--------------------------------\n" &&
sudo chmod +x build.sh &&
sudo chmod +x configure.sh &&
sudo chmod +x autogen.sh &&
echo -e "\n--------------------------------\n Running build script...        \n--------------------------------\n" &&
./build.sh &&
echo -e "\n--------------------------------\n Creating config directory...   \n--------------------------------\n" &&
mkdir ~/.ccminer &&
echo -e "\n--------------------------------\n Creating config file...        \n--------------------------------\n" &&
echo -e "{\n\t\"_note\": \"Custom Configuration: SprengerV\",\n\n\t\"pools\":[{\n\t\t\"name\": \"Verus Community Pool\",\n\t\t\"url\": \"stratum+tcp://pool.verus.io:9999\",\n\t\t\"user\": \"RXbFFysmgJD5npM8HJVnqaXsJ8xBde7QcG.NewPhone\",\n\t\t\"pass\": \"x\"\n\t},\n\t{\n\t\t\"name\": \"Luck Pool\",\n\t\t\"url\": \"stratum+tcp://na.luckpool.net:3957\",\n\t\t\"user\": \"RXbFFysmgJD5npM8HJVnqaXsJ8xBde7QcG.NewPhone\",\n\t\t\"pass\": \"x\"\n\t}],\n\n\t\"algo\": \"verus\",\n\t\"threads\": $(( $(nproc) - 2 )),\n\n\t\"timeout\": 60,\n\n\t\"api-bind\": \"0.0.0.0\",\n\t\"api-remote\": true,\n\n\t\"no-gbt\": true\n}" > ~/.ccminer/ccminer.conf &&
echo -e "\n------------------------\nCreating mining script...           \n------------------------------\n" &&
echo -e "#!/bin/bash\n\n$(pwd)/ccminer -c ~/.ccminer/ccminer.conf" > mine.sh &&
echo -e "\n--------------------------------\n Changing script permissions... \n--------------------------------\n" &&
sudo chmod +x mine.sh &&
echo -e "\n--------------------------------\n Installing script...           \n--------------------------------\n" &&
sudo cp mine.sh /usr/local/bin/mine &&
echo -e "\n--------------------------------\n Returning to HOME...           \n--------------------------------\n" &&
cd ~ &&
echo -e "Miner installed. To begin, type \"mine\"."