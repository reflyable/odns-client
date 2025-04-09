$coredns = Resolve-Path .\coredns.exe
$corefile =  Resolve-Path .\corefile



$cim = (Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'")

$1 = $cim| Get-DNSClientServerAddress |Where-Object AddressFamily -EQ 2 | Select-Object -ExpandProperty ServerAddresses

$cim| Set-DNSClientServerAddress -ServerAddresses 127.0.0.1 
$p = Start-Process -FilePath $coredns -ArgumentList "-conf",$corefile -PassThru -WindowStyle Hidden -RedirectStandardOutput .\log.txt -RedirectStandardError .\err.txt
"Runing"
Read-Host -Prompt "Press Enter to exit"
"Terminating..."


$cim| Set-DNSClientServerAddress -ResetServerAddresses

$2 = $cim| Get-DNSClientServerAddress |Where-Object AddressFamily -EQ 2 | Select-Object -ExpandProperty ServerAddresses

if (!($1 -eq $2)) {
$cim| Set-DNSClientServerAddress -ServerAddresses  $1
}

if ($p.HasExited -eq $false) {
    $p | Stop-Process -Force
}
