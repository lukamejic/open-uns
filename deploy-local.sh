#!/bin/bash
# DSpace deploy script

#DSpace source
DSPACE_SOURCE='/home/milos/workspace/BE-OPEN/'
#Dspace install
DSPACE_INSTALL='/home/milos/dspace/'
#Tomcat
TOMCAT='/home/milos/programi/tomcat7/'

#Build projekta
cd $DSPACE_SOURCE
mvn clean package

#Zaustavljanje tomcat servisa
#systemctl stop tomcat

#Ant build
cd dspace/target/dspace-installer/
ant update clean_backups

#	TODO SKLONITI !!!!!
#Postavljanje podesavanja za mail
#echo 'Podesavanja za mail server ...'
#echo 'mail.extraproperties = mail.smtp.socketFactory.port=465, \' >> $DSPACE_INSTALL/config/dspace.cfg
#echo 'mail.smtp.socketFactory.class=javax.net.ssl.SSLSocketFactory, \' >> $DSPACE_INSTALL/config/dspace.cfg
#echo 'mail.smtp.socketFactory.fallback=false' >> $DSPACE_INSTALL/config/dspace.cfg

#	TODO Treba naci bolji nacin ...
#Podesavanje https redirekcije
#echo 'Podesavanja HTTPS redirekcije ...'
#sed -i '$ d' $DSPACE_INSTALL/webapps/jspui/WEB-INF/web.xml
#echo '<security-constraint>' >> $DSPACE_INSTALL/webapps/jspui/WEB-INF/web.xml
#echo '<web-resource-collection>' >> $DSPACE_INSTALL/webapps/jspui/WEB-INF/web.xml
#echo '<web-resource-name>Viewpoint Secure URLs</web-resource-name>' >> $DSPACE_INSTALL/webapps/jspui/WEB-INF/web.xml
#echo '<url-pattern>/*</url-pattern>' >> $DSPACE_INSTALL/webapps/jspui/WEB-INF/web.xml
#echo '</web-resource-collection>' >> $DSPACE_INSTALL/webapps/jspui/WEB-INF/web.xml
#echo '<user-data-constraint>' >> $DSPACE_INSTALL/webapps/jspui/WEB-INF/web.xml
#echo '<transport-guarantee>CONFIDENTIAL</transport-guarantee>' >> $DSPACE_INSTALL/webapps/jspui/WEB-INF/web.xml
#echo '</user-data-constraint>' >> $DSPACE_INSTALL/webapps/jspui/WEB-INF/web.xml
#echo '</security-constraint>' >> $DSPACE_INSTALL/webapps/jspui/WEB-INF/web.xml
#echo '</web-app>' >> $DSPACE_INSTALL/webapps/jspui/WEB-INF/web.xml

#Brisanje web aplikacije iz tomcat-a
echo 'Brisanje web aplikacije iz tomcat-a ...'
cd $TOMCAT/webapps/
#rm -rf oai/ rdf/ rest/ ROOT/ solr/ sword/ swordv2/
rm -rf jspui/ solr/

#Kopiranje web aplikacije iz dspace instalacionog foldera u tomcat
echo 'Kopiranje web aplikacije u tomcat ...'
cd $DSPACE_INSTALL/webapps
#cp -R jspui/ oai/ rdf/ rest/ solr/ sword/ swordv2/ $TOMCAT/webapps
cp -R jspui/ solr/ $TOMCAT/webapps

#Preimenovanje jspui u ROOT
#cd $TOMCAT/webapps
#mv jspui/ ROOT

#Startovanje tomcat-a
#echo 'Startovanje tomcat-a ...'
#systemctl start tomcat
