
Import-Module -Name (Join-Path -Path ( Split-Path $PSScriptRoot -Parent ) `
    -ChildPath 'SecurityPolicyResourceHelper\SecurityPolicyResourceHelper.psm1') `
    -Force

$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_SecurityOption'

<#
    .SYNOPSIS
        Returns all the Security Options that are currently configured

    .PARAMETER Name
        Describes the security option to be managed. This could be anything as long as it is unique. This property is not 
        used during the configuration process.

    .NOTES
    General notes
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name
    )

    $returnValue = @{}
    $currentSecurityPolicy = Get-SecurityPolicy -Area SECURITYPOLICY
    $securityOptionData = Get-SecurityOptionData
    $moduleParameters = Get-SecurityOptionParameter
    
    foreach ( $parameter in $moduleParameters )
    {
        $section = $securityOptionData.$parameter.Section
        Write-Debug -Message ( $script:localizedData.DubugSection -f $section )
        $valueName = $securityOptionData.$parameter.Value
        Write-Debug  -Message ( $script:localizedData.DebugValue -f $valueName )
        $options = $securityOptionData.$parameter.Option
        Write-Debug -Message ( $script:localizedData.DebugOption -f $options )
        $currentValue = $currentSecurityPolicy.$section.$valueName
        Write-Debug -Message ( $script:localizedData.DebugRawValue -f $currentValue )
    
        if ( $options.keys -eq 'String' )
        {
            $stringValue = ( $currentValue -split ',' )[-1]
            $resultValue = ( $stringValue -replace '"' ).Trim()
        }
        else
        {
            Write-Verbose "Retrieving value for $valueName"
            if ( $currentSecurityPolicy.$section.keys -contains $valueName )
            {
                $resultValue = ($securityOptionData.$parameter.Option.GetEnumerator() | 
                    Where-Object -Property Value -eq $currentValue.Trim() ).Name
            }
            else
            {
                $resultValue = $null
            }
        }        
        $returnValue.Add( $parameter, $resultValue )    
    }
    return $returnValue
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [ValidateSet("Enabled","Disabled")]
        [System.String]
        $Accounts_Administrator_account_status,

        [ValidateSet("Enabled","Disabled")]
        [System.String]
        $Accounts_Block_Microsoft_accounts,

        [ValidateSet("Enabled","Disabled")]
        [System.String]
        $Accounts_Guest_account_status,

        [ValidateSet("Enabled","Disabled")]
        [System.String]
        $Accounts_Limit_local_account_use_of_blank_passwords_to_console_logon_only,

        [System.String]
        $Accounts_Rename_administrator_account,

        [System.String]
        $Accounts_Rename_guest_account,

        [ValidateSet("Enabled","Disabled")]
        [System.String]
        $Audit_Audit_the_access_of_global_system_objects,

        [ValidateSet("Enabled","Disabled")]
        [System.String]
        $Audit_Audit_the_use_of_Backup_and_Restore_privilege,

        [ValidateSet("Enabled","Disabled")]
        [System.String]
        $Audit_Force_audit_policy_subcategory_settings_Windows_Vista_or_later_to_override_audit_policy_category_settings,

        [ValidateSet("Enabled","Disabled")]
        [System.String]
        $Audit_Shut_down_system_immediately_if_unable_to_log_security_audits,

        [System.String]
        $DCOM_Machine_Access_Restrictions_in_Security_Descriptor_Definition_Language_SDDL_syntax,

        [System.String]
        $DCOM_Machine_Launch_Restrictions_in_Security_Descriptor_Definition_Language_SDDL_syntax,

        [System.String]
        $Devices_Allow_undock_without_having_to_log_on,

        [System.String]
        $Devices_Allowed_to_format_and_eject_removable_media,

        [System.String]
        $Devices_Prevent_users_from_installing_printer_drivers,

        [System.String]
        $Devices_Restrict_CD_ROM_access_to_locally_logged_on_user_only,

        [System.String]
        $Devices_Restrict_floppy_access_to_locally_logged_on_user_only,

        [System.String]
        $Domain_controller_Allow_server_operators_to_schedule_tasks,

        [System.String]
        $Domain_controller_LDAP_server_signing_requirements,

        [System.String]
        $Domain_controller_Refuse_machine_account_password_changes,

        [System.String]
        $Domain_member_Digitally_encrypt_or_sign_secure_channel_data_always,

        [System.String]
        $Domain_member_Digitally_encrypt_secure_channel_data_when_possible,

        [System.String]
        $Domain_member_Digitally_sign_secure_channel_data_when_possible,

        [System.String]
        $Domain_member_Disable_machine_account_password_changes,

        [System.String]
        $Domain_member_Maximum_machine_account_password_age,

        [System.String]
        $Domain_member_Require_strong_Windows_2000_or_later_session_key,

        [System.String]
        $Interactive_logon_Display_user_information_when_the_session_is_locked,

        [System.String]
        $Interactive_logon_Do_not_display_last_user_name,

        [System.String]
        $Interactive_logon_Do_not_require_CTRL_ALT_DEL,

        [System.String]
        $Interactive_logon_Machine_account_lockout_threshold,

        [System.String]
        $Interactive_logon_Machine_inactivity_limit,

        [System.String]
        $Interactive_logon_Message_text_for_users_attempting_to_log_on,

        [System.String]
        $Interactive_logon_Message_title_for_users_attempting_to_log_on,

        [System.String]
        $Interactive_logon_Number_of_previous_logons_to_cache_in_case_domain_controller_is_not_available,

        [System.String]
        $Interactive_logon_Prompt_user_to_change_password_before_expiration,

        [System.String]
        $Interactive_logon_Require_Domain_Controller_authenticatio_to_unlock_workstation,

        [System.String]
        $Interactive_logon_Require_smart_card,

        [System.String]
        $Interactive_logon_Smart_card_removal_behavior,

        [System.String]
        $Microsoft_network_client_Digitally_sign_communications_always,

        [System.String]
        $Microsoft_network_client_Digitally_sign_communications_if_server_agrees,

        [System.String]
        $Microsoft_network_client_Send_unencrypted_password_to_third_party_SMB_servers,

        [System.String]
        $Microsoft_network_server_Amount_of_idle_time_required_before_suspending_session,

        [System.String]
        $Microsoft_network_server_Attempt_S4U2Self_to_obtain_claim_information,

        [System.String]
        $Microsoft_network_server_Digitally_sign_communications_always,

        [System.String]
        $Microsoft_network_server_Digitally_sign_communications_if_client_agrees,

        [System.String]
        $Microsoft_network_server_Disconnect_clients_when_logon_hours_expire,

        [System.String]
        $Microsoft_network_server_Server_SPN_target_name_validation_level,

        [System.String]
        $Network_access_Allow_anonymous_SID_Name_translation,

        [System.String]
        $Network_access_Do_not_allow_anonymous_enumeration_of_SAM_accounts,

        [System.String]
        $Network_access_Do_not_allow_anonymous_enumeration_of_SAM_accounts_and_shares,

        [System.String]
        $Network_access_Do_not_allow_storage_of_passwords_and_credentials_for_network_authentication,

        [System.String]
        $Network_access_Let_Everyone_permissions_apply_to_anonymous_users,

        [System.String]
        $Network_access_Named_Pipes_that_can_be_accessed_anonymously,

        [System.String]
        $Network_access_Remotely_accessible_registry_paths,

        [System.String]
        $Network_access_Remotely_accessible_registry_paths_and_subpaths,

        [System.String]
        $Network_access_Restrict_anonymous_access_to_Named_Pipes_and_Shares,

        [System.String]
        $Network_access_Shares_that_can_be_accessed_anonymously,

        [System.String]
        $Network_access_Sharing_and_security_model_for_local_accounts,

        [System.String]
        $Network_security_Allow_Local_System_to_use_computer_identity_for_NTLM,

        [System.String]
        $Network_security_Allow_LocalSystem_NULL_session_fallback,

        [System.String]
        $Network_Security_Allow_PKU2U_authentication_requests_to_this_computer_to_use_online_identities,

        [System.String]
        $Network_security_Configure_encryption_types_allowed_for_Kerberos,

        [System.String]
        $Network_security_Do_not_store_LAN_Manager_hash_value_on_next_password_change,

        [System.String]
        $Network_security_Force_logoff_when_logon_hours_expire,

        [System.String]
        $Network_security_LAN_Manager_authentication_level,

        [System.String]
        $Network_security_LDAP_client_signing_requirements,

        [System.String]
        $Network_security_Minimum_session_security_for_NTLM_SSP_based_including_secure_RPC_clients,

        [System.String]
        $Network_security_Minimum_session_security_for_NTLM_SSP_based_including_secure_RPC_servers,

        [System.String]
        $Network_security_Restrict_NTLM_Add_remote_server_exceptions_for_NTLM_authentication,

        [System.String]
        $Network_security_Restrict_NTLM_Add_server_exceptions_in_this_domain,

        [System.String]
        $Network_Security_Restrict_NTLM_Incoming_NTLM_Traffic,

        [System.String]
        $Network_Security_Restrict_NTLM_NTLM_authentication_in_this_domain,

        [System.String]
        $Network_Security_Restrict_NTLM_Outgoing_NTLM_traffic_to_remote_servers,

        [System.String]
        $Network_Security_Restrict_NTLM_Audit_Incoming_NTLM_Traffic,

        [System.String]
        $Network_Security_Restrict_NTLM_Audit_NTLM_authentication_in_this_domain,

        [System.String]
        $Recovery_console_Allow_automatic_administrative_logon,

        [System.String]
        $Recovery_console_Allow_floppy_copy_and_access_to_all_drives_and_folders,

        [System.String]
        $Shutdown_Allow_system_to_be_shut_down_without_having_to_log_on,

        [System.String]
        $Shutdown_Clear_virtual_memory_pagefile,

        [System.String]
        $System_cryptography_Force_strong_key_protection_for_user_keys_stored_on_the_computer,

        [System.String]
        $System_cryptography_Use_FIPS_compliant_algorithms_for_encryption_hashing_and_signing,

        [System.String]
        $System_objects_Require_case_insensitivity_for_non_Windows_subsystems,

        [System.String]
        $System_objects_Strengthen_default_permissions_of_internal_system_objects_eg_Symbolic_Links,

        [System.String]
        $System_settings_Optional_subsystems,

        [System.String]
        $System_settings_Use_Certificate_Rules_on_Windows_Executables_for_Software_Restriction_Policies,

        [System.String]
        $User_Account_Control_Admin_Approval_Mode_for_the_Built_in_Administrator_account,

        [System.String]
        $User_Account_Control_Allow_UIAccess_applications_to_prompt_for_elevation_without_using_the_secure_desktop,

        [System.String]
        $User_Account_Control_Behavior_of_the_elevation_prompt_for_administrators_in_Admin_Approval_Mode,

        [System.String]
        $User_Account_Control_Behavior_of_the_elevation_prompt_for_standard_users,

        [System.String]
        $User_Account_Control_Detect_application_installations_and_prompt_for_elevation,

        [System.String]
        $User_Account_Control_Only_elevate_executables_that_are_signed_and_validated,

        [System.String]
        $User_Account_Control_Only_elevate_UIAccess_applications_that_are_installed_in_secure_locations,

        [System.String]
        $User_Account_Control_Run_all_administrators_in_Admin_Approval_Mode,

        [System.String]
        $User_Account_Control_Switch_to_the_secure_desktop_when_prompting_for_elevation,

        [System.String]
        $User_Account_Control_Virtualize_file_and_registry_write_failures_to_per_user_locations
    )

    $iniTemplate = @"
    [Unicode]
    Unicode=yes
    $systemAccessPolicies
    [Version]
    signature="`$CHICAGO`$"
    Revision=1
    $registryPolicies
"@

    # create a variable with the desired 'System Access' polices

    # create a variable with the desired 'Registry Values' policies
    # if a string option ensure desired value is appended
    # add the variables to the iniTemplate

}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [ValidateSet("Enabled","Disabled")]
        [System.String]
        $Accounts_Administrator_account_status,

        [ValidateSet("Enabled","Disabled")]
        [System.String]
        $Accounts_Block_Microsoft_accounts,

        [ValidateSet("Enabled","Disabled")]
        [System.String]
        $Accounts_Guest_account_status,

        [ValidateSet("Enabled","Disabled")]
        [System.String]
        $Accounts_Limit_local_account_use_of_blank_passwords_to_console_logon_only,

        [System.String]
        $Accounts_Rename_administrator_account,

        [System.String]
        $Accounts_Rename_guest_account,

        [ValidateSet("Enabled","Disabled")]
        [System.String]
        $Audit_Audit_the_access_of_global_system_objects,

        [ValidateSet("Enabled","Disabled")]
        [System.String]
        $Audit_Audit_the_use_of_Backup_and_Restore_privilege,

        [ValidateSet("Enabled","Disabled")]
        [System.String]
        $Audit_Force_audit_policy_subcategory_settings_Windows_Vista_or_later_to_override_audit_policy_category_settings,

        [ValidateSet("Enabled","Disabled")]
        [System.String]
        $Audit_Shut_down_system_immediately_if_unable_to_log_security_audits,

        [System.String]
        $DCOM_Machine_Access_Restrictions_in_Security_Descriptor_Definition_Language_SDDL_syntax,

        [System.String]
        $DCOM_Machine_Launch_Restrictions_in_Security_Descriptor_Definition_Language_SDDL_syntax,

        [System.String]
        $Devices_Allow_undock_without_having_to_log_on,

        [System.String]
        $Devices_Allowed_to_format_and_eject_removable_media,

        [System.String]
        $Devices_Prevent_users_from_installing_printer_drivers,

        [System.String]
        $Devices_Restrict_CD_ROM_access_to_locally_logged_on_user_only,

        [System.String]
        $Devices_Restrict_floppy_access_to_locally_logged_on_user_only,

        [System.String]
        $Domain_controller_Allow_server_operators_to_schedule_tasks,

        [System.String]
        $Domain_controller_LDAP_server_signing_requirements,

        [System.String]
        $Domain_controller_Refuse_machine_account_password_changes,

        [System.String]
        $Domain_member_Digitally_encrypt_or_sign_secure_channel_data_always,

        [System.String]
        $Domain_member_Digitally_encrypt_secure_channel_data_when_possible,

        [System.String]
        $Domain_member_Digitally_sign_secure_channel_data_when_possible,

        [System.String]
        $Domain_member_Disable_machine_account_password_changes,

        [System.String]
        $Domain_member_Maximum_machine_account_password_age,

        [System.String]
        $Domain_member_Require_strong_Windows_2000_or_later_session_key,

        [System.String]
        $Interactive_logon_Display_user_information_when_the_session_is_locked,

        [System.String]
        $Interactive_logon_Do_not_display_last_user_name,

        [System.String]
        $Interactive_logon_Do_not_require_CTRL_ALT_DEL,

        [System.String]
        $Interactive_logon_Machine_account_lockout_threshold,

        [System.String]
        $Interactive_logon_Machine_inactivity_limit,

        [System.String]
        $Interactive_logon_Message_text_for_users_attempting_to_log_on,

        [System.String]
        $Interactive_logon_Message_title_for_users_attempting_to_log_on,

        [System.String]
        $Interactive_logon_Number_of_previous_logons_to_cache_in_case_domain_controller_is_not_available,

        [System.String]
        $Interactive_logon_Prompt_user_to_change_password_before_expiration,

        [System.String]
        $Interactive_logon_Require_Domain_Controller_authenticatio_to_unlock_workstation,

        [System.String]
        $Interactive_logon_Require_smart_card,

        [System.String]
        $Interactive_logon_Smart_card_removal_behavior,

        [System.String]
        $Microsoft_network_client_Digitally_sign_communications_always,

        [System.String]
        $Microsoft_network_client_Digitally_sign_communications_if_server_agrees,

        [System.String]
        $Microsoft_network_client_Send_unencrypted_password_to_third_party_SMB_servers,

        [System.String]
        $Microsoft_network_server_Amount_of_idle_time_required_before_suspending_session,

        [System.String]
        $Microsoft_network_server_Attempt_S4U2Self_to_obtain_claim_information,

        [System.String]
        $Microsoft_network_server_Digitally_sign_communications_always,

        [System.String]
        $Microsoft_network_server_Digitally_sign_communications_if_client_agrees,

        [System.String]
        $Microsoft_network_server_Disconnect_clients_when_logon_hours_expire,

        [System.String]
        $Microsoft_network_server_Server_SPN_target_name_validation_level,

        [System.String]
        $Network_access_Allow_anonymous_SID_Name_translation,

        [System.String]
        $Network_access_Do_not_allow_anonymous_enumeration_of_SAM_accounts,

        [System.String]
        $Network_access_Do_not_allow_anonymous_enumeration_of_SAM_accounts_and_shares,

        [System.String]
        $Network_access_Do_not_allow_storage_of_passwords_and_credentials_for_network_authentication,

        [System.String]
        $Network_access_Let_Everyone_permissions_apply_to_anonymous_users,

        [System.String]
        $Network_access_Named_Pipes_that_can_be_accessed_anonymously,

        [System.String]
        $Network_access_Remotely_accessible_registry_paths,

        [System.String]
        $Network_access_Remotely_accessible_registry_paths_and_subpaths,

        [System.String]
        $Network_access_Restrict_anonymous_access_to_Named_Pipes_and_Shares,

        [System.String]
        $Network_access_Shares_that_can_be_accessed_anonymously,

        [System.String]
        $Network_access_Sharing_and_security_model_for_local_accounts,

        [System.String]
        $Network_security_Allow_Local_System_to_use_computer_identity_for_NTLM,

        [System.String]
        $Network_security_Allow_LocalSystem_NULL_session_fallback,

        [System.String]
        $Network_Security_Allow_PKU2U_authentication_requests_to_this_computer_to_use_online_identities,

        [System.String]
        $Network_security_Configure_encryption_types_allowed_for_Kerberos,

        [System.String]
        $Network_security_Do_not_store_LAN_Manager_hash_value_on_next_password_change,

        [System.String]
        $Network_security_Force_logoff_when_logon_hours_expire,

        [System.String]
        $Network_security_LAN_Manager_authentication_level,

        [System.String]
        $Network_security_LDAP_client_signing_requirements,

        [System.String]
        $Network_security_Minimum_session_security_for_NTLM_SSP_based_including_secure_RPC_clients,

        [System.String]
        $Network_security_Minimum_session_security_for_NTLM_SSP_based_including_secure_RPC_servers,

        [System.String]
        $Network_security_Restrict_NTLM_Add_remote_server_exceptions_for_NTLM_authentication,

        [System.String]
        $Network_security_Restrict_NTLM_Add_server_exceptions_in_this_domain,

        [System.String]
        $Network_Security_Restrict_NTLM_Incoming_NTLM_Traffic,

        [System.String]
        $Network_Security_Restrict_NTLM_NTLM_authentication_in_this_domain,

        [System.String]
        $Network_Security_Restrict_NTLM_Outgoing_NTLM_traffic_to_remote_servers,

        [System.String]
        $Network_Security_Restrict_NTLM_Audit_Incoming_NTLM_Traffic,

        [System.String]
        $Network_Security_Restrict_NTLM_Audit_NTLM_authentication_in_this_domain,

        [System.String]
        $Recovery_console_Allow_automatic_administrative_logon,

        [System.String]
        $Recovery_console_Allow_floppy_copy_and_access_to_all_drives_and_folders,

        [System.String]
        $Shutdown_Allow_system_to_be_shut_down_without_having_to_log_on,

        [System.String]
        $Shutdown_Clear_virtual_memory_pagefile,

        [System.String]
        $System_cryptography_Force_strong_key_protection_for_user_keys_stored_on_the_computer,

        [System.String]
        $System_cryptography_Use_FIPS_compliant_algorithms_for_encryption_hashing_and_signing,

        [System.String]
        $System_objects_Require_case_insensitivity_for_non_Windows_subsystems,

        [System.String]
        $System_objects_Strengthen_default_permissions_of_internal_system_objects_eg_Symbolic_Links,

        [System.String]
        $System_settings_Optional_subsystems,

        [System.String]
        $System_settings_Use_Certificate_Rules_on_Windows_Executables_for_Software_Restriction_Policies,

        [System.String]
        $User_Account_Control_Admin_Approval_Mode_for_the_Built_in_Administrator_account,

        [System.String]
        $User_Account_Control_Allow_UIAccess_applications_to_prompt_for_elevation_without_using_the_secure_desktop,

        [System.String]
        $User_Account_Control_Behavior_of_the_elevation_prompt_for_administrators_in_Admin_Approval_Mode,

        [System.String]
        $User_Account_Control_Behavior_of_the_elevation_prompt_for_standard_users,

        [System.String]
        $User_Account_Control_Detect_application_installations_and_prompt_for_elevation,

        [System.String]
        $User_Account_Control_Only_elevate_executables_that_are_signed_and_validated,

        [System.String]
        $User_Account_Control_Only_elevate_UIAccess_applications_that_are_installed_in_secure_locations,

        [System.String]
        $User_Account_Control_Run_all_administrators_in_Admin_Approval_Mode,

        [System.String]
        $User_Account_Control_Switch_to_the_secure_desktop_when_prompting_for_elevation,

        [System.String]
        $User_Account_Control_Virtualize_file_and_registry_write_failures_to_per_user_locations
    )

    $currentSecurityOptions = Get-TargetResource -Name $Name

    $desiredSecurityOptions = $PSBoundParameters

    foreach ( $policy in $desiredSecurityOptions.Keys )
    {
        if ( $currentSecurityOptions.ContainsKey( $policy ) )
        {
            if ( $currentSecurityOptions[$policy] -ne $desiredSecurityOptions[$policy] )
            {
                return $false
            }            
        }
    }

    # if the code made it this far we must be in a desired state
    return $true
}

<#
    .SYNOPSIS
        Retrieves the Security Option Data to map the policy name and values as they appeat in the Security Template Snap-in

    .PARAMETER FilePath
        Path to the file containing the Security Option Data

    .NOTES
        General notes
#>
function Get-SecurityOptionData
{
    [OutputType([hashtable])]
    [CmdletBinding()]
    Param 
    (
        [Parameter()]
        [Microsoft.PowerShell.DesiredStateConfiguration.ArgumentToConfigurationDataTransformation()]
        [hashtable]
        $FilePath = ("$PSScriptRoot\SecurityOptionData.psd1").Normalize()
    )
    return $FilePath
}

function Get-SecurityOptionParameter
{
    [OutputType([array])]
    [CmdletBinding()]
    Param ()

    $commonParameters = @( 'Name' )
    $commonParameters += [System.Management.Automation.PSCmdlet]::CommonParameters
    $commonParameters += [System.Management.Automation.PSCmdlet]::OptionalCommonParameters
    $moduleParameters = ( Get-Command -Name Set-TargetResource -Module MSFT_SecurityOption ).Parameters.Keys | 
        Where-Object -FilterScript { $PSItem -notin $commonParameters }

    return $moduleParameters
}

function Add-PolicyOption
{
    [OutputType([string])]
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [string[]]
        $SystemAccessPolicies,

        [Parameter()]
        [string[]]
        $RegistryPolicies
    )

    $iniTemplate = @(
        "[Unicode]"
        "Unicode=yes"
        $systemAccessPolicies
        "[Version]"
        'signature="$CHICAGO$"'
        "Revision=1"
        $registryPolicies
    )

    return $iniTemplate

}

# Export-ModuleMember -Function *-TargetResource

