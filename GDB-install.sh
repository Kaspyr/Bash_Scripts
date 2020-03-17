#!/bin/bash

# Checking if this is run as root or sudo
root_check () {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root or with sudo."
        exit 1
    fi
}


decor () {
sleep .5
echo -e "\n--------------------------------------"
echo -e "\t$1" 
echo -e "--------------------------------------\n"
sleep 1.5
}

# Removing current versions of gdb
remove_gdb () {
    decor "Removing GDB" 

    apt remove -y gdb*
    rm /usr/local/bin/gdb
    gdb || echo "GDB Successfully Removed"
}

# Installing necessary programs
install_programs () {
    decor "Installing Needed programs" 

    for i in $programs
    do
        apt install -y $i || echo "$i did not install"
    done
}

# Downloading new version of GDB
download_gdb () {
    decor "Downloading and setting up GDB"

    wget "http://ftp.gnu.org/gnu/gdb/gdb-9.1.tar.gz"
    tar -xvzf gdb-9.1.tar.gz
    mkdir gdb-9.1/build
    cd gdb-9.1/build
    cp ../configure .
    ./configure
}

# Making and installing GDB
make_gdb () {
    decor "Making and installing GDB"

    make
    make install
    (gdb -v && echo "GDB has been Installed") || echo "GDB Not Install"
}

# Cleaning up from GDB
clean_gdb () {
    cd ../../
    rm -rf gdb-9*
    cd ~
}

# Instructions
instructions () {
    decor "Instructions for using GDB" 

    echo -e "\t1. Start gdb."
    echo -e "\t2. In gdb type 'run'."
    echo -e "\t3. Next type 'disassemble main' or 'disas main' for short."
    echo -e "\t4. Now you can start making your breakpoints.\n"
}

# Setting Variables for script
up="apt update -y && apt upgrade -y"
programs="texinfo wget gcc g++"

# Calling of the functions
root_check
remove_gdb
install_programs
download_gdb
make_gdb
clean_gdb
instructions
