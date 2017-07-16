#!/bin/bash
# LICENSE CDDL 1.0 + GPL 2.0
#
# Copyright (c) 1982-2017 Oracle and/or its affiliates. All rights reserved.
#
# Since: May, 2017
# Author: srinivasa.x.reddy@oracle.com
# Description: Checks the status of Oracle Database.
#              The ORACLE_HOME, ORACLE_SID and the PATH has to be set.
# 
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
# 

# Check that ORACLE_HOME is set
if [ "$ORACLE_HOME" == "" ]; then
  script_name=`basename "$0"`
  echo "$script_name: ERROR - ORACLE_HOME is not set. Please set ORACLE_HOME and PATH before invoking this script."
  exit 3;
fi;

# Check that ORACLE_SID is set
if [ "$ORACLE_SID" == "" ]; then
  script_name=`basename "$0"`
  echo "$script_name: ERROR - ORACLE_SID is not set. Please set ORACLE_SID before invoking this script."
  exit 3;
fi;

# Create DB Schema
status=`sqlplus -s / as sysdba << EOF
   set heading off;
   set pagesize 0;
    alter session set container=DOCKERPDB1;

create tablespace FCUBS125 datafile '/opt/oracle/oradata/DOCKERDB/DOCKERPDB1/fcubs125_01.dbf' size 50m autoextend on maxsize 10000m extent management local uniform size 128K;

create user FCUBS125 identified by FCUBS125 default tablespace FCUBS125 temporary tablespace temp quota unlimited on FCUBS125;

grant select on v_$instance to FCUBS125;
grant EXECUTE on DBMS_AQ to FCUBS125;
grant EXECUTE ON DBMS_SHARED_POOL to FCUBS125;
grant execute on dbms_sql to FCUBS125;
grant execute on dbms_lock to FCUBS125;
grant execute on dbms_defer_query to FCUBS125;
grant execute on dbms_defer to FCUBS125;
grant execute on dbms_defer_sys to FCUBS125;
grant execute on dbms_job to FCUBS125;
grant execute on dbms_alert to FCUBS125;
grant execute on dbms_refresh to FCUBS125;
grant execute on dbms_pipe to FCUBS125;
grant execute on dbms_shared_pool to FCUBS125;
grant execute on dbms_application_info to FCUBS125;
grant execute on utl_file to FCUBS125;
grant select on v_$process to FCUBS125;
grant select on v_$session to FCUBS125;
grant select on v_$timer to FCUBS125;
grant select on v_$database to FCUBS125;
grant select on v_$parameter to FCUBS125;
grant select on v_$nls_parameters to FCUBS125;
grant select on dba_jobs_running to FCUBS125;
grant create session to FCUBS125;
grant create synonym to FCUBS125;
grant create view to FCUBS125;
grant create sequence to FCUBS125;
grant create table to FCUBS125;
grant create procedure to FCUBS125;
grant create trigger  to FCUBS125;
grant create type to FCUBS125;
grant create library to FCUBS125;
grant create database link to FCUBS125;
grant create any synonym to FCUBS125;
grant select any table to FCUBS125;
grant select on v_$timer to FCUBS125;
grant execute on dbms_lock to FCUBS125;
grant execute on dbms_alert to FCUBS125;
grant select on dba_jobs to FCUBS125;
grant select on dba_jobs_running to FCUBS125;
grant select on dba_users to FCUBS125;
grant execute on DBMS_DEFER to FCUBS125;
grant execute on dbms_defer_query to FCUBS125;
grant select on v_$process to FCUBS125;
grant select on v_$session to FCUBS125;
grant create any type to FCUBS125;
grant execute ON DBMS_AQADM to FCUBS125;
grant execute ON DBMS_AQ to FCUBS125;
grant execute on utl_recomp to FCUBS125;
grant select on v_$locked_object to FCUBS125;
grant execute on KILL_SESSION to FCUBS125;
grant select_catalog_role to FCUBS125 ;
grant select_catalog_role to FCUBS125;
grant select_catalog_role to FCUBS125;
grant execute on DBMS_CRYPTO to FCUBS125;
grant execute ON DBMS_AQADM to FCUBS125;
grant imp_FULL_DATABASE to FCUBS125 ;
grant exp_FULL_DATABASE to FCUBS125 ;

conn FCUBS125/FCUBS125@DOCKERPDB1;
create table test_me(userid varchar2(10));
insert into test_me values('Srini');
commit;

   exit;
EOF`

# Store return code from SQL*Plus
ret=$?

# SQL Plus execution was successful and database is open
if [ $ret -eq 0 ]; then
   exit 0;
else
   exit 1;
fi;
