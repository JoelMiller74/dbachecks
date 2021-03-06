function Assert-DatabaseStatus {
    Param(
        [string]$instance,
        [string[]]$Excludedbs,
        [string[]]$ExcludeReadOnly,
        [string[]]$ExcludeOffline,
        [string[]]$ExcludeRestoring
    )
    $results = (Connect-DbaInstance -SqlInstance $Instance).Databases.Where{$psitem.Name -notin $Excludedbs} | Select-Object Name, Status,Readonly
    $results.Where{$_.Name -notin $ExcludeReadOnly}.Readonly | Should -Not -Contain True -Because "We expect that there will be no Read-Only databases except for those specified"
    $results.Where{$_.Name -notin $ExcludeOffline}.Status | Should -Not -Match 'Offline' -Because "We expect that there will be no offline databases except for those specified"
    $results.Where{$_.Name -notin $ExcludeRestoring}.Status | Should -Not -Match 'Restoring' -Because "We expect that there will be no databases in a restoring state except for those specified"
    $results.Where{$_.Name -notin $ExcludeOffline}.Status | Should -Not -Match 'AutoClosed' -Because "We expect that there will be no databases that have been auto closed"    
    $results.Status | Should -Not -Match 'Recover' -Because "We expect that there will be no databases going through the recovery process or in a recovery pending state"
    $results.Status | Should -Not -Match 'Emergency' -Because "We expect that there will be no databases in EmergencyMode"
    $results.Status | Should -Not -Match 'Standby' -Because "We expect that there will be no databases in Standby"
    $results.Status | Should -Not -Match 'Suspect' -Because "We expect that there will be no databases in a Suspect state"
}