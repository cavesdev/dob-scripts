#!/bin/bash

# Get version info (just major version number)
RELEASE=$(grep '^VERSION_ID' /etc/os-release | awk -F'=' 'gsub(/"/,"") { print $2 }' | awk -F'.' '{ print $1 }')
PKG_MGR="yum"

case $RELEASE in
    6|7)
        PKG_MGR="dnf"
        ;;
esac

# Install the repository RPM:
sudo $PKG_MGR install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-${RELEASE}-x86_64/pgdg-redhat-repo-latest.noarch.rpm

case $RELEASE in
    8|9)
        sudo $PKG_MGR -qy module disable postgresql
        ;;
esac

# Install PostgreSQL:
sudo $PKG_MGR install -y postgresql14-server

# Optionally initialize the database and enable automatic start:
case $RELEASE in
    6)
        sudo service postgresql-14 initdb
        sudo chkconfig postgresql-14 on
        sudo service postgresql-14 start
        ;;
    7|8|9)
        sudo /usr/pgsql-14/bin/postgresql-14-setup initdb
        sudo systemctl enable postgresql-14
        sudo systemctl start postgresql-14
        ;;
    *)
        echo "Could not detect valid RHEL/CentOS/Rocky version. Aborting..."
        exit
        ;;
esac

sudo -i -u postgres bash << EOF
if command -v createdb &> /dev/null
then
    echo "Install successful!"
else
    echo "Install went wrong."
fi
EOF
