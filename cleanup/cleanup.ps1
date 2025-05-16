$target_dir=""
$Today=Get-Date
$log_file="C:\D-drive\powershell\cleanup\cleanup_log"+($Today.Day)+($Today.Month)+($Today.Year)+".txt"
$log_file
$check_date=(Get-Date).AddDays(-30)
$files=(Get-ChildItem -Path $target_dir -File| where{ 

$_.LastWriteTime -lt $check_date 

})

foreach($file in $files){
    Remove-Item -Path $file.FullName -Force
    $file.FullName +" Deleted on "+$Today | Out-File $log_file -Append
}
