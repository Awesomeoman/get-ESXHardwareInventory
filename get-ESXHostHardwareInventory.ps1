Add-PSSnapin VMware.VimAutomation.Core

connect-viserver vCenterServer

$objOutput = @()

$colVMhost = get-vmhost

foreach ($objVMhost in $colVMhost) {

    try {
            
            $colDatastore = $objvmhost | Get-Datastore 
            $objDatastoreSize = ($colDatastore | select -ExpandProperty CapacityMB | Measure-Object -Sum).sum/1MB
            $objDatastoreCount = ($colDatastore).Count

            $objDeets = [PSCustomObject] @{
                
                "ESX Host" = $objVMhost.name
                "vCenter Cluster" = $($objVMhost | get-cluster).name
                "Number of VMs" = (($objVMhost | get-vm) | Measure-Object).count
                "CPU Count" = $objVMhost.NumCpu
                "CPU Type" = $objVMhost.ProcessorType
                "RAM (MB)" = $objVMhost.MemoryTotalMB
                "Manufacturer" = $objVMhost.Manufacturer
                "Model" = $objVMhost.Model
                "Total Storage (GB)" = "{0:N2}" -f $objDatastoreSize
                "Number of Datastores" = $objDatastoreCount
                "ESX Version" = $objVMhost.Version
                "ESX Build" = $objVMhost.Build

            }
        
    } catch {
        $error[0].Exception.Message
    }
$objOutput += $objDeets
}
$objOutput | export-csv .\ESXHosts.csv -NoTypeInformation 



