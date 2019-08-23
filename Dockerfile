FROM tiangolo/uwsgi-nginx:python3.6-alpine3.8
MAINTAINER Li Qiaowei <troyzzz01@gmail.com>

ADD . /opt/django/

# install base requirements and remove unnecessary pip cache, can also use -no-cache-dir option of pip install
RUN apk add --no-cache --virtual .build-deps \
        gcc \
        openssl-dev \
        libffi-dev \
        linux-headers \
        musl-dev \
&& pip install --upgrade pip -r /opt/django/app/requirements.txt \
&& rm -rf ~/.cache/pip \
&& apk del .build-deps

# set configs for nginx, supervisord and remove the origin supervisord.ini
RUN ln -s /opt/django/django_nginx.conf /etc/nginx/conf.d/ \
&& ln -s /opt/django/django_supervisord.ini /etc/supervisor.d/ \
&& rm /etc/supervisor.d/supervisord.ini

VOLUME ["/opt/django/app"]
WORKDIR /opt/django/app
EXPOSE 80

RUN chmod +x /opt/django/start.sh

CMD ["/opt/django/start.sh"]