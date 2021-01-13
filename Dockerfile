FROM prestashop/prestashop:1.7.6.8

RUN apt-get update

#Install git
RUN apt-get install git -y

#Install vim
RUN apt-get install vim -y

#Prestashop Source
RUN cd /var/www
RUN mkdir temp-html
RUN git clone https://github.com/P-Biznes-Elektroniczny/Presta.git temp-html
RUN cp -r temp-html html
RUN rm -r temp-html
RUN chmod -R 776 html
RUN chown -R www-data:www-data html

#COPY --chown=www-data:www-data src .
COPY parameters.php ./app/config/parameters.php

#SSL
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt -subj "/C=PL/ST=Pomorskie/L=Gdansk/O=efilmy/OU=efilmy/CN=efilmy.best/emailAddress=belektroniczny@gmail.com"

COPY ssl-params.conf /etc/apache2/conf-available/
COPY default-ssl.conf /etc/apache2/sites-available/
COPY 000-default.conf /etc/apache2/sites-available/

RUN a2enmod ssl
RUN a2ensite default-ssl

#Removing initial presta data
RUN rm -r admin
RUN rm -r install 
