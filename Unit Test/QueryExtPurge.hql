use ${hiveconf:DB_NAME};
alter table timetabel.timetabel_bus drop partition (suburb='BEL');
