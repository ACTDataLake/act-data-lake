CREATE DATABASE ${hiveconf:DB_NAME} LOCATION '/Data/TCCS/TimeTabl_DB.db'; 
use ${hiveconf:DB_NAME};
CREATE EXTERNAL TABLE ${hiveconf:DB_NAME}.${hiveconf:TABLE_NAME}(busname STRING,busid int) PARTITIONED BY(suburb STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' STORED AS TEXTFILE LOCATION '/Data/TCCS/TimeTable/TimeTable_Bus' TBLPROPERTIES ("skip.header.line.count"="1");
LOAD DATA LOCAL INPATH '/home/test.act.gov.au/1958783770/TestScripts/Busdata_CBR.txt' INTO TABLE ${hiveconf:TABLE_NAME} PARTITION(suburb='CBR');
LOAD DATA LOCAL INPATH '/home/test.act.gov.au/1958783770/TestScripts/Busdata_BEL.txt' INTO TABLE ${hiveconf:TABLE_NAME} PARTITION(suburb='BEL');
LOAD DATA LOCAL INPATH '/home/test.act.gov.au/1958783770/TestScripts/Busdata_WDN.txt' INTO TABLE ${hiveconf:TABLE_NAME} PARTITION(suburb='WDN');
