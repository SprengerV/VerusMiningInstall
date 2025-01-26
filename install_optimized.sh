#!/bin/bash

WALLET="RXbFFysmgJD5npM8HJVnqaXsJ8xBde7QcG"
WORKER="NewPhone"
THREADS="$(( $( nproc ) - 2 ))"

announce() {
    echo -e "\n--------------------------------\n $1 \n--------------------------------\n"
}

announce 'Updating system...            ' &&
sudo     apt-get update                   &&
announce 'Beginning system upgrade...   ' &&
sudo     apt-get upgrade -y               &&
announce 'Installing dependencies...    ' &&
sudo     apt-get install screen nano git libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential -y                                    &&
sudo     apt-get install libllvm-16-ocaml-dev libllvm16 llvm-16 llvm-16-dev llvm-16-doc llvm-16-examples llvm-16-runtime clang-16 clang-tools-16 clang-16-doc libclang-common-16-dev libclang-16-dev libclang1-16 clang-format-16 python3-clang-16 clangd-16 clang-tidy-16 libclang-rt-16-dev libpolly-16-dev libfuzzer-16-dev lldb-16 lld-16 libc++-16-dev libc++abi-16-dev libomp-16-dev libclc-16-dev libunwind-16-dev libmlir-16-dev mlir-16-tools flang-16 libclang-rt-16-dev-wasm32 libclang-rt-16-dev-wasm64 libclang-rt-16-dev-wasm32 libclang-rt-16-dev-wasm64 -y                                  &&
announce 'Moving to src directory...    ' &&
cd       /usr/src                         &&
announce 'Cloning git repo...           ' &&
git      clone https://github.com/Oink70/CCminer-ARM-optimized.git &&
announce 'Moving to ccminer directory...' &&
cd       CCminer-ARM-optimized            &&
announce 'Changing permissions...       ' &&
sudo     chmod +x build.sh                &&
sudo     chmod +x configure.sh            &&
sudo     chmod +x autogen.sh              &&
announce 'Running build script...       ' &&
CXX=clang++ CC=clang ./build.sh           &&
announce 'Creating config directory...  ' &&
mkdir    ~/.ccminer                       &&
announce 'Creating config file...       ' &&
echo     -e '{\n\t"_note": "Custom Configuration: SprengerV",\n\n\t"pools":[{\n\t\t"name": "Verus Community Pool",\n\t\t"url": "stratum+tcp://pool.verus.io:9999",\n\t\t"user": "'$WALLET'.'$WORKER'",\n\t\t"pass": "x"\n\t},\n\t{\n\t\t"name": "Luck Pool",\n\t\t"url": "stratum+tcp://na.luckpool.net:3957",\n\t\t"user": "'$WALLET'.'$WORKER'",\n\t\t"pass": "x"\n\t}],\n\n\t"algo": "verus",\n\t"threads": '$THREADS',\n\n\t"timeout": 60,\n\n\t"api-bind": "0.0.0.0",\n\t"api-remote": true,\n\n\t"no-gbt": true\n}' > ~/.ccminer/ccminer.conf &&
announce 'Creating mining scripts...    ' &&
echo     -e "#!/bin/bash\n\n$(pwd)/ccminer -c ~/.ccminer/ccminer.conf" > mine-cpu-optimized.sh &&
echo     -e '#!/bin/bash\n\nscreen -dmS optizmized bash -c "/usr/local/bin/mine-cpu-optimized"' > mine-optimized.sh &&
announce 'Changing script permissions...' &&
sudo     chmod +x mine-cpu-optimized.sh   &&
sudo     chmod +x mine-optimized.sh       &&
announce 'Installing scripts...         ' &&
sudo     cp mine-cpu-optimized.sh /usr/local/bin/mine-cpu-optimized &&
sudo     cp mine-optimized.sh /usr/local/bin/mine-optimized &&
announce 'Returning to HOME...          ' &&
cd       ~                                &&
echo     -e "Miner installed. To begin, type \"mine\"."