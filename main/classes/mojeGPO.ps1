class detailsGPO {
    [string]$Domain
    [string]$Owner
    [string]$Created
    [string]$Modified
    [string]$UserRevisions
    [string]$ComputerRevisions
    [string]$UniqueID
    [string]$GPOStatusComputer
    [string]$GPOStatusUser

    detailsGPO([xml]$oXML){
        $this.Domain = $oXML.GPO.Identifier.Domain | Select-Object -ExpandProperty '#text'
        $this.Owner = $oXML.GPO.SecurityDescriptor.Owner.Name | Select-Object -ExpandProperty '#text'
        $this.Created = $oXML.GPO.CreatedTime
        $this.Modified = $oXML.GPO.ModifiedTime
        $this.ComputerRevisions = "$($oXML.GPO.Computer.VersionDirectory) (AD), $($oXML.GPO.Computer.VersionSysvol) (SYSVOL)"
        $this.UserRevisions = "$($oXML.GPO.User.VersionDirectory) (AD), $($oXML.GPO.User.VersionSysvol) (SYSVOL)"
        $this.UniqueID = $oXML.GPO.Identifier.Identifier | Select-Object -ExpandProperty '#text'

        if ($oXML.GPO.Computer.Enabled -like "true") {
            $this.GPOStatusComputer = "Enabled"
        }
        else {
            $this.GPOStatusComputer = "Disabled"
        }

        if ($oXML.GPO.User.Enabled -like "true") {
            $this.GPOStatusUser = "Enabled"
        }
        else {
            $this.GPOStatusUser = "Disabled"
        }
    }
}
#----------------------------------------------------------
class RegItemProp {
    [string]$Action
    [string]$DisplayDecimal
    [string]$default
    [string]$hive
    [string]$key
    [string]$Name
    [string]$type
    [string]$value
    [string]$values    
}
class RegItem {
    [string]$clsid
    [string]$Name
    [string]$Status
    [string]$Image
    [string]$Changed
    [string]$uid
    [string]$Desc
    [string]$bypassErrors
    [int]$GPOSettingOrder
    [RegItemProp]$Properties
    #[filerss]$filers
    
}
#-----------------------------------Root-----------------
class mojeGPO {
    [string]$Name
    [string]$ReadTime
    [detailsGPO]$Details
    [RegItem[]]$RegItemsC
    [RegItem[]]$RegItemsU

    mojeGPO([xml]$oXML){
        $this.Name = $oXML.GPO.Name
        $this.ReadTime = $oXML.GPO.ReadTime
        $this.Details = [detailsGPO]::new($oXML)
    
        $oXML.GPO.Computer.ExtensionData.Extension.RegistrySettings | Select-Object -ExpandProperty Registry | Select-Object -Property * | ForEach-Object{
            $tmp = New-Object -TypeName RegItem
            $tmp.clsid = $_.clsid
            $tmp.Name = $_.Name
            $tmp.Status = $_.Status
            $tmp.Image = $_.Image
            $tmp.Changed = $_.Changed 
            $tmp.uid = $_.uid
            $tmp.Desc = $_.desc
            $tmp.bypassErrors = $_.bypassErrors
            $tmp.GPOSettingOrder = $_.GPOSettingOrder
            
            $PropTmp = $_ | Select-Object -ExpandProperty Properties | Select-Object -Property *
            $tmp.Properties = New-Object -TypeName RegItemProp
            $tmp.Properties.Action = $PropTmp.Action
            $tmp.Properties.DisplayDecimal = $PropTmp.DisplayDecimal
            $tmp.Properties.default = $PropTmp.default
            $tmp.Properties.hive = $PropTmp.hive
            $tmp.Properties.key = $PropTmp.key
            $tmp.Properties.Name = $PropTmp.Name
            $tmp.Properties.type = $PropTmp.type
            $tmp.Properties.value = $PropTmp.value
            $tmp.Properties.values = $PropTmp.values
            
            $this.RegItemsC += $tmp
        }
        

    }

}