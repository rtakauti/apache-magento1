#!/usr/bin/env bash

set -e

# Configure PHP date.timezone
echo "date.timezone = America/Sao_Paulo" > /usr/local/etc/php/conf.d/timezone.ini

# Create CA
if [ ! -e /etc/ssl/certs/apache.key ]; then
	openssl req \
        -newkey rsa:2048 -nodes -keyout /etc/ssl/certs/apache.key \
        -subj "/C=BR/ST=SP/L=Sao Paulo/CN=example.local/OU=IT/O=Vindi SA/emailAddress=comunidade@vindi.com.br" \
        -out /etc/ssl/certs/apache.csr

	openssl req \
	    -key /etc/ssl/certs/apache.key \
	    -x509 \
	    -nodes \
	    -new \
	    -out /etc/ssl/certs/apache.crt \
	    -subj "/C=BR/ST=SP/L=Sao Paulo/CN=example.local/OU=IT/O=Vindi SA/emailAddress=comunidade@vindi.com.br" \
	    -reqexts SAN \
	    -extensions SAN \
	    -config <(cat /usr/lib/ssl/openssl.cnf \
	        <(printf "[SAN]\nsubjectAltName=DNS:example.local")) \
	    -sha256 \
	    -days 36500
fi


# Configure Apache Document Root
echo "<VirtualHost *:80>" > /etc/apache2/sites-available/000-default.conf
echo "  ServerAdmin comunidade@vindi.com.br" >> /etc/apache2/sites-available/000-default.conf
echo "  ServerName example.local" >> /etc/apache2/sites-available/000-default.conf
echo "  ServerAlias example.local" >> /etc/apache2/sites-available/000-default.conf
echo "  DocumentRoot /var/www/html" >> /etc/apache2/sites-available/000-default.conf
echo "  ErrorLog ${APACHE_LOG_DIR}/error.log" >> /etc/apache2/sites-available/000-default.conf
echo "  CustomLog ${APACHE_LOG_DIR}/access.log combined" >> /etc/apache2/sites-available/000-default.conf
echo "</VirtualHost>" >> /etc/apache2/sites-available/000-default.conf
a2ensite 000-default



a2enmod ssl
echo "<IfModule mod_ssl.c>" > /etc/apache2/sites-available/default-ssl.conf
echo "	<VirtualHost *:443>" >> /etc/apache2/sites-available/default-ssl.conf
echo "      DocumentRoot /var/www/html" >> /etc/apache2/sites-available/default-ssl.conf
echo "		ServerAdmin comunidade@vindi.com.br" >> /etc/apache2/sites-available/default-ssl.conf
echo "      ServerName example.local:443" >> /etc/apache2/sites-available/default-ssl.conf
echo "      ServerAlias example.local" >> /etc/apache2/sites-available/default-ssl.conf
echo "		ErrorLog ${APACHE_LOG_DIR}/error.log" >> /etc/apache2/sites-available/default-ssl.conf
echo "		CustomLog ${APACHE_LOG_DIR}/access.log combined" >> /etc/apache2/sites-available/default-ssl.conf
echo "		SSLEngine on" >> /etc/apache2/sites-available/default-ssl.conf
echo "		SSLCertificateFile /etc/ssl/certs/apache.crt" >> /etc/apache2/sites-available/default-ssl.conf
echo "      SSLCertificateKeyFile /etc/ssl/certs/apache.key" >> /etc/apache2/sites-available/default-ssl.conf
echo "      SSLCertificateChainFile /etc/ssl/certs/apache.crt" >> /etc/apache2/sites-available/default-ssl.conf
echo "	</VirtualHost>" >> /etc/apache2/sites-available/default-ssl.conf
echo "</IfModule>" >> /etc/apache2/sites-available/default-ssl.conf
a2ensite default-ssl



echo "<Directory /var/www/html>" > /etc/apache2/conf-available/document-root-directory.conf
echo "	AllowOverride All" >> /etc/apache2/conf-available/document-root-directory.conf
echo "	Require all granted" >> /etc/apache2/conf-available/document-root-directory.conf
echo "</Directory>" >> /etc/apache2/conf-available/document-root-directory.conf
a2enconf "document-root-directory.conf"



cd /var/www/html
tar -xf magento1.tar.gz
chown -R www-data:www-data /var/www/html
rm magento1.tar.gz


modgit init
modgit -b homolog add vindi https://github.com/vindi/vindi-magento.git


cd /var/www/html/app/code/community/Vindi/Subscription/tests
composer install

exec "$@"
