FROM mysql:latest
COPY ./BucketList.sql /docker-entrypoint-initdb.d
EXPOSE 3306
ENV MYSQL_ROOT_PASSWORD=root