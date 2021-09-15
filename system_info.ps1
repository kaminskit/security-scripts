# powershell script listing system information and running processes

$version = (Get-WmiObject -Class Win32_OperatingSystem).version
$ram = (Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum/1gb
$processorName = (Get-WmiObject Win32_Processor).name
$MAC = (Get-WmiObject Win32_NetworkAdapterConfiguration | where {$_.IPEnabled -eq "True" -and $_.ServiceName -NE "VMnetAdapter"}).macaddress
$IPv4 = (Get-WmiObject Win32_NetworkAdapterConfiguration | where {$_.IPEnabled -eq "True" -and $_.ServiceName -NE "VMnetAdapter"}).IPaddress[0]
$DG = (Get-WmiObject Win32_NetworkAdapterConfiguration | where {$_.IPEnabled -eq "True" -and $_.ServiceName -NE "VMnetAdapter"}).DefaultIPGateway
$IPv6 = (Get-WmiObject Win32_NetworkAdapterConfiguration | where {$_.IPEnabled -eq "True" -and $_.ServiceName -NE "VMnetAdapter"}).IPaddress[1]
$size = (Get-WmiObject Win32_LogicalDisk | Select DeviceID, Size  | where {$_.DeviceID -EQ "C:"}).size
"Windows version = " + $version
"RAM = " + $ram + " GB"
"Processor = " + $processorName
"MAC address = " + $MAC
"IPv4 address = " + $IPv4
"Default Gateway = " + $DG
"IPv6 address = " + $IPv6
"Hard Disk capacity = " + $size/1gb + " GB"

$table = Get-Process | Sort-Object -Property WS -Descending | Select-Object Name,@{Name='Memory(MB)';Expression={($_.WorkingSet/1MB)}} 
$finalTable = $table | Select-Object | where {$_."Memory(MB)" -ge 5} 
$finalTable
$totalsize = ($table | Measure-Object "Memory(MB)" -Sum).Sum
"Total memory Utilization of these Processes = "+ $totalsize + " MB"