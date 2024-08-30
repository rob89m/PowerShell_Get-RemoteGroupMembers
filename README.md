# Get-RemoteGroupMembers
Allow easy retrieval of local group members on remote devices

This was written to address the issue described on https://github.com/PowerShell/PowerShell/issues/2996.

MSFT are aware of this issue, but have closed it without a fix, citing no reason.

The script uses ADSI to fetch all members of a local group on a remote device.
        
It will output the SID of AzureAD objects such as roles, groups and users,
and any others which cannot be resolved.
