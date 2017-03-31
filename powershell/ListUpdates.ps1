#
# Description: List Windows Update from computers in array and export to file.
#              We used it for troubleshooting a strange problem which lead us to
#              believe it could be a common windows update for the affected computers.
#
# Usage:       Enter hostnames in $hosts array and run script
#
# Note:        - Requires local administrator access on remote computer (i.e. domain admin)
#              - Threads aren't implemented so it currently queries the computers one by one.
#
# Author:      Kim Eirik Kvassheim
# Website:     https://github.com/kek91
#

$hosts = @(
    "pc-01", "pc-02", "pc-03", 
    "pc-04", "pc-05", "pc-06"
)

Write-Host "Collecting Windows Updates logs`n"

foreach($i in $hosts) {

    $output = "Host: " + $i + "`t"
    $status = "Offline"
    try {
        if(Test-Connection -computername $i -quiet) {
            $status = "Online"
        }
    }
    catch {
        $status = "Error"
    }
    $output += "Status: " + $status + "`t"

    if($status -eq "Online") {
        try {
            
            # Select Caption, HotfixID, Description, InstalledOn, ++

            Get-Hotfix -computername $i | 
            Select HotfixID, InstalledOn | 
            Where-Object { 
                $_.InstalledOn -gt "02/01/2017 00:00:00" -AND $_.InstalledOn -lt "03/28/2017 00:00:00" 
            } |
            Sort-Object InstalledOn > $i".txt"

            $output += "Log: "+$i+".txt"
        }
        catch {
            $output += "Log: Error"
        }
    }

    Write-Host $output

}

Write-Host "`nComplete"