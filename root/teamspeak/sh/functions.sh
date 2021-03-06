#!/bin/sh
#Cleans the entire teamspeak folder
clean_teamspeak_folder(){
    if [ -d "/teamspeak/sql" ]
    then
        rm -r /teamspeak/sql
    fi

    if [ -d "/teamspeak/tsdns" ]
    then
        rm -r /teamspeak/tsdns
    fi

    if [ -e "/teamspeak/libts3db_sqlite3.so" ]
    then
        rm -r /teamspeak/libts3db_sqlite3.so
    fi

    if [ -e "/teamspeak/libts3_ssh.so" ]
    then
        rm -r /teamspeak/libts3_ssh.so
    fi

    if [ -e "/teamspeak/ts3server" ]
    then
        rm -r /teamspeak/ts3server
    fi

    if [ -e "/teamspeak/ts3server_minimal_runscript.sh" ]
    then
        rm -r /teamspeak/ts3server_minimal_runscript.sh
    fi

    if [ -e "/teamspeak/ts3server_startscript.sh" ]
    then
        rm -r /teamspeak/ts3server_startscript.sh
    fi

    if [ -e "/teamspeak/version" ]
    then
        rm -r /teamspeak/version
    fi

    if [ -e "/teamspeak/save/update" ]
    then
        rm -r /teamspeak/save/update
    fi
}

#Cleans the folder for cache
clean_cached_folder(){
    if [ "$(ls -A /teamspeak_cached)" ]
    then
        rm -r /teamspeak_cached/*
    fi
}

#Creates the minimal runscript
create_minimal_runscript(){
    echo '#!/bin/sh

cd $(dirname $([ -x "$(command -v realpath)" ] && realpath "$0" || readlink -f "$0"))

if [ -e "/teamspeak/init" ]
then
    if [ "$INIFILE" != 0 ]
    then
        if ! [ -e "/teamspeak/save/ts3server.ini" ]
        then
            exec qemu-i386 ./ts3server createinifile=1
        else
            exec qemu-i386 ./ts3server
        fi
    else
        exec qemu-i386 ./ts3server
    fi
fi

if [ "$INIFILE" != 0 ]
then
    exec qemu-i386 ./ts3server inifile=save/ts3server.ini > /dev/null 2>&1
else
    exec qemu-i386 ./ts3server > /dev/null 2>&1
fi' > /teamspeak/ts3server_minimal_runscript.sh


    chmod +x /teamspeak/ts3server_minimal_runscript.sh
}

#chown everything for ts user and group
chown_teamspeak_folder(){
    chown ts:ts -R /teamspeak
}

#Creates folders at first run
create_folders(){
    if ! [ -d "/teamspeak/save" ]
    then
        mkdir /teamspeak/save
    fi

    if ! [ -d "/teamspeak/save/files" ]
    then
        mkdir /teamspeak/save/files
    fi

    if ! [ -d "/teamspeak/save/logs" ]
    then
        mkdir /teamspeak/save/logs
    fi

    if ! [ -d "/teamspeak/save/backup" ]
    then
        mkdir /teamspeak/save/backup
    fi
}

#Creates files at first run
create_files(){
    if ! [ -e "/teamspeak/save/query_ip_whitelist.txt" ]
    then
        touch /teamspeak/save/query_ip_whitelist.txt
    fi

    if ! [ -e "/teamspeak/save/query_ip_blacklist.txt" ]
    then
        touch /teamspeak/save/query_ip_blacklist.txt
    fi

    if ! [ -e "/teamspeak/save/ts3server.sqlitedb" ]
    then
        touch /teamspeak/save/ts3server.sqlitedb
    fi
}

#Creates links betwwen save folder and main teamspeak folder
create_links(){
    ln -s /teamspeak/save/ts3server.sqlitedb /teamspeak/ts3server.sqlitedb
    ln -s /teamspeak/save/query_ip_whitelist.txt /teamspeak/query_ip_whitelist.txt
    ln -s /teamspeak/save/query_ip_blacklist.txt /teamspeak/query_ip_blacklist.txt
}