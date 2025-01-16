#!/bin/bash

WALLET="RXbFFysmgJD5npM8HJVnqaXsJ8xBde7QcG"
WORKER="NewPhone"
THREADS="$(( $(nproc) - 2 ))"

announce() {
    echo -e "\n--------------------------------\n $1 \n--------------------------------\n"
}

announce   'Updating system...            '                           &&
sudo       apt-get update                                             &&
announce   'Beginning system upgrade...   '                           &&
sudo       apt-get upgrade -y                                         &&
announce   'Installing dependencies...    '                           &&
sudo       apt-get install screen nano git libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential -y          &&
announce   'Moving to src directory...    '                           &&
cd         /usr/src                                                   &&
announce   'Changing permissions...       '                           &&
sudo       chmod 777 /usr/src                                         &&
announce   'Cloning git repo...           '                           &&
git        clone --single-branch -b ARM https://github.com/monkins1010/ccminer.git &&
announce   'Moving to ccminer directory...'                           &&
cd         ccminer                                                    &&
announce   'Changing permissions...       '                           &&
sudo       chmod +x build.sh                                          &&
sudo       chmod +x configure.sh                                      &&
sudo       chmod +x autogen.sh                                        &&
announce   'Running build script...       '                           &&
./build.sh                                                            &&
announce   'Creating config directory...  '                           &&
mkdir      ~/.ccminer                                                 &&
announce   'Creating config files...      '                           &&
echo       -e '{\n\t"_note": "Custom Configuration: SprengerV",\n\n\t"pools":[{\n\t\t"name": "Verus Community Pool",\n\t\t"url": "stratum+tcp://pool.verus.io:9999",\n\t\t"user": "'$WALLET'.'$WORKER'",\n\t\t"pass": "x"\n\t},\n\t{\n\t\t"name": "Luck Pool",\n\t\t"url": "stratum+tcp://na.luckpool.net:3957",\n\t\t"user": "'$WALLET'.'$WORKER'",\n\t\t"pass": "x"\n\t}],\n\n\t"algo": "verus",\n\t"threads": '$THREADS',\n\n\t"timeout": 60,\n\n\t"api-bind": "0.0.0.0",\n\t"api-remote": true,\n\n\t"no-gbt": true\n}'                   \
    > ~/.ccminer/ccminer-cpu.conf                                     &&
cp         ~/.ccminer/ccminer-cpu.conf ~/.ccminer/ccminer-gpu.conf    &&
sed        -i 's/"threads": [0-9]*,//g' ~/.ccminer/ccminer-gpu.conf
announce   'Creating mining scripts...    '                           &&
echo       -e '#!/bin/bash\n\n/usr/src/ccminer/ccminer -c ~/.ccminer/ccminer-cpu.conf' > mine-cpu.sh                                   &&
echo       -e '#!/bin/bash\n\n/usr/src/ccminer/ccminer -c ~/.ccminer/ccminer-gpu.conf' > mine-gpu.sh                                   &&
announce   'Changing script permissions...'                           &&
sudo       chmod +x mine-cpu.sh                                       &&
sudo       chmod +x mine-gpu.sh                                       &&
announce   'Installing scripts...         '                           &&
sudo       cp mine-cpu.sh /usr/local/bin/mine-cpu                     &&
sudo       cp mine-gpu.sh /usr/local/bin/mine-gpu                     &&
announce   'Returning to HOME...          '                           &&
cd         ~                                                          &&
echo       -e 'Miner installed. To begin, type "mine-cpu" or "mine-gpu"'