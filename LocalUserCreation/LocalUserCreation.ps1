$users_csv="C:\Users\Administrator\powershell_scripts\LocalUserCreation\users.csv"
$date=Get-Date -Format dd-MM-yyyy
$log_file="C:\Users\Administrator\powershell_scripts\LocalUserCreation\LocalUsersLog$date.log"
$users_data=Import-Csv -Path "$users_csv"

foreach($user in $users_data){
    $first_name=$user.Firstname
    $last_name=$user.Lastname
    $user_name=$user.Username
    $password=ConvertTo-SecureString $user.Password -AsPlainText -Force
    try{
        $existing_user=get-localuser -Name $user_name -ErrorAction Stop
        "["+(Get-Date -Format dd-MM-yyyy)+" "+(Get-Date -Format HH:mm:ss)+"] $existing_user already exists " | Out-File $log_file -Append
    }catch{
        if($_.exception.message -eq "User $user_name was not found."){
            $new_user=New-LocalUser -Name $user_name -Password ($password) -FullName "$first_name $last_name" -ErrorAction Stop
            "["+(Get-Date -Format dd-MM-yyyy)+" "+(Get-Date -Format HH:mm:ss)+"] successfully created user $user_name" | Out-File $log_file -Append

        }else{
            "["+(Get-Date -Format dd-MM-yyyy)+" "+(Get-Date -Format HH:mm:ss)+"] failed to create user $user_name, following error occured "+$_.exception.message | Out-File $log_file -Append
        }
    }

}
get-content -Path $log_file