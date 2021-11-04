. "$PSScriptRoot\classes\mojeGPO.ps1"

$sXML1 = "$PSScriptRoot\testGPOreps\gpo2.xml"
$oXML1 = [xml]$(Get-Content -Path $sXML1)

$oGPO1 = [mojeGPO]::new($oXML1)

$oGPO1
<# $ns = @{q1 = "http://www.microsoft.com/GroupPolicy/Settings/Windows/Registry"}
$nodes = Select-Xml -Xml $oXML1 -Namespace $ns -XPath "//q1:RegistrySettings"| Select-Object -ExpandProperty Node


foreach ($i in $nodes) {
    $i.Collection
} #>

#$nodes2 = ($oXML1.GPO.Computer.ExtensionData.Extension.RegistrySettings.Registry) | Select-Object -ExpandProperty Properties
<# $nodes2 = ($oXML1.GPO.Computer.ExtensionData.Extension.RegistrySettings) | Select-Object -ExpandProperty Registry | Sort-Object -Property GPOSettingOrder -Descending
$nodes2 #>