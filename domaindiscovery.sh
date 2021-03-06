#!/bin/bash

if [ -d ~/recon/$1/$(date +"%d-%m-%Y") ]
then
        echo -e "\e[1;33m[+] Direcotry already exists\e[0m"
else
        mkdir -p ~/recon/$1/$(date +"%d-%m-%Y")
        echo -e "\e[1;33m[+] Direcotry Created\e[0m"
fi

cd ~/recon/$1/$(date +"%d-%m-%Y")

echo -e "\e[1;33m[+] Running CRTsh\e[0m"
curl -s https://crt.sh/?q=%25.$1 | grep $1 | grep "<TD>" | cut -d">" -f2 | cut -d"<" -f1 | sort -u | sed s/*.//g >> crtsh.txt

echo -e "\e[1;33m[+] Running Findomain\e[0m"
findomain-linux -t $1 -u findomain.txt

echo -e "\e[1;33m[+] Running Subfinder\e[0m"
subfinder -d $1 -o subfinder.txt

echo -e "\e[1;33m[+] Running Assetfinder\e[0m"
assetfinder -subs-only $1 > assetfinder.txt

echo -e "\e[1;33m[+] Running Amass\e[0m"
amass enum -passive -d $1 -o amass.txt

echo -e "\e[1;33m[+] Running ShuffleDNS\e[0m"
shuffledns -d $1 -massdns /root/massdns/bin/massdns -w /root/massdns/lists/all.txt -r /root/massdns/lists/resolvers.txt -o shuffledns.txt

echo -e "\e[1;33m[+] Merging Files\e[0m"
cat *.txt > all_old.txt
sort -u all_old.txt > all.txt
