 #  Generated by Cadence Encounter(r) RTL Compiler v14.10-s005_1
 #---------------------------------------------------------------------------------  
 #                   CheckTSVlog - checks TSV log to look for conditions  
 #                                 that might require special options for ATPG  
 #---------------------------------------------------------------------------------  
 CheckTSVlog ()  
 {  
   
   CONTINUE_WITH_SEVERE="no"  
   err=0
   
   lf="$1"  
   echo " "  
   egrep "TSV-369|TSV-370|TSV-381|TSV-570" $lf | grep -v "^INFO"  
   TSV_error=`grep "WARNING (TSV-384)" $lf | grep -v "^WARNING" | tail -1 | awk -F " " '{print $1}' 2>/dev/null`  
   
   if [ -n "${TSV_error}" ] ; then  
     echo " "  
     echo "$TSV_error messages indicate the following scan chains are broken. "  
     echo " "  
     egrep "TSV-385|TSV-384" $lf   
     err=1  
   fi  
   
   TSV_errors=`egrep "TSV-320|TSV-321|TSV-322|TSV-325|TSV-327|TSV-329|TSV-330" $lf | grep "^ "`  
   if [ -n "${TSV_errors}" ] ; then  
     echo " "  
     echo "The follow TSV messages indicate problems with channel masking: "  
     echo " "  
     echo "$TSV_errors"  
     err=1  
   fi  
   
   TSV_errors=`egrep "TSV-324|TSV-342" $lf | grep "^ "`  
   if [ -n "${TSV_errors}" ] ; then  
     echo " "  
     echo "The follow TSV messages indicate problems with XOR compression: "  
     echo " "  
     echo "$TSV_errors"  
     err=1  
   fi  
   
   TSV_errors=`egrep "TSV-132" $lf | grep "^ "`  
   if [ -n "${TSV_errors}" ] ; then  
     echo " "  
     echo "The following TSV messages indicate problems with OPCG insertion: "  
     echo " "  
     echo "$TSV_errors"  
     err=1  
   fi  
   
   TSV_errors=`egrep "TSV-105|TSV-106|TSV-173|TSV-175|TSV-182|TSV-183|TSV-185|TSV-186|TSV-187|TSV-189|TSV-201|TSV-203|TSV-204|TSV-206|TSV-208|TSV-209|TSV-212|TSV-213|TSV-214|TSV-217|TSV-219|TSV-220|TSV-221|TSV-223|TSV-224|TSV-225|TSV-228|TSV-239|TSV-290|TSV-291|TSV-292|TSV-293|TSV-294|TSV-295|TSV-391" $lf | grep "^ "`  
   if [ -n "${TSV_errors}" ] ; then  
     echo " "  
     echo "The follow TSV messages indicate problems with MISR compression: "  
     echo " "  
     echo "$TSV_errors"  
     err=1  
   fi  
   
   if [ $err -eq 1 ] ; then  
     if [ $CONTINUE_WITH_SEVERE = "yes" ] ; then  
       echo " "  
       echo "Setup file specifies CONTINUE_WITH_SEVERE=yes."  
       echo "Continuing. Please review details in log file:"  
       echo "  $lf "  
     else  
       echo " "  
       echo "Exiting. Please review details in log file:"  
       echo "  $lf "  
       echo " "  
       exit  
     fi  
   fi  
   
   # Check for contention issues and set contentionreport appropriately.  
   #  
   TSV_error=`egrep "TSV-093|TSV-193" $lf | grep "^WARNING" | tail -1 | awk -F " " '{print $1}' 2>/dev/null`  
   if [ -n "${TSV_error}" ] ; then  
     echo " "  
     echo "$TSV_error messages indicate possible contention (soft or hard).   "  
     echo "ATPG will continue using contentionreport=hard to ignore potential "  
     echo "soft contention due to black box outputs or other X-sources.       "  
     echo "If this is not desired, set contentionreport=soft in ATPG.         "  
     echo "Please review details in log file:                                 "  
     echo "  $lf "  
     echo " "  
     if [ -n "${CONTENTION}" ] ; then  
       # do nothing  
       z=1  
     else  
       CONTENTION=hard  
       MULTICLOCK=yes  
       export CONTENTION MULTICLOCK  
     fi  
   fi  
   
   # Check for clock chopper issues and simulate choppers risky if necessary.  
   #  
   TSV_error=`egrep "TSV-021|TSV-025|TSV-029|TSV-037|TSV-038|TSV-039|TSV-044|TSV-045|TSV-046" $lf | grep "^WARNING" | tail -1 | awk -F " " '{print $1}' 2>/dev/null`  
   if [ -n "${TSV_error}" ] ; then  
     echo " "  
     echo "$TSV_error messages indicate possible invalid clock shapers (choppers)."  
     echo "ATPG will continue using choppers=risky to simulate them for highest   "  
     echo "coverage.  If this is not desired, set choppers=safe in ATPG           "  
     echo "Please review details in log file:                                     "  
     echo "  $lf "  
     echo " "  
     if [ -n "${CHOPPERS}" ] ; then  
       # do nothing  
       z=1  
     else  
       CHOPPERS=risky  
       export CHOPPERS  
     fi  
   fi  
   
   # Check for keeper issues and simulate keepers risky if necessary.  
   #  
   TSV_error=`egrep "TSV-034|TSV-035" $lf | grep "^WARNING" | tail -1 | awk -F " " '{print $1}' 2>/dev/null`  
   if [ -n "${TSV_error}" ] ; then  
     echo " "  
     echo "$TSV_error messages indicate possible invalid keeper devices."  
     echo "ATPG will continue using keepers=risky to simulate them for highest   "  
     echo "coverage.  If this is not desired, set keepers=safe in ATPG           "  
     echo "Please review details in log file:                                     "  
     echo "  $lf "  
     echo " "  
     if [ -n "${KEEPERS}" ] ; then  
       # do nothing  
       z=1  
     else  
       KEEPERS=risky  
       export KEEPERS  
     fi  
   fi  
   
   # Check for infinitex issues and set infinitex=none if necessary.  
   #  
   TSV_error=`egrep "TSV-059|TSV-310|TSV-008" $lf | grep "^WARNING" | tail -1 | awk -F " " '{print $1}' 2>/dev/null`  
   if [ -n "${TSV_error}" ] ; then  
     echo " "  
     echo "$TSV_error messages indicate design guideline violations.              "  
     echo "ATPG will continue using infinitex=none to simulate for highest        "  
     echo "coverage.  If this is not desired, set infinitex appropriately in ATPG "  
     echo "Please review details in log file:                                     "  
     echo "  $lf "  
     echo " "  
     if [ -n "${INFINITEX}" ] ; then  
       # do nothing  
       z=1  
     else  
       INFINITEX=none  
       export INFINITEX  
     fi  
   fi  
   
   if [ $err -eq 0 ] ; then  
     echo "Step completed successfully. Continuing.."  
   fi
 }  
   
   
 #----------------------------------------------------------------------------------  
 #           CheckLogs:      Check Return Code from the Logs  
 #----------------------------------------------------------------------------------  
 CheckLogs ()  
 {  
   rcode="$1"  
   logdir="$WORKDIR/testresults/logs"  
   logfile="$2"  
   step=$2  
   CONTINUE_WITH_SEVERE="no"  
   #echo "Application returned code $rcode in $logdir/$logfile"  
   
   echo " "  
   echo "Checking log $logfile ..."  
   if [ -f "$logdir/$logfile" ] ; then  
     msg1="`grep TFW-060 $logdir/$logfile`"  
     msg2="`grep TTC_111 $logdir/$logfile`"  
     msg3=$(egrep "TFA_090|TFA_091" $logdir/$logfile)  
   else  
     echo " "  
     echo "Logfile $logdir/$logfile not found. Please check if the command was exectued/existence of WORKDIR/disk space."  
     echo " "  
     exit  
   fi  
   
   if [ -n "$msg1" ] ; then  
     echo " "  
     echo "ERROR - The following message was issued that is considered fatal"  
     echo "$msg1"  
     echo "Please check the file system space"  
     rcode=5  
   fi  
   
   if [ -n "$msg2" ] ; then  
     echo " "  
     echo "ERROR - The following message indicates there are no faults left to test in the test mode"  
     echo "$msg2"  
     echo "Exiting. Subsequent steps will fail. Please review details in the log file: "  
     echo "$logdir/$logfile"  
     exit  
   fi  
   
   if [ -n "$msg3" ] ; then  
     echo " "  
     echo "ERROR - The following message indicates that there are no testpoints to be inserted"  
     echo "$msg3"  
     echo "Exiting."  
     exit  
   fi  
   
   if [ $rcode -gt 4 ] ; then  
     echo " "  
     echo "Return code $rcode. The following ERRORs occurred:"  
     messages=`egrep "ERROR \(" $logdir/$logfile | grep -v "^ERROR"`  
     echo "$messages"  
     echo "Exiting. Please review details in log file: "  
     echo "$logdir/$logfile"  
     exit  
   fi  
   
   if [ ${logfile#log_create} != $logfile ] ; then  
     CONTINUE_WITH_SEVERE="yes"  
   fi  
   
   if [ ${logfile#log_analyze} != $logfile ] ; then  
     CONTINUE_WITH_SEVERE="yes"  
   fi  
   
   if [ ${logfile#log_verify_test_structures} != $logfile ] ; then  
     CheckTSVlog "$logdir/$logfile"  
   elif [ $rcode -lt 2 ] ; then 
     echo "Step completed successfully. Continuing.."  
   elif [ $rcode -lt 4 ] ; then  
       echo "Return code $rcode. The following WARNINGs occurred:"  
       messages=`egrep "WARNING \(" $logdir/$logfile | grep -v "^WARNING"`  
       echo "$messages"  
       echo "Continuing. Please review details in log file: "  
       echo "$logdir/$logfile"  
   elif [ $rcode -eq 4 ] ; then  
       echo "Return code $rcode. The following SEVERE WARNINGs occurred:"  
       messages=`egrep "WARNING \(" $logdir/$logfile | grep -v "^WARNING" | grep "[Severe]"`  
       echo "$messages"  
       messages_not_exempted=`egrep "WARNING \(" $logdir/$logfile | grep -v "^WARNING" | grep "[Severe]" | egrep -v "TTM-"`  
       if [ $CONTINUE_WITH_SEVERE = "no" -a -n "$messages_not_exempted" ] ; then  
         echo "Exiting. Please review details in log file: "  
         echo "$logdir/$logfile"  
         exit  
       else  
         echo "Continuing. Please review details in log file: "  
         echo "$logdir/$logfile"  
       fi  
   fi  
 }  
