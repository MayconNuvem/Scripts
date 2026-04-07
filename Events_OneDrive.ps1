import-module Microsoft.Graph.Security
 
# Define o Application (Client) ID e Secret
$ApplicationClientId = 'APPID' # Application (Client) ID
$ApplicationClientSecret = 'SECRET' # Application Secret Value
$TenantId = 'TENANTID' # Tenant ID
 
# Converte o Client Secret para uma Secure String
$SecureClientSecret = ConvertTo-SecureString -String $ApplicationClientSecret -AsPlainText -Force
 
# Cria um PSCredential Object usando o Client ID e Secure Client Secret
$ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApplicationClientId, $SecureClientSecret
 
# Conecta ao Microsoft Graph usando o Tenant ID e Client Secret Credential
Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $ClientSecretCredential -NoWelcome
 
# Parametros de consulta
$params = @{
	Query = 'CloudAppEvents 
    | where Application contains "Onedrive" or Application contains "Sharepoint"
    | where ActionType !contains "Renamed" and ActionType !contains "AddedToGroup"
    | where RawEventData.TargetUserOrGroupName !contains "System Group"
    | extend FileName=RawEventData.SourceFileName, FilePath=RawEventData.SourceRelativeUrl, Url=RawEventData.SiteUrl, AppDisplayName=RawEventData.ApplicationDisplayName, Extension=RawEventData.SourceFileExtension
    | project Timestamp, ActionType, Application, AccountDisplayName, DeviceType, OSPlatform, IPAddress, CountryCode, City, UserAgent, ActivityType, ObjectName, ObjectType, ObjectId, AccountType, AppDisplayName, FileName, Url, FilePath, Extension
    | where Timestamp >= ago(1h)'
}
 
# Executar a consulta
$CloudAppEventsOn = Start-MgSecurityHuntingQuery -BodyParameter $params
 
# Exportar resultados para CSV
#$Results = $CloudAppEventsOn.Results.AdditionalProperties | ForEach-Object { $obj = [PSCustomObject]@{}; $_.GetEnumerator() | ForEach-Object { $obj | Add-Member -MemberType NoteProperty -Name $_.Key -Value $(if($_.Value -is #[System.Object[]]){$_.Value -join ","}else{$_.Value}) -Force }; $obj } #| Export-Csv -Path "c:\logs\CloudAppEvents.csv" -NoTypeInformation -Encoding UTF8 -Append
 
# Desconectar do Microsoft Graph
Disconnect-MgGraph
 
#Parâmetros de conexão com o banco de dados SQL Server
    $serverName = "SERVIDOR DE BANCO DE DADOS"
    $databaseName = "DATABASE"
 
    # Criar uma string de conexão
    $connectionString = "Server=$serverName;Database=$databaseName;Integrated Security=True;TrustServerCertificate=True"
 
# Itera sobre os resultados e insere na base de dados
foreach ($row in $Results) {
    $timestamp        = Format-PtBr $row.Timestamp
    $actionType       = Format-PtBr $row.ActionType
    $application      = Format-PtBr $row.Application
    $accountdisplayname        = Format-PtBr $row.AccountDisplayName
    $DeviceType       = Format-PtBr $row.DeviceType
    $OsPlatform       = Format-PtBr $row.OsPlatform
    $IPAddress        = Format-PtBr $row.IPAddress
    $CountryCode      = Format-PtBr $row.CountryCode
    $City             = Format-PtBr $row.City
    $UserAgent        = Format-PtBr $row.UserAgent
    $ActivityType     = Format-PtBr $row.ActivityType
    $ObjectName       = Format-PtBr $row.ObjectName
    $ObjectType       = Format-PtBr $row.ObjectType
    $ObjectId         = Format-PtBr $row.ObjectId
    $AccountType      = Format-PtBr $row.AccountType
    $ApplicationDisplayName       = Format-PtBr $row.AppDisplayName
    $FileName       = Format-PtBr $row.FileName
    $FilePath       = Format-PtBr $row.FilePath
    $Url       = Format-PtBr $row.Url
    $Extension       = Format-PtBr $row.Extension
    $queryInsert = @"
INSERT INTO dbo.TABELA (
    TimeCreated_dt, ActionType, Application, AccountDisplayName, DeviceType, OsPlatform, IPAddress, CountryCode, City, UserAgent, ActivityType, 
    ObjectName, ObjectType, ObjectId, AccountType, ApplicationDisplayName, FileName, Url, FilePath, Extension
) VALUES (
    '$timestamp',
    '$actionType',
    '$application',
    '$accountdisplayname',
    '$DeviceType',
    '$OsPlatform',
    '$IPAddress',
    '$CountryCode',
    '$City',
    '$UserAgent',
    '$ActivityType',
    '$ObjectName',
    '$ObjectType',
    '$ObjectId',
    '$AccountType',
    '$ApplicationDisplayName',
    '$FileName',
    '$Url',
    '$FilePath',
    '$Extension'
);
"@
    Invoke-SQLcmd -ConnectionString $connectionString -Query $queryInsert
}
 
# Limpar variavel
$CloudAppEventsOn = $null
$response = $null
$Results = $null
$schema = $null
$body = $null
$webResponse = $null