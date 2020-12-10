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

``sudo docker-compose build -t cs-soctopus:latest .``

Start the container:

``sudo docker ps``
``sudo docker run -d --name cs-soctopus -p 7000:7000 cs-soctopus``
``sudo docker ps``

After RC edit of docker-compose.yaml file, docker starts with :

``docker run -d --name soctopus -p 127.0.0.1:7000:7000/tcp soctopus``

Now docker ps command will display docker name as "soctopus".

Add the docker to the SO network
`sudo docker network connect so-elastic-net cs-soctopus`

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
OR

````
                <Location /soctopus>
                        AuthType shibboleth
                        ShibRequireSession On
                        ShibRequestSetting requireSession 1
                        Require shib-attr memberOf 'CN=Admins,....DC=domain2,DC=lt'
                        SessionCookieName session path=/;httponly;secure;
                        SessionCryptoPassphraseFile /etc/apache2/session
                        ErrorDocument 401 /login.html
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

For this docker integration with Kibana management, to start and stop together both dockers, add following to Kibana start script:

````
				echo "Configuring Kibana, please wait..."
                                /usr/sbin/so-elastic-configure-kibana > /dev/null 2>&1
                        fi
                         echo "Starting Kibana - RTIR integration !"
                         docker rm cs-octopus >/dev/null 2>&1
                         sleep  2
                         docker run -d --name cs-octopus -p 127.0.0.1:7000:7000/tcp cs-octopus
                         docker network connect so-elastic-net cs-octopus
                fi
        fi
fi 

````

Kibana stop script : 

````
if [ "$KIBANA_ENABLED" = "yes" ] && docker ps | grep -q so-kibana; then
        docker stop so-kibana
        docker rm so-kibana >/dev/null 2>&1
        docker  stop cs-octopus
        docker rm cs-octopus >/dev/null 2>&1
fi

````
