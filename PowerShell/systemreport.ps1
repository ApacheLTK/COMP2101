param( 
    [switch]$System,
    [switch]$Disks,
    [switch]$Network
)
#if no parameters are called then the function will run with all local functions (systemInfoFunc, osInfoFunc, cpuInfoFunc, ramInfoFunc, diskDriveInfoFunc, videoAdapterInfoFunc, networkAdapterInfoFunc)
if (!$System -and !$Disks -and !$Network) {
    Write-Output "System Info"
    systemInfoFunc
    
    Write-Output "`nCPU Info"
    cpuInfoFunc

    Write-Output "`nRAM Info"
    ramInfoFunc

    Write-Output "`nDisk Info"
    diskDriveInfoFunc

    Write-Output "`nNetwork Adapter Info"
    networkAdapterInfoFunc

    Write-Output "`nVideo Adapter Info"
    videoAdapterInfoFunc
}
#Display System Info (systemInfoFunc, osInfoFunc, cpuInfoFunc, ramInfoFunc, diskDriveInfoFunc) when -System parameter is called
else {
    if ($System) {
    Write-Output "System Info Report"
    systemInfoFunc
    osInfoFunc
    cpuInfoFunc
    ramInfoFunc
    videoAdapterInfoFunc
    }
    #When -Disks is called as a paramter diskDriveInfoFunc will run
    if ($Disks) {
        Write-Output "Disk Drive Report"
        diskDriveInfoFunc
    } 
    #When -Network is called as a parameter networkAdapterInfoFunc will run   
    if ($Network) {
        Write-Output "Network Adapter Report"
        networkAdapterInfoFunc
    }
}
