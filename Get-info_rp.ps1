$vc = Read-Host -Prompt "Incregre el Vcenter"


#Conectarse al Vcenter
try {
    Write-Host "Conectando con vCenter $vcenter , por favor espere ..." -ForegroundColor Cyan
    Connect-VIServer $vc -ErrorAction Stop | Out-Null
}#Fin del Try
catch {
    Write-Host "No se puede conectar con el servidor" -ForegroundColor Yellow
    Break
}#Fin del Catch


$clusterName = Read-Host -Prompt "Incregre el CLuster"

$cluster = Get-Cluster -Name $clusterName
Get-ResourcePool -Location $cluster |
Select Name,@{N="Parent";E={
  $path = $_.Parent.Name,$_.Name -join '/'
  $parent = $_.Parent
  while($parent -isnot [VMware.VimAutomation.ViCore.Impl.V1.Inventory.ClusterIMpl]){
    $path = $parent.Parent.Name,$path -join '/'
    $parent = $parent.Parent
  }
  $path}},ParentId,CpuSharesLevel,NumCpuShares,CpuReservationMHz,CpuExpandableReservation,CpuLimitMHz,MemSharesLevel,NumMemShares,MemReservationMB,MemReservationGB,MemExpandableReservation,MemLimitMB,MemLimitGB,CustomFields,ExtensionData,Id,Uid |
Export-Csv rp-export.csv -NoTypeInformation -UseCulture


Disconnect-VIServer * -Force