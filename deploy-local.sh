#!/bin/bash
# DSpace deploy script

#DSpace source
DSPACE_SOURCE='/home/milos/IdeaProjects/BE-OPEN/'
#Dspace install
DSPACE_INSTALL='/home/milos/dspace/'
#Tomcat
TOMCAT='/home/milos/tomcat/'

#Build projekta
cd $DSPACE_SOURCE
mvn clean package

#Zaustavljanje tomcat servisa
#systemctl stop tomcat

#Ant build
cd dspace/target/dspace-installer/
ant update clean_backups

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
