#!/bin/bash 

# Check root privileges

if [ "$(id -u)" -ne 0 ]; then
	echo "this script must my run with root privileges"
# If you don`t have root privileges - close script	
	exit
fi


# Update packages 
apt update 

# Installation Apache 2
apt install -y apache2

# Enabel Apache 2
systemctl enable apache2

# Start Apache 2
systemctl start apache2

echo "Installation Apachce 2 is complete."

# View status 
status=$(systemctl status apache2)
echo $status

# Installing SSL Certificates using Certbot

# Installing snapd
apt install -y snapd

# Remove if exisist certbot packages 
apt remove -y certbot

# Install Cerbtbot 
snap install --classic certbot 

# Prepare the Certbot command 
ln -s /snap/bin/certbot /usr/bin/certbot

# Promt the user email address and domian name
# Function to validate email addess and domian name  using regular expression 

function is_valid_email() {
        local email="$1"
        local email_regex="^[A-Za-z0-9.%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"

        if [[ "$email" =~ $email_regex ]]; then
                return 0 # Valid 
        else
                return 1 # Invalid
        fi
}

while true; do
        read -p "Enter your address email: " email

        if is_valid_email "$email"; then
               break # Valid email address
       else
               echo "Invalid email address. Please try again."
        fi
done

function is_valid_domian() {
        local domian="$1"
	local domian_regex="^([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$"

        if [[ "$domian" =~ $domian_regex ]]; then
                return 0 # Valid 
        else
                return 1 # Invalid
        fi
}

while true; do
        read -p "Enter your domian name: " domian

        if is_valid_domian "$domian"; then
               break # Valid domian name 
       else
               echo "Invalid domian name. Please try again."
        fi
done


# Obtain and istall the SSL certificate
certbot --apache --non-interactive --agree-tos --email "$email" -d "$domian"

# Check the status of Apache 
echo $status
