#! /bin/sh

set -e

# If there's a prestart.sh script in the /opt/django/app directory, run it before starting
PRE_START_PATH=/opt/django/app/prestart.sh
echo "Checking for script in $PRE_START_PATH"
if [ -f $PRE_START_PATH ] ; then
    echo "Running script $PRE_START_PATH"
    . $PRE_START_PATH
else
    echo "There is no script $PRE_START_PATH"
fi

MODULE=${MODULE:-website}

sed -i "s#module=website.wsgi:application#module=${MODULE}.wsgi:application#g" /opt/django/uwsgi.ini

if [ ! -f "/opt/django/app/manage.py" ]
then
	echo "creating basic django project (module: ${MODULE})"
	django-admin.py startproject ${MODULE} /opt/django/app/
fi

mv /etc/nginx/conf.d/django_nginx.conf /etc/nginx/conf.d/nginx.conf
exec /usr/bin/supervisord
