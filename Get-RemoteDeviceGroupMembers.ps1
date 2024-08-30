Function Get-RemoteDeviceGroupMembers {
    <#
        .DESCRIPTION
        This was written to address the issue described on https://github.com/PowerShell/PowerShell/issues/2996.
        MSFT are aware of this issue, but have closed it without a fix, citing no reason.

        The script uses ADSI to fetch all members of a local group on a remote device.
        
        It will output the SID of AzureAD objects such as roles, groups and users,
        and any others which cannot be resolved.

        .EXAMPLE
        This will store the output of the function in the $results variable
        $results = Get-RemoteDeviceGroupMembers -Computer Computer01.contoso.com -Group Administrators

        This will output the results of the function straight to console       
        Get-RemoteDeviceGroupMembers -Computer Computer01.contoso.com -Group Administrators

        .OUTPUTS
        System.Management.Automation.PSCustomObject
        Name        MemberType   Definition
        ----        ----------   ----------
        Equals      Method       bool Equals(System.Object obj)
        GetHashCode Method       int GetHashCode()
        GetType     Method       type GetType()
        ToString    Method       string ToString()
        Computer    NoteProperty string Computer=Workstation1
        Domain      NoteProperty System.String Domain=Contoso
        User        NoteProperty System.String User=Administrator
    #>

    
    param (
        [string]
        $Groupname,
        [string]
        $Computer
    )
    
    $admins = Invoke-Command -ComputerName $Computer -ScriptBlock {
        $group = [ADSI]('WinNT://{0}/{1}' -f $env:COMPUTERNAME, $args[0])
        $admins = $group.Invoke('Members') | ForEach-Object {
            $path = ([adsi]$_).path
            [pscustomobject]@{
                Computer = $env:COMPUTERNAME
                Domain   = $(Split-Path (Split-Path $path) -Leaf)
                User     = $(Split-Path $path -Leaf)
            }
        }
        return $admins
    } -ArgumentList $Groupname
    return $admins | Select-Object Computer, Domain, User
}
