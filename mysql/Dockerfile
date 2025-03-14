ARG MYSQL_VERSION
FROM mysql:${MYSQL_VERSION}

ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && chown -R mysql:root /var/lib/mysql/

COPY mysql/my.cnf /etc/mysql/conf.d/my.cnf
COPY mysql/my.cnf /etc/mysql/mysql.conf.d/my.cnf
COPY mysql/my.cnf /etc/mysql/my.cnf

RUN chmod 0444 /etc/mysql/conf.d/my.cnf
RUN chmod 0444 /etc/mysql/mysql.conf.d/my.cnf
RUN chmod 0444 /etc/mysql/my.cnf
