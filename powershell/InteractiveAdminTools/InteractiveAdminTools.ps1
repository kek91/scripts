#
# Description: Interactive Powershell program to retrieve data about remote host
# Author:      Kim Eirik Kvassheim
# Website:     https://github.com/kek91
#
# Known bug: For some reason the "st" command won't
# output anything the first time, you have to run it twice...
#

$version = "0.1.0"

$commands = @(
    "eventvwr",
    "lookup",
    "ping"
)


function showMenu {
    echo "Interactive Admin Tools v$version

Available commands:

event {host}, lu {host}, trace {host}, 
ping {host}, st {host}, hw {host}, 
cls, menu, setup, help, exit

"
}
function showHelp {
    echo "Interactive Admin Tools v$version

event `t {host}       `t - Show Event Viewer (eventvwr) for host
lu    `t {host}       `t - Lookup DNS (nslookup) info for IP/hostname
trace `t {host}       `t - Run traceroute (tracert) to host
ping `t {host}       `t - Ping host
st `t {host}        `t - Get BIOS Serial Tag from host
hw `t {host}        `t - Get Hardware info from host

cls/clear             `t - Clear screen
menu                  `t - Show menu
setup                 `t - Create environment variable for this program to run it from cmd.exe with 'iat'
help                  `t - Show help
exit/q                `t - Exit. Doh

Problems running commands? Remember to run script as domain administrator
"
}

cls
showMenu

do {

    $input = read-host ">>> "
    $input = $input -split ' '
    $cmd   = $input[0]
    $param = $input[1]

    switch ($cmd)
    {
        'event' {
            eventvwr $param
        }

        'lu' {
            if($param) {
                nslookup $param
            }
        }

        'trace' {
            if($param) {
                tracert $param
            }
        }

        'ping' {
            ping $param
        }

        'st' {
            if($param) {
                $st = Get-WmiObject -computername $param -class win32_bios | select SerialNumber
                echo $st
            }
        }
        'hw' {
            if($param) {
                $ram = Get-WmiObject -computername $param -class win32_computersystem | select TotalPhysicalMemory
                $cpu = Get-WmiObject -computername $param -class Win32_Processor | select Name, NumberOfCores
                $gpu = Get-WmiObject -computername $param -class Win32_DisplayConfiguration | select DeviceName
                $os = Get-WmiObject -computername $param -class Win32_OperatingSystem | select Caption, OSArchitecture
                echo "CPU: $cpu"
                echo "RAM: $ram"
                echo "GPU: $gpu"
                echo " OS: $os"
            }
        }
        






        'setup' {
            echo "`nCreating (User) environment variable '%iat%'..."
            [Environment]::SetEnvironmentVariable("iat", "powershell $PSCommandPath", "User")
            echo "`nComplete!`n`nYou can now start InteractiveAdminTools by simply typing %iat% in your command prompt."
        }

        'menu' {
            showMenu
        }
        'help' {
            showHelp
        }
        'cls' {
            cls
        }
        'clear' {
            cls
        }

        'q' {
            return
        }
        'exit' {
            return
        }
    }
}
until ($cmd -eq 'q')