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
    [string]$bypassErrorsText
    [string]$removePolicy
    [string]$removePolicyText
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
        $arrObje = $oXML.GPO.Computer.ExtensionData.Extension.RegistrySettings | Select-Object -ExpandProperty Registry | Select-Object -Property * 
        
        foreach ($i in $arrObje) {
            
            $tmp = New-Object -TypeName RegItem
            $tmp.clsid = $i.clsid
            $tmp.Name = $i.Name
            $tmp.Status = $i.Status
            $tmp.Image = $i.Image
            $tmp.Changed = $i.Changed 
            $tmp.uid = $i.uid
            $tmp.Desc = $i.desc
            $tmp.bypassErrors = $i.bypassErrors
            $tmp.removePolicy = $i.removePolicy

            if ($tmp.bypassErrors -like "1") {
                $tmp.bypassErrorsText = "No"
            }
            else {
                $tmp.bypassErrorsText = "Yes"
            }
            
            if ($tmp.removePolicy -like "1") {
                $tmp.removePolicyText = "Yes"
            }
            else {
                $tmp.removePolicyText = "No"
            }

            $tmp.GPOSettingOrder = $i.GPOSettingOrder
            
            $PropTmp = $i | Select-Object -ExpandProperty Properties | Select-Object -Property *
            $tmp.Properties = New-Object -TypeName RegItemProp
            
            switch ($PropTmp.Action) {
                "C" { $tmp.Properties.Action = "Create"; break }
                "D" { $tmp.Properties.Action = "Delete"; break }
                "R" { $tmp.Properties.Action = "Replace"; break }
                "U" { $tmp.Properties.Action = "Update"; break }
                Default {$tmp.Properties.Action = "Update"; break }
            }
            
            $tmp.Properties.DisplayDecimal = $PropTmp.DisplayDecimal
            $tmp.Properties.default = $PropTmp.default
            $tmp.Properties.hive = $PropTmp.hive
            $tmp.Properties.key = $PropTmp.key
            if ($PropTmp.default -like "1") {
                $tmp.Properties.Name = "(Default)"
            }
            else {
                $tmp.Properties.Name = $PropTmp.Name    
            }
            $tmp.Properties.type = $PropTmp.type
            $tmp.Properties.value = $PropTmp.value
            $tmp.Properties.values = $PropTmp.values
            
            $this.RegItemsC += $tmp
        }
        

    }

}