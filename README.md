torchcc/docker-drf:py3.6-alpine3.8 
==================

docker image for django (uwsgi) & nginx & supervisord
based on tiangolo/uwsgi-nginx:python3.6-alpine3.8 


## files required 
-  Dockerfile, supervisord.ini, django_nginx.conf, uwsgi.ini
    - app: the dir where manage.py locates. it is used for mounting using docker syntax like `-v dira: dirb` 
    - django_nginx.conf: the nignx configuration of your app
    - django_supervisord.ini: the supervisord configuration
    - app/requirements.txt: the requirements installed when building the image
    - start.sh: the scripts executed when starting a container
    
## tips

1. Shell scripts in Alpine starts with  `#! /bin/sh` as the first line
2. if it fails to install new requirements.txt in alpine, pls use \
  `apk add --no-cache --virtual .build-deps gcc ... ... `  and to install the basic package needed and then install \
  your new requirements.txt and then `apk del .build-deps` to delete the dir \
  to save space as demonstrated in the Dockerfile
3. here is the link to the base image: https://github.com/tiangolo/uwsgi-nginx-docker/tree/master/python3.6-alpine3.8
4. The logs of nginx and uwsgi locate in /tmp
5. The port to which the nginx listen is 80 as is set in django_nginx.conf

## usage
- To build an image from Dockerfile \
 `docker build -t torchcc/docker-drf:py3.6-alpine3.8 . `

- To pull this image: \
  `docker pull torchcc/docker-drf:py3.6-alpine3.8`

- To Deploy your own project: \
`docker run --name myapp-con -d -e MODULE=myapp_api -v /home/myapp:/opt/django/app -p ::80  torchcc/docker-drf:py3.6-alpine3.8`
    - MODULE：the package name where the `settings.py` lies
    
- To start a testing project. It runs a default 'welcome to django' project. \
 `docker run --name myapp-con -d  -p ::80  torchcc/docker-drf:py3.6-alpine3.8`
    
- To run a shell script before starting supervisord, you could write a script named `prestart.sh` and put it in \ 
the same directory as `manage.py` and do something inside.
```
#! /bin/sh

pip install --upgrade pip -r /opt/django/app/my_requirements.txt
pip install requests
rm -rf ~/.cache/pip 
```



    
