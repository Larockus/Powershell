# Requires Active Directory Module
Import-Module ActiveDirectory

# Define a list of specific computer names to target
$targetComputers = @("ComputerName1", "ComputerName2", "ComputerName3")

foreach ($computerName in $targetComputers) {
    # Retrieve the computer object from Active Directory
    $computer = Get-ADComputer -Identity $computerName -ErrorAction SilentlyContinue
    
    if ($computer) {
        # Try to connect to the computer and get the service information
        try {
            $services = Get-WmiObject -Class Win32_Service -ComputerName $computer.Name -ErrorAction Stop

            foreach ($service in $services) {
                # Output the computer name, service display name, state, and start name
                Write-Host "Computer: $($computer.Name)`tService: $($service.DisplayName)`tState: $($service.State)`tStartName: $($service.StartName)"
            }
        } catch {
            Write-Warning "Could not connect to $($computer.Name)."
        }
    } else {
        Write-Warning "Computer $computerName not found in Active Directory."
    }
}
