FROM ubuntu:16.04
MAINTAINER Julien Leroy

RUN apt-get -y update && apt-get install -y \
    python \
    nginx \
    python-pip \
    python-mysqldb \
    supervisor

RUN pip install django uwsgi && mkdir -p /run/uwsgi && chown root:root /run/uwsgi


COPY . /root/
RUN cd /root && python manage.py collectstatic --noinput
RUN mv /root/static /run/uwsgi/ && mv /root/radial.conf /etc/nginx/conf.d/radial.conf && mv /root/supervisor-app.conf /etc/supervisor/conf.d/supervisor-app.conf && rm -R /etc/nginx/sites-available && rm -R /etc/nginx/sites-enabled
EXPOSE 82 82
CMD ["supervisord", "-n"]
