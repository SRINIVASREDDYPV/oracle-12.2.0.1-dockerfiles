#!/bin/bash
# LICENSE CDDL 1.0 + GPL 2.0
#
# Copyright (c) 1982-2016 Oracle and/or its affiliates. All rights reserved.
# 
# Since: November, 2016
# Author: srinivasa.x.reddy@oracle.com
# Description: Runs the Oracle Database inside the container
# 
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
# 


# Default for ORACLE DB
export ORACLE_SID=${ORACLE_SID:-DOCKERDB}

# Default for ORACLE PDB
export ORACLE_PDB=${ORACLE_PDB:-DOCKERPDB1}

# Default for ORACLE CHARACTERSET
export ORACLE_CHARACTERSET=${ORACLE_CHARACTERSET:-AL32UTF8}

# Check whether database already exists
if [ -d $ORACLE_BASE/oradata/$ORACLE_SID ]; then
   echo "#########################"
   echo "DATABASE IS ALREADY INSTALLED.STARTING THE DATABASE."
   echo "#########################"
   # Start database
   $ORACLE_BASE/$START_FILE;

   # Check whether database is up and running
	$ORACLE_BASE/$CHECK_DB_FILE
	if [ $? -eq 0 ]; then
   	echo "#########################"
   	echo "DATABASE IS READY TO USE!"
   	echo "#########################"
       fi;


	# Tail on alert log and wait (otherwise container will exit)
	echo "The following output is now a tail of the alert.log:"
	tail -f $ORACLE_BASE/diag/rdbms/*/*/trace/alert*.log &
	childPID=$!
	wait $childPID

   
else
   echo "#########################"
   echo "COULD NOT START DATABASE BECAUSE DATABASE IS NOT INSTALLED."
   echo "#########################"
fi;
