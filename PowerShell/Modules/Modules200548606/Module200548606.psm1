# systemInfoFunc function to get general system hardware information
function systemInfoFunc {
    $systemInfo = Get-CimInstance -ClassName Win32_ComputerSystem
    $systemInfo | fl
}

# oSInfoFunc function grabs operating system name and version 
function osInfoFunc {
    $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
    $osInfo | fl
}
#cpuInfoFunc grabs cpu information
function cpuInfoFunc {
    $cpuInfo = Get-CimInstance -ClassName Win32_Processor | Select-Object -First 1
    $cpuInfo | fl
}
#ramInfoFunc grabs ram information
function ramInfoFunc {
    $totalcapacity = 0
    get-wmiobject -class win32_physicalmemory |
    foreach {
    new-object -TypeName psobject -Property @{
    Manufacturer = $_.manufacturer
    "Speed(MHz)" = $_.speed
    "Size(MB)" = $_.capacity/1mb
    Bank = $_.banklabel
    Slot = $_.devicelocator
    }
    $totalcapacity += $_.capacity/1mb
    } |
    ft -auto Manufacturer, "Size(MB)", "Speed(MHz)", Bank, Slot
    "Total RAM: ${totalcapacity}MB "
}
#diskDriveInfoFunc grabs disk drive information
function diskDriveInfoFunc {
    $diskdrives = Get-CIMInstance CIM_diskdrive

    foreach ($disk in $diskdrives) {
        $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
        foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                   new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                             Location=$partition.deviceid
                                                             Drive=$logicaldisk.deviceid
                                                             "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                                }
            }
        }
    }
}
# networkAdapterInfoFunc grabs network adapter info of the adapters in use
function networkAdapterInfoFunc {
    gwmi -class win32_networkadapterconfiguration -filter ipenabled=true |
    where { $_.dnsdomain -ne $null -or $_.dnshostname -ne $null -or $_.dnsserversearchorder -ne $null } |
    select Description, Index, IPAddress, IPSubnet, DNSDomain, DNSHostname | ft -AutoSize
}
#videoAdapterInfoFunc grabs video adapter info and display resolution 
function videoAdapterInfoFunc {
    $videoAdapterInfo = Get-CimInstance -ClassName Win32_VideoController | Select-Object AdapterCompatibility, Description, VideoModeDescription | fl
    Write-Output $videoAdapterInfo
}