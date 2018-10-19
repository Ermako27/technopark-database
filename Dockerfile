
FROM ubuntu:16.04

MAINTAINER Ermakov Maxim

# Обвновление списка пакетов
RUN apt-get -y update

#
# Установка postgresql
#
RUN apt-get install -y postgresql postgresql-contrib

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-$PGVER`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker1828';" &&\
    createdb -O docker docker &&\
    /etc/init.d/postgresql stop

# Back to the root user
USER root

#
# Сборка проекта
#

# Установка golang
RUN apt install -y golang-go git

# Выставляем переменную окружения для сборки проекта
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin"
# Копируем исходный код в Docker-контейнер
WORKDIR $GOPATH/src/github.com/Ermako27/technopark-database
COPY . .
RUN go get ./...
RUN go build

CMD /etc/init.d/postgresql start && \
    sleep 10 && \
    ./technopark-database --scheme=http --port=5000 --host=0.0.0.0 --database=postgres://docker:docker@localhost/docker