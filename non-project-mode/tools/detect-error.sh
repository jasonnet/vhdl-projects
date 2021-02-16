EXIT_CODE=0

while read readline
do
	if [[ "$readline" == "Error: "* ]] ; then
		echo "$readline"
		EXIT_CODE=1
	elif [[ "$readline" == "ERROR: "* ]] ; then
		echo "$readline"
		EXIT_CODE=1
	elif [[ "$readline" == "FATAL_ERROR: "* ]] ; then
		echo "$readline"
		EXIT_CODE=1
	elif [[ "$readline" == "Failure: "* ]] ; then
		echo "$readline"
		EXIT_CODE=1
	elif [[ "$readline" == "\$finish called at "* ]] ; then
	    if [ $EXIT_CODE = 1 ] ; then
			echo "$readline"
		else
			#echo "readline"    don't show this message if the script intentionally terminates without an error
			:  # no-op
		fi
	else
		echo "$readline"
	fi
done

exit $EXIT_CODE
