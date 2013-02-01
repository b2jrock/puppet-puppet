# This manifests does the sanity checking in preparation of installing the puppet client

class puppet (
	$pluginsync 					= false,
	$puppetlabs_repo			= false,
	$storeconfigs					= false,
	$user_shell						= false,
	$environments					= false,
	$hiera_config_file		= false,
	$hiera_config_source	= false,
	$hiera_backend_yaml		= true,
	$hiera_backend_json		= false,
	$hiera_datadir				= false,
	$hiera_hierarchy			= ['commmon']
){

	include puppet::params

	case $operatingsystem {
		Ubuntu:{
			class{'puppet::install':
				pluginsync					=> $pluginsync,
				puppetlabs_repo 		=> $puppetlabs_repo,
				storeconfigs				=> $storeconfigs,
				user_shell					=> $user_shell,
				environments				=> $environments,
				hiera_config_file		=> $hiera_config_file ? {
					false 	=> $puppet::params::hiera_config_file,
					default	=> $hira_config_file,
				},
				hiera_config_source	=> $hiera_config_source,
				hiera_backend_yaml	=> $hiera_backend_yaml,
				hiera_backend_json	=> $hiera_backend_json,
				hiera_datadir				=> $hiera_datadir ? {
					false		=> $environments ? {
						false 	=> $puppet::params::hiera_datadir,
						default	=> $puppet::params::hiera_envs_datadir,
					},
					default	=> $hiera_datadir,
				},
				hiera_hierarchy 			=> $hiera_hierarchy,
			}
		}
		default:{
			warning("Puppet module is not configured for $operatingsystem on $fqdn.")
		}
	}
}