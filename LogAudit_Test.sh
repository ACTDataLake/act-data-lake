# ===============================================================================================================================
# Descriptiopn : Script to enable auditing and expand audit logs 
# Author       : Selvaraaju Murugesan
# Date         : 18/09/2017
# Authorsed by :
# Last Modified:
# Audi Log     :
# ===============================================================================================================================


#Some basic information about the cluster
clear

#create expandaudit directory and set permissions
hadoop fs -mkdir /myexpandedauditlogs
hadoop fs -chgrp domain_users /myexpandedauditlogs
hadoop fs -chmod 755 /myexpandedauditlogs

#Auditing on
hadoop mfs -setaudit on /Data/CMTEDD
hadoop mfs -setaudit on /Data/TCCS

#Expand audits for few volumens
/opt/mapr/bin/expandaudit -cluster mapr.test.act.gov.au -volumename CMTEDD -o /mapr/mapr.test.act.gov.au/myexpandedauditlogs/
/opt/mapr/bin/expandaudit -cluster mapr.test.act.gov.au -volumename TCCS -o /mapr/mapr.test.act.gov.au/myexpandedauditlogs/

echo 'Audit logs expanded for the volumes'

