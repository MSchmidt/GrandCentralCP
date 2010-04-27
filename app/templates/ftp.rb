
#add user
system("useradd -g ftpuser -d /var/www/user1 -s /bin/ftp -m user1")
system("passwd user1")

#permission
system("chown user1.www-data /var/www/user1")
system("chmod 750 /var/www/user1")

#domain,directory,permission
system("mkdir -p /var/www/user1/domain1.de/{cgi-bin,html,temp}")
system("chmod 770 /var/www/user1/domain1.de/temp")
system("chown -R user1.ftpuser /var/www/user1/*")


__END__
4. Schritt: Default-vHost in /etc/apache/vhosts.conf
konsole:~# echo "Include /etc/apache/vhosts.conf" >> /etc/apache/httpd.conf
konsole:~# touch /etc/apache/vhosts.conf

Dann, ganz wichtig, in der ersten Zeile eintragen:
NameVirtualHost 190.xxx.yyy.zzz
damit der Apache weiss, dass mehrere virtuelle Domains auf derselben IP laufen.

<VirtualHost 190.xxx.yyy.zzz>
ServerName 190.xxx.yyy.zzz
DocumentRoot /var/www/nirvana
</VirtualHost>
<Location /cgi-bin>
AllowOverride None
Options +ExecCGI -Includes
SetHandler cgi-script
</Location>
konsole:~# mkdir /var/www/nirvana
konsole:~# chown root.www-data /var/www/nirvana/
konsole:~# chmod 750 /var/www/nirvana/
konsole:~# echo "<HTML><HEAD><TITLE>closed</TITLE>" >> /var/www/nirvana/index.html"
konsole:~# echo "<BODY><H2>This Domain does not exist.</H2>" >> /var/www/nirvana/index.html
konsole:~# echo "</BODY></HTML>" >> /var/www/nirvana/index.html

5. Schritt: vHost für Domain incl. CGI, abgesicherter PHP-Umgebung und Logfiles
<VirtualHost 190.xxx.yyy.zzz>
ServerName domain1.de
ServerAlias www.domain1.de
User user1
Group ftpuser
DocumentRoot /var/www/user1/domain1.de/html
ScriptAlias /cgi-bin /var/www/user1/domain1.de/cgi-bin
php_admin_value open_basedir /var/www/user1/domain1.de/
php_admin_value upload_tmp_dir /var/www/user1/domain1.de/temp
php_admin_value session.save_path /var/www/user1/domain1.de/temp/
php_admin_value safe_mode on
CustomLog /var/log/apache/domain1.de.log combined
</VirtualHost>
