FROM debian:stable-slim
LABEL "vendor"="fernando menjivar"
LABEL "maintainer"="devfernando95@gmail.com"
ENV REPOSITORY="https://github.com/diseno2021/expedientemedico.git"
# Update repository
RUN apt-get update && apt-get upgrade -y &&\
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --no-install-suggests -y &&\
    apt install nginx -y &&\
    apt install curl -y &&\ 
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash - &&\ 
    apt install -y nodejs -y  &&\
    apt install git ca-certificates -y &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/

WORKDIR /home

RUN git clone ${REPOSITORY} &&\
        cd expedientemedico &&\
        git pull origin &&\
        git checkout v1.0 &&\ 
        npm install &&\
        npx quasar build &&\
        rm /var/www/html/index.nginx-debian.html &&\
        cp -r dist/spa/* /var/www/html &&\
        cd ../ &&\
        rm -r expedientemedico &&\
        echo "\ndaemon off;" >> /etc/nginx/nginx.conf

COPY ./default.conf /etc/nginx/conf.d/default.conf

EXPOSE 81 80

STOPSIGNAL SIGQUIT

CMD ["/usr/sbin/nginx"]