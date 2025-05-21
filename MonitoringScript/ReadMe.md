*What the script does
	-script monitors following things:
		1. local user accounts(input from csv) | Alert if user is disabled
		2. storage | Alert if available storage is less than 20%
		3. services(input from csv) | Alert if service is not in Running state

*How it’s scheduled
	-script is schduled using task scheduler

*How logs are stored
	-Log file will be created with followin format "monitoring$(Get-Date -Format ddMMyyyy)$(Get-Date -Format HHmm).log"
	-Log file will be generated only if ALERT or Error is occured.
		(sample log file is present in git dir)