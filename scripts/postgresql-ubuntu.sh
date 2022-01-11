#!/bin/bash

# Check Ubuntu version
RELEASE=$(lsb_release -rs)
case $RELEASE in
    18.04|20.04|21.04|21.10) ;;

    *)
        echo "Ubuntu Distribution not supported. Aborting..."
        ;;
esac

# Create the file repository configuration:
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Import the repository signing key:
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update the package lists:
sudo apt-get update

# Install the latest version of PostgreSQL.
sudo apt-get -y install postgresql

# Change to postgres user and access the console
sudo -i -u postgres bash << EOF
if command -v createdb &> /dev/null
then
    echo "Install successful!"
else
    echo "Install went wrong."
fi
EOF