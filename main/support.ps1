class GPOGeneralDetails {
    [string]$GPOName
    [string]$Domain
    [string]$Owner
    [string]$Created
    [string]$Modifed
    [string]$UserRevs
    [string]$UniqueID
    [string]$GpoStatus
    [string]$ReadTime
}
class GpoObj {
    [GPOGeneralDetails]$GPOGeneralDetails 

    GpoObj([xml]$oXML){
       
        $tmp = New-Object -TypeName 'GPOGeneralDetails'
        $tmp.GPOName = "TEST"
        $this.GPOGeneralDetails = $tmp 
    }
}