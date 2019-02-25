FROM ubuntu:bionic
LABEL maintainer="Bayu Adin H <bayu.adin.h@mail.ugm.ac.id>"
LABEL description="Redis with latest Alphine"

ENV MYSQL_ROOTPW RootBlibli100@
ENV MYSQL_DB wordpress
ENV MYSQL_USER blibli
ENV MYSQL_USER_PW UserBlibli100@

RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN apt-get -y update && \
	apt-get remove --purge mariadb-server mariadb-client && \
	apt-get autoremove && \
	apt-get autoclean && \
	apt-get install -y mariadb-server mariadb-client && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
	
RUN sed -ri 's/^user\s/#&/' /etc/mysql/my.cnf /etc/mysql/conf.d/* && \
	rm -rf /var/lib/mysql && \
	mkdir -p /var/lib/mysql /var/run/mysqld && \
	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
	chmod 777 /var/run/mysqld && \
	find /etc/mysql/ -name '*.cnf' -print0 \
		| xargs -0 grep -lZE '^(bind-address|log)' \
		| xargs -rt -0 sed -Ei 's/^(bind-address|log)/#&/'; \
	echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf

VOLUME ["/etc/mysql", "/var/lib/mysql"]

COPY starter.sh /starter.sh

EXPOSE 3306
ENTRYPOINT ["sh", "/starter.sh"]