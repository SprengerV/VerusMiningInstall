#!/bin/bash

WALLET="RXbFFysmgJD5npM8HJVnqaXsJ8xBde7QcG"
WORKER="NewPhone"

announce() {
    echo -e "\n--------------------------------\n $1 \n--------------------------------\n"
}

announce   'Updating system...            '                           &&
sudo       apt-get update                                             &&
announce   'Beginning system upgrade...   '                           &&
sudo       apt-get upgrade -y                                         &&
announce   'Installing dependencies...    '                           &&
sudo       apt-get install nano git libcurl4-openssl-dev libssl-dev    \
    libjansson-dev automake autotools-dev build-essential -y          &&
announce   'Moving to src directory...    '                           &&
cd         /usr/src                                                   &&
announce   'Changing permissions...       '                           &&
sudo       chmod 777 /usr/src                                         &&
announce   'Cloning git repo...           '                           &&
git        clone                                                       \
    --single-branch -b ARM https://github.com/monkins1010/ccminer.git &&
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
announce   'Creating config file...       '                           &&
echo       -e '{\n\t"_note": "Custom Configuration: SprengerV",\n\n\t"'\
    'pools":[{\n\t\t"name": "Verus Community Pool",\n\t\t"url": "strat'\
    'um+tcp://pool.verus.io:9999",\n\t\t"user": "'$WALLET'.'$WORKER'",'\
    '\n\t\t"pass": "x"\n\t},\n\t{\n\t\t"name": "Luck Pool",\n\t\t"url"'\
    ': "stratum+tcp://na.luckpool.net:3957",\n\t\t"user": "'$WALLET'.'\
    $WORKER'",\n\t\t"pass": "x"\n\t}],\n\n\t"algo": "verus",\n\t"threa'\
    'ds": '$(( $(nproc) - 2 ))',\n\n\t"timeout": 60,\n\n\t"api-bind": '\
    '"0.0.0.0",\n\t"api-remote": true,\n\n\t"no-gbt": true\n}'         \
    > ~/.ccminer/ccminer.conf                                         &&
announce   'Creating mining script...     '                           &&
echo       -e '#!/bin/bash\n\n/usr/src/ccminer/ccminer -c ~/.ccminer/c'\
    'cminer.conf' > mine.sh                                           &&
announce   'Changing script permissions...'                           &&
sudo       chmod +x mine.sh                                           &&
announce   'Installing script...          '                           &&
sudo       cp mine.sh /usr/local/bin/mine                             &&
announce   'Returning to HOME...          '                           &&
cd         ~                                                          &&
echo       -e "Miner installed. To begin, type \"mine\"."