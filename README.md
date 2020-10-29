# SOCtopus
Flask API to assist with automating SOC functions from Security Onion

Clone the repo:   

`git clone https://github.com/NRDCS/soctopus`

Change into directory:   
`cd SOCtopus`

Edit the config file to include your URL and API key:

`sudo vi SOCtopus.conf`

Install docker-composer:

``sudo apt install docker-compose``

Build the image:

``sudo docker-compose build``

Rename the docker
``sudo docker ps``
``sudo docker rename soctopus_soctopus soctopus``

Start the container:

``sudo docker run -d -p 127.0.0.1:7000:7000/tcp soctopus_soctopus``

Add the docker to the SO network
`sudo docker network connect so-elastic-net soctopus`

Add the following to `/etc/apache2/sites-available/securityonion.conf`:

````
<Location /soctopus>
	AuthType form
	AuthName "Security Onion"
	AuthFormProvider external
	AuthExternal so-apache-auth-sguil
	Session On
	SessionCookieName session path=/;httponly;secure;
	SessionCryptoPassphraseFile /etc/apache2/session
	ErrorDocument 401 /login.html
	Require valid-user
	ProxyPass http://127.0.0.1:7000
	ProxyPassReverse http://127.0.0.1:7000
</Location>

````

Restart Apache:

`sudo service apache2 restart`


Add scripted field in Kibana. For example, for TheHive, name it `TheHive`, specifying as a string value and the script as:

`'https://SECURITYONIONIP/soctopus/thehive/alert/' + doc['_id'].value`


Test by clicking the hyperlinked field from an applicable log in Discover.  An alert should be sent to TheHive, and the user should be redirected to the alerts view.

For RTIR:
``'https://SECURITYONIONIP/soctopus/rtir/incident/' + doc['_id'].value``
