# mariadb-docker
Docker image for mariadb based on ubuntu bionic

## Environment
To add database, you just simple run this command
```
--env MYSQL_ROOTPW RootPWDatabase100@
--env MYSQL_DB wordpress
--env MYSQL_USER userDB
--env MYSQL_USER_PW userDBPass100@
or
-e MYSQL_ROOTPW RootPWDatabase100@
-e MYSQL_DB wordpress
-e MYSQL_USER userDB
-e MYSQL_USER_PW userDBPass100@
```