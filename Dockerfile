FROM ubuntu:16.04

RUN apt-get update -q && \
    apt-get install -q -y git golang-go postgresql postgresql-contrib

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin"


USER postgres
RUN /etc/init.d/postgresql start && \
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker1828';" && \
    createdb -O docker docker && \
    /etc/init.d/postgresql stop

USER root
WORKDIR /go/src/github.com/Ermako27/technopark-database
COPY . .
RUN go get github.com/Ermako27/technopark-database/api/user
RUN go get github.com/Ermako27/technopark-database/dbutils
RUN go get github.com/Ermako27/gorilla/mux
RUN go get github.com/Ermako27/technopark-database/jsonutils
RUN go get github.com/Ermako27/technopark-database/api
RUN go build

EXPOSE 5000
CMD /etc/init.d/postgresql start && \
    sleep 10 && \
    ./technopark-database