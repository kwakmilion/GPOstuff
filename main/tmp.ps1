. "$PSScriptRoot\support.ps1"

$sXML1 = "$PSScriptRoot\testGPOreps\gpo1.xml"
$oXML1 = [xml]$(Get-Content -Path $sXML1)

$oGPO1 = [GpoObj]::new($oXML1)
$oGPO1
#New-HTML -TitleText "GPO Difference Report"


<# $arrTE = @()
$arrTE += $testXML1
$arrTE += $testXML2 #>
<# write-host $oXML1
$arrTe|Out-HtmlView -Compare -ScrollX -HighlightDifferences #>