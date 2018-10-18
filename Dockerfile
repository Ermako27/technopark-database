
FROM ubuntu:16.04

MAINTAINER Ermakov Maxim

# Обвновление списка пакетов
RUN apt-get -y update

#
# Установка postgresql
#
ENV PGVER 10.5
RUN apt-get install -y postgresql-$PGVER

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-$PGVER`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker1828';" &&\
    createdb -O docker docker &&\
    /etc/init.d/postgresql stop

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/$PGVER/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/$PGVER/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/$PGVER/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Back to the root user
USER root

#
# Сборка проекта
#

# Установка golang
RUN apt install -y golang-1.11 git

# Выставляем переменную окружения для сборки проекта
ENV GOROOT /usr/lib/go-1.11
ENV GOPATH /opt/go
ENV PATH $GOROOT/bin:$GOPATH/bin:/usr/local/go/bin:$PATH

# Копируем исходный код в Docker-контейнер
WORKDIR $GOPATH/src/github.com/Ermako27/technopark-db
COPY . .
RUN go get ./...
RUN go build

CMD /etc/init.d/postgresql start && \
    sleep 10 && \
    ./technopark-db --scheme=http --port=5000 --host=0.0.0.0 --database=postgres://docker:docker@localhost/docker