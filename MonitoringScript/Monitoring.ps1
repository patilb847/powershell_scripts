param(
$log_file="C:\Users\Administrator\powershell_scripts\MonitoringScript\monitoring$(Get-Date -Format ddMMyyyy)$(Get-Date -Format HHmm).log",
$user_csv="C:\Users\Administrator\powershell_scripts\MonitoringScript\users.csv",
$services_csv="C:\Users\Administrator\powershell_scripts\MonitoringScript\services.csv"
)
Function Write-log{
param(
    $message,
    $section
)
    $timestamp = "[$(Get-Date -Format dd-MM-yyyy) $(Get-Date -Format HH:mm:ss)]"
    $header = "##############$section##############"
    $logMessage = "$timestamp $message"

    $header | Out-File $log_file -Append
    $logMessage | Out-File $log_file -Append

    $header
    $logMessage

}

Function storage-alert{
    
    try{
        $drives=Get-Volume | where{$_.DriveLetter -ne $null} |select * -ErrorAction stop

        foreach($drive in $drives){
        
            $drive_letter=$drive.DriveLetter
            $size=$drive.Size
            $remaining_size=$drive.SizeRemaining

            $free=($remaining_size/$size)*100
            if($free -le 20){
                Write-log -message "ALERT: $drive_letter drive has $($free)% free storage left, Total storage=$([Math]::Round($($size/1GB)))GB Remaining storage=$([Math]::Round($($remaining_size/1GB)))GB" -section "Storage Monitor"
            }
        }
     }catch{
        Write-log -message "Error: $($_.exception.message) Occured while checking storage" -section "Storage Monitor"
     }
}

Function validate-user{
param(
    $user_name
)
    try{    
        $user=get-localuser -Name $user_name |select * -ErrorAction stop

        if($user.Enabled -eq $false){
            Write-log -message "ALERT: user $user_name is in disabled state" -section "User Validation"
        }

    }catch{
        "##############User Validation##############"|Out-File $log_file -Append
        "##############User Validation##############"
        if($_.exception.message -like "not found"){
            Write-log -message "ALERT: $user_name does not exist" -section "User Validation"
        }else{
            Write-log -message "Error: $($_.exception.message) Occured while validating local user" -section "User Validation"
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
            Write-log -message "ALERT: service status for $service is $service_state" -section "Service Monitor"
        }
    }catch{
        if($_.exception.message -match "Cannot find any service"){
            Write-log -message "ALERT: service with name $service does not exist" -section "Service Monitor"
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
    Write-log -message "ALERT: Users csv is not present at $user_csv" -section "User Validation"
}

if(test-path $services_csv){
    $services=Import-Csv -Path $services_csv
    foreach($service in $services){
        Monitor-service -service $service.name
    }
}else{
    Write-log -message "ALERT: Services csv is not present at $user_csv" -section "Service Monitor"
}