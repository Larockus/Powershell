$computerName = "COMPUTER_NAME" # Replace with the actual computer name you want to query

# Search for the computer object in Active Directory
$computer = Get-ADComputer -Filter {Name -eq $computerName} -Properties LastLogonDate, Description

if ($computer) {
    $lastLogon = $computer.LastLogonDate
    $description = $computer.Description

    # Retrieve the last user to log in to the computer
    $lastLogonUser = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computerName |
                     Select-Object -ExpandProperty UserName

    Write-Host "Computer Name: $computerName"
    Write-Host "Description: $description"
    Write-Host "Last Logon Date: $lastLogon"
    Write-Host "Last Logon User: $lastLogonUser"
} else {
    Write-Host "Computer '$computerName' not found in Active Directory."
}
