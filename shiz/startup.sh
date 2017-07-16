/fixuser.sh mysql
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql
if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	su mysql -c /usr/sbin/mysqld &
	sleep 5
	mysql -u root < /create
	mysql --user ttrss --password=ttrss ttrss < /usr/share/webapps/tt-rss/schema/ttrss_schema_mysql.sql
else
	su mysql -c /usr/sbin/mysqld &
fi
php-fpm
nginx
sleep 3
while true
do
	su -s /bin/bash http -c '/usr/bin/php /usr/share/webapps/tt-rss/update.php --daemon'
	sleep 60
done
