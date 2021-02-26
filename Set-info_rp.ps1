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



foreach($row in (Import-Csv rp-export.csv -UseCulture)){
  $clusterName,$pools = $row.Parent.Split('/')
  Try {
    $skip = $false
    $location = Get-Cluster -Name $clusterName -ErrorAction Stop
  }
  Catch {
    "Cluster $clusterName not found"
    $skip = $true
  }
  if(!$skip){
    foreach($rp in $pools){
      Try {
        $location = Get-ResourcePool -Name $rp -Location $location -ErrorAction Stop
      }
      Catch {
        $location = New-ResourcePool -Name $rp -Location $Location -NumCpuShares $row.NumCpuShares -CpuReservationMHz $row.CpuReservationMHz -CpuExpandableReservation ([System.Convert]::ToBoolean($row.CpuExpandableReservation)) -CpuLimitMHz $row.CpuLimitMHz
      }
    }
  }
}