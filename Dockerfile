FROM mysql

ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_DATABASE=ghex
ENV MYSQL_USER=dev
ENV MYSQL_PASSWORD=dev

COPY docker/mysql /docker-entrypoint-initdb.d/
