#This script shows idle domain machines based on last login time in Active Directory. 

#Script output is saved to the root drive where the script was ran from.
Write-Host (" `r`nThis script will search the entire domain of the current machine for any computers whith no logon history older than the defined value.`r`n") -ForegroundColor  Red -Backgroundcolor Black

Start-Sleep -s 1

#This is the number of days to check for inactivity, this number will change the file name accordingly
$daysSinceLogon = Read-Host -Prompt 'Please Input the Number of days to search'  

$time = (Get-Date).Adddays( - ($daysSinceLogon))

#Prompts the user if they would like a CSV of the command results saved. 
$confirmation = Read-Host 'Would you like to save these results as a CSV file? Yes/No'

#Array containing acceptable "yes" answers
$yes = @("YES", "Yes", "yes", "Y", "y")

#var of the command that is being ran, beause I felt like it I guess. I dunno... but I kept it in. 
$Command = Get-AdComputer -Filter { lastLogonTimeStamp -lt $time } -Properties LastLogonDate, Name, OperatingSystem | Where-Object { $_.Enabled -eq $True } | select-Object LastLogonDate, Name, OperatingSystem, 
Enabled | Sort-Object "LastLogonDate" 

#Message displayed on screen indicating it's searching the domain shows the amount of days according the the user input previously
Write-Host ("Checking for Computers with no logon data over $daysSinceLogon days ago.`r`n") -ForegroundColor  Red -Backgroundcolor Black

#If checks the yes/no user response againse the $yes array, if a match is found a file is created 
if ($yes -contains $confirmation) {
    #checks the users response against 
    Write-Host("The following results Have been saved to CSV File $daysSinceLogon _Days_Idle_Computers$((Get-Date).ToString('MM-dd-yyyy_hh-mm')).csv. In the same directory where the script is located.")-ForegroundColor  Red -Backgroundcolor Black
    Start-Sleep -s 1
    #The Export uses the user defined variable in the file name and appends the file name with the date & time .csv
    $Command | Export-Csv -Path .\"$daysSinceLogon"_Days_Idle_Computers-$((Get-Date).ToString('MM-dd-yyyy_hh-mm')).csv -notypeinformation 
}
#I chose to have the results still shown in the console regardless of the users response. 
Get-AdComputer -Filter { lastLogonTimeStamp -lt $time } -Properties LastLogonDate, Name, OperatingSystem | Where-Object { $_.Enabled -eq $True } | select-Object LastLogonDate, Name, OperatingSystem, Enabled | Sort-Object "LastLogonDate" 
