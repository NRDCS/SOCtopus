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

Start the container:

``sudo docker ps``
``sudo docker run -d -p 127.0.0.1:7000:7000/tcp soctopus_soctopus``
``sudo docker ps``

After RC edit of docker-compose.yaml file, docker starts with :

``docker run -d --name soctopus -p 127.0.0.1:7000:7000/tcp soctopus``

If docker image is running, rename the docker:
``sudo docker rename <random name> soctopus``
``sudo docker ps``

Now docker ps command will display docker name as "soctopus".

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

For this docker integration with Kibana management, to start and stop together both dockers, add following to Kinana start script:

````
				echo "Configuring Kibana, please wait..."
                                /usr/sbin/so-elastic-configure-kibana > /dev/null 2>&1
                        fi
                         echo "Starting Kibana - RTIR integration !"
                         docker rm soctopus >/dev/null 2>&1
                         sleep  2
                         docker run -d --name soctopus -p 127.0.0.1:7000:7000/tcp soctopus
                         docker network connect so-elastic-net soctopus
                fi
        fi
fi 

````
