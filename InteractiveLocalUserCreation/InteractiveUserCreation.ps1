$date=Get-Date -Format dd-MM-yyyy
$log_file="C:\Users\Administrator\powershell_scripts\InteractiveLocalUserCreation\InteractiveLocalUsersLog$date.log"

$continue_flag=$true

while($continue_flag -eq $true){

    $first_name=Read-Host -Prompt "Enter first name of user"

    while(($first_name -eq $null) -or ($first_name -eq "")){
        "Firstname is mandatory"
        $first_name=Read-Host -Prompt "Enter first name of user"
    }


    $last_name=Read-Host -Prompt "Enter last name of user"
    while(($last_name -eq $null) -or ($last_name -eq "")){
        "Lastname is mandatory"
        $last_name=Read-Host -Prompt "Enter lastname of user"
    }

    $user_name=Read-Host -Prompt "Enter username of user"
    while(($user_name -eq $null) -or ($user_name -eq "")){
        "Username is mandatory"
        $user_name=Read-Host -Prompt "Enter username of user"
    }


    $password=Read-Host -Prompt "Enter password for user" 
    while(($password -eq $null) -or ($password -eq "") -or ($password.Length -lt 8)){
        "Password is mandatory, Password should be more than 8 characters"
        $password=Read-Host -Prompt "Enter password for user"
    }
    $password=ConvertTo-SecureString -String $password -AsPlainText -Force


    try{
        $existing_user=get-localuser -Name $user_name -ErrorAction Stop
        "==========================================================================="
        "[$((Get-Date -Format dd-MM-yyyy)) $((Get-Date -Format HH:mm:ss))] User $($existing_user) already exists " | Out-File $log_file -Append
        "[$((Get-Date -Format dd-MM-yyyy)) $((Get-Date -Format HH:mm:ss))] User $($existing_user) already exists "
        "==========================================================================="
    }catch{
        if($_.exception.message -eq "User $user_name was not found."){
            try{
                $new_user=New-LocalUser -Name $user_name -Password ($password) -FullName "$first_name $last_name" -ErrorAction Stop
                "==========================================================================="
                "[ $((Get-Date -Format dd-MM-yyyy)) $((Get-Date -Format HH:mm:ss)) ] successfully created user $($user_name)" | Out-File $log_file -Append
                "[ $((Get-Date -Format dd-MM-yyyy)) $((Get-Date -Format HH:mm:ss)) ] successfully created user $($user_name)"
                "==========================================================================="
            }catch{
                "==========================================================================="
                "[ $((Get-Date -Format dd-MM-yyyy)) $((Get-Date -Format HH:mm:ss))] failed to create user $($user_name), following error occured $($_.exception.message)" | Out-File $log_file -Append
                "[ $((Get-Date -Format dd-MM-yyyy)) $((Get-Date -Format HH:mm:ss))] failed to create user $($user_name), following error occured $($_.exception.message)"
                "==========================================================================="
            }
        }else{
            "==========================================================================="
            "[$((Get-Date -Format dd-MM-yyyy)) $((Get-Date -Format HH:mm:ss))] failed to create user $($user_name), following error occured $($_.exception.message)" | Out-File $log_file -Append
            "[$((Get-Date -Format dd-MM-yyyy)) $((Get-Date -Format HH:mm:ss))] failed to create user $($user_name), following error occured $($_.exception.message)"
            "==========================================================================="
        }
    }
    $continue_dec=""
    while(($continue_dec -ne "y") -and ($continue_dec -ne "n")){
        $continue_dec=Read-Host -Prompt "Do you want to create another user(y/n)"
    
        if($continue_dec -eq "y"){
            $continue_flag=$true
        }elseif($continue_dec -eq "n"){
            $continue_flag=$false
        }
    }
}