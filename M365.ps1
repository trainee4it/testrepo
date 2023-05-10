function Get-File
{
    param($Initiaal)

    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog 
    $FileBrowser.Title = "PICK A FILE CSV"
    $FileBrowser.Filter = 'CSV files (*.csv)|*.csv'
    $FileBrowser.InitialDirectory = $Initiaal
    $Ok = $FileBrowser.ShowDialog() 
    $FileBrowser.FileName



}


function User-Check
{

    param(
    
    [Parameter(Mandatory=$true)]
    $UPN)

    $Exists = $true

    try
    {
        
        $User =   Get-MsolUser -UserPrincipalName $UPN -ErrorAction Stop

    }

    catch
    {

        $Exists = $false

    }

    $Exists




}



$UsersToImport = Import-Csv -Path (Get-File)



#ophalen suffix in dit geval adataum.com, bij jullie contoso.com
$UPNSUFFIX = 'M365x49336553.onmicrosoft.com'

foreach($Item in $UsersToImport)
{

    
    $UPN = $item.FIRSTNAME[0] + $Item.LASTNAME +'@'+$UPNSUFFIX
    $SecurePassword =  'Pa55w.rd1234' 
    $DisplayName = $Item.FIRSTNAME + ' '+ $Item.LASTNAME
    

    if((User-Check -UPN $UPN) -eq $false)
    {

        New-MsolUser -UserPrincipalName $UPN -Password  $SecurePassword -DisplayName $DisplayName
    
        Write-Verbose -Message ("creating user " + $UPN) -Verbose


    }

    else
    {

         Write-Verbose -Message ($UPN + ' user already exists !') -Verbose

         

    
    
    }

  
}
