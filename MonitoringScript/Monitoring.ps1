param(
$log_file="C:\Users\Administrator\powershell_scripts\MonitoringScript\monitoring$(Get-Date -Format ddMMyyyy)$(Get-Date -Format HHmm).log",
$user_csv="C:\Users\Administrator\powershell_scripts\MonitoringScript\users.csv",
$services_csv="C:\Users\Administrator\powershell_scripts\MonitoringScript\services.csv"
)
Function storage-alert{
    
    try{
        $drives=Get-Volume | where{$_.DriveLetter -ne $null} |select * -ErrorAction stop

        foreach($drive in $drives){
        
            $drive_letter=$drive.DriveLetter
            $size=$drive.Size
            $remaining_size=$drive.SizeRemaining

            $free=($remaining_size/$size)*100
            if($free -le 20){
                "##############Storage Monitor##############"|Out-File $log_file -Append
                "##############Storage Monitor##############"
                "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)] ALERT: $drive_letter drive has $($free)% free storage left, Total storage=$([Math]::Round($($size/1GB)))GB Remaining storage=$([Math]::Round($($remaining_size/1GB)))GB" | Out-File $log_file -Append
                "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)] ALERT: $drive_letter drive has $($free)% free storage left, Total storage=$([Math]::Round($($size/1GB)))GB Remaining storage=$([Math]::Round($($remaining_size/1GB)))GB"
            }
        }
     }catch{
        "##############Storage Monitor##############"|Out-File $log_file -Append
        "##############Storage Monitor##############"
        "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)] Error: $($_.exception.message) Occured while checking storage" | Out-File $log_file -Append
        "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)] Error: $($_.exception.message) Occured while checking storage"
     }
}

Function validate-user{
param(
    $user_name
)
    try{    
        $user=get-localuser -Name $user_name |select * -ErrorAction stop

        if($user.Enabled -eq $false){
            "##############User Validation##############"|Out-File $log_file -Append
            "##############User Validation##############"
            "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)] ALERT: user $user_name is in disabled state" | Out-File $log_file -Append
            "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)] ALERT: user $user_name is in disabled state"
        }

    }catch{
        "##############User Validation##############"|Out-File $log_file -Append
        "##############User Validation##############"
        if($_.exception.message -like "not found"){

            "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)] ALERT: $user_name does not exist" | Out-File $log_file -Append
            "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)] ALERT: $user_name does not exist"
        }else{
            
            "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)] Error: $($_.exception.message) Occured while validating local user"| Out-File $log_file -Append
            "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)] Error: $($_.exception.message) Occured while validating local user"
        }

    }

}

Function Monitor-service{
param(
    $service
)
    try{
        $service_state=(get-service -Name $service).status
        if($service_state -ne "Running"){
            "##############Service Monitor##############"|Out-File $log_file -Append
            "##############Service Monitor##############"
            "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)] ALERT: service status for $service is $service_state"|Out-File $log_file -Append
            "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)] ALERT: service status for $service is $service_state"
        }
    }catch{
        if($_.exception.message -match "Cannot find any service"){
            "##############Service Monitor##############"|Out-File $log_file -Append
            "##############Service Monitor##############"
            "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)] ALERT: service with name $service does not exist"|out-file $log_file -Append
            "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)] ALERT: service with name $service does not exist"
        }
    }

}

storage-alert

if(test-path $user_csv){
    $users=Import-Csv -Path $user_csv
    foreach($user in $users){
        validate-user -user_name $user.Username
    }
}else{
    "##############User Validation##############"|Out-File $log_file -Append
    "##############User Validation##############"
    "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)] ALERT: Users csv is not present at $user_csv"|Out-File $log_file -Append
    "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)] ALERT: Users csv is not present at $user_csv"
}

if(test-path $services_csv){
    $services=Import-Csv -Path $services_csv
    foreach($service in $services){
        Monitor-service -service $service.name
    }
}else{
    "##############Service Monitor##############"|Out-File $log_file -Append
    "##############Service Monitor##############"
    "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)] ALERT: Services csv is not present at $user_csv"|Out-File $log_file -Append
    "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)] ALERT: Services csv is not present at $user_csv"
}