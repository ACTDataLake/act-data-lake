use ${hiveconf:DB_NAME};
drop view view_crash;
drop table ${hiveconf:DB_NAME}.${hiveconf:TABLE_NAME};
drop database ${hiveconf:DB_NAME};
