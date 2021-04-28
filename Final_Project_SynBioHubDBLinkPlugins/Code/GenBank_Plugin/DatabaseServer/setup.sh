#!/bin/bash
# N.B. RUN WITH SUDO PRIVILEGES

if [[ -z $1  || $1 -eq "-h" ]]; then
        echo "Sets up the environment for the database and"
        echo "registers a cronjob for weekly database updates"
        echo ""
        echo "USAGE: sudo ./setup.sh [database_fragment] [distro]"
        echo "  -database_fragment: Two digit fragment section"
        echo "  -distro [OPTIONAL]: 'Centos' or 'Ubuntu' [DEFAULT: 'Centos']"
        exit 0
fi

len=$(echo $1 | wc -c)
if [[ $1 == ^[0-9]+$ || $len -ne 3 || $1 -eq 0 ]]; then
            echo "A two digit data fragment larger than zero must be specified!"
            echo "Ex: sudo ./setup.sh 01"
            exit 1
fi

centos=true
if [[ $2 -eq "Ubuntu" ]]; then
        centos=false
fi

# Gets necessary packages
if [[ $centos = true ]]; then
        yum install -y git, wget
else
        apt-get install -y git wget
fi

pip3 install -r "requirements.txt"

# Sets up blast directories
cd $HOME
sudo mkdir bin blastdb queries fasta results blastdb_custom

# Pulls data fragment
cd blastdb
wget https://ftp.ncbi.nlm.nih.gov/blast/db/nt.00.tar.gz
wget "https://ftp.ncbi.nlm.nih.gov/blast/db/nt.{$1}.tar.gz"
tar -xvf *.tar.gz
rm *.tar.gz

echo "Installation complete"