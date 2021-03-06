# #
# Software subject to following license(s):
#   Apache 2 License (http://www.opensource.org/licenses/apache2.0)
#   Copyright (c) Responsible Organization
#

# #
# Current developer(s):
#   Guillaume PHILIPPON <guillaume.philippon@lal.in2p3.fr>
#

# #
# Author(s): Jane SMITH, Joe DOE
#

# # 
# claudia, 1.1-SNAPSHOT, 20110622.1847.32
#

package NCM::Component::claudia;

use strict;
use warnings;

use base qw(NCM::Component);

use LC::Exception;
use LC::Find;
use LC::File qw(copy makedir);

use EDG::WP4::CCM::Element;
use CAF::FileWriter;
use CAF::FileEditor;
use CAF::Process;
use File::Basename;
use File::Path;

use Readonly;
Readonly::Scalar my $PATH => '/software/components/claudia';

Readonly::Scalar my $RESTART => '/etc/init.d/claudia restart';

our $EC=LC::Exception::Context->new->will_store_all;

my $header = '####
#
# This file was generated by ncm-claudia.
# Please, do not edit it yourself. All your change
# will be remove on next quattor update.
#
';


sub Configure {
    my ($self, $config) = @_;

    # Get full tree of configuration information for component.
    my $t = $config->getElement($PATH)->getTree();
    my $cfg_sm     = $t->{'sm-config'};
    my $cfg_report = $t->{'reportClient-config'};
    my $cfg_tcloud = $t->{'tcloud-config'};

    # Create sm.properties file for Claudia
    my $sm_config_file = $cfg_sm->{'config_file'};
    my $contents = '';

    $contents .= ConfigureSm($cfg_sm);

    # Create the configuration file.
    my $sm_config = LC::Check::file(
           $sm_config_file,
           contents => $header.$contents,
           mode => 0644
        );
        if ( $sm_config < 0 ) {
          $self->error("Error creating $sm_config_file");
        }
  
    # Create reportClient.properties file for Claudia 
    my $report_config_file = $cfg_report->{ 'config_file' };
    $contents = '';

    $contents .= ConfigureReportClient($cfg_report);

    my $report_config = LC::Check::file(
	 $report_config_file,
	 contents => $header.$contents,
	 mode => 0644
    );
    if ( $report_config < 0 ) {
	$self->error("Error creating $report_config_file");
    }

   # Create tcloud.properties file
   my $tcloud_config_file = $cfg_tcloud->{ 'config_file' };
   $contents = '';

   $contents .= ConfigureTcloud($cfg_tcloud);

   my $tcloud_config = LC::Check::file(
        $tcloud_config_file,
        contents => $header.$contents,
        mode => 0644
  );
  if ( $tcloud_config < 0 ) {
      $self->error("Error creating $tcloud_config_file");
  }

}

sub ConfigureSm {
	my ($sm_config) = @_;
	my $contents = '';

	$contents .= "\n# JND Connection Properties\n";
	while ((my $k,my $v) = each(%{$sm_config->{java}}) ) {
     		$contents .= $k." = ".$v."\n";
    	}

	$contents .= "\n# Events Monitorization Rest Bus connection parameters\n";
	while ((my $k, my $v) = each(%{$sm_config->{'rest'}})) {
		$contents .= $k." = ".$v."\n";
	}

	$contents .= "\n#SMI Rest Server connection parameters\n";
	while ((my $k,my $v) = each(%{$sm_config->{SMI}}) ) {
     		$contents .= $k." = ".$v."\n";
    	}

	$contents .= "\n# HTTP Server for disk images\n";
	while ((my $k, my $v) = each(%{$sm_config->{'ImageServer'}})) {
		$contents .= $k." = ".$v."\n";
	}
	
	$contents .= "\n# VEEM Address.\n";
	while ((my $k, my $v) = each(%{$sm_config->{'VEEM'}})) {
		if ( $k eq 'ExtendedOCCI') {
		  $contents .= $k." = ".bool_to_string($v)."\n";
		} else {
		  $contents .= $k." = ".$v."\n";
		}
	}

	$contents .= "\n#Undeploy on server stop\n";
	$contents .= "UndeployOnServerStop = ".bool_to_string($sm_config->{'UndeployOnServerStop'})."\n";

	$contents .= "\n#ACD related info\n";
	$contents .= "ActivateAcd = ".bool_to_string($sm_config->{'ActivateAcd'})."\n";

	$contents .= "\n#Multicast monitoring address\n";
	$contents .= "MonitoringAddress = ".$sm_config->{'MonitoringAddress'}."\n";

	$contents .= "\n# WASUP Address.\n";
	while ((my $k, my $v) = each(%{$sm_config->{'WASUP'}})) {
		$contents .= $k." = ".$v."\n";
	}

	$contents .= "\n#Site root (used as FQN prefix)\n";
	$contents .= "SiteRoot = ".$sm_config->{'SiteRoot'}."\n";

	$contents .= "\n# Network ranges available for Service Manager use\n";
	$contents .= "NetworkRanges = ";
	my $net_length = @{$sm_config->{'NetworkRanges'}};
	my $net_i = 0;
	foreach my $i (@{$sm_config->{'NetworkRanges'}}) {
		$contents .= "[";

		# sm.properties NetworkRanges must be in a fixed order
		# [IP:ip_value,Netmask:nmask_value,Gateway:gw_value,DNS:dns_value]

		if ( exists ($i->{'Network'}) ) {
			$contents .= "Network:".$i->{'Network'}.";";
		};
		$contents .= "IP:".$i->{'IP'}.";";
		$contents .= "Netmask:".$i->{'Netmask'}.";";
		$contents .= "Gateway:".$i->{'Gateway'}.";";
		$contents .= "DNS:".$i->{"DNS"}.";";
		$contents .= "Public:".bool_to_yesno($i->{'Public'}).";";
		$contents .= "]";
		$net_i++;
		if ( $net_i != $net_length) {
			$contents .= ",";	
		}
	}

	$contents .= "\n# Mac Address\n";
	$contents .= "MacEnabled = ".bool_to_string($sm_config->{'NetworkMac'}->{'MacEnabled'})."\n";
	$contents .= "NetworkMacList = ".$sm_config->{'NetworkMac'}->{'NetworkMacList'}."\n";

        if ( exists ($sm_config->{'StaticIpList'}) ) {
        	$contents .= "StaticIpList = ".$sm_config->{'StaticIpList'}."\n";
        }

	$contents .= "\nDomainName = ".$sm_config->{'DomainName'}."\n";

	$contents .= "\n#Setting the following to false disable the generation of <Entity> in OVF\n#Environments, which *violated DMTF DSP0243*\n";
	$contents .= "OVFEnvEntityGen = ".bool_to_string($sm_config->{'OVFEnvEntityGen'})."\n";

	return $contents;
};

sub ConfigureReportClient {
        my ($report_config) = @_;
        my $contents = '';

	$contents .= "TServer.url=".$report_config->{'TServer.url'}."\n";
        $contents .= "vmDiscoverDelay=".$report_config->{'vmDiscoverDelay'}."\n";
        $contents .= "monitoringDelay=".$report_config->{'monitoringDelay'}."\n";

        if (exists ($report_config->{'vmMonName'})) {
		$contents .= 'vmMonName='.$report_config->{'vmMonName'}."\n";
	} else {
		$contents .= "vmMonName=all\n";
	};

	if (exists ($report_config->{'MonitorName'})) {
		$contents .= "MonitorName=".$report_config->{'MonitorName'}."\n";
	} else {
		$contents .= "MonitorName=all\n";
	};

	$contents .= 'restPath='.$report_config->{'restPath'}."\n";
	$contents .= 'restServerPort='.$report_config->{'restServerPort'}."\n";
	$contents .= 'restServerHost='.$report_config->{'restServerHost'}."\n";

	$contents .= 'rootReportDirectory='.$report_config->{'rootReportDirectory'}."\n";

	$contents .= 'SiteRoot='.$report_config->{'SiteRoot'}."\n";

	return $contents;
};

sub ConfigureTcloud {
	my ($tcloud_config) = @_;
	my $contents = '';

	$contents .= "# TCloud Server Configuration file
#--------------------------------------------------------------------------------------
# Drivers\n";
	$contents .= 'com.telefonica.claudia.smi.drivers.deployment='.$tcloud_config->{'com.telefonica.claudia.smi.drivers.deployment'}."\n";
	$contents .= 'com.telefonica.claudia.smi.drivers.provisioning='.$tcloud_config->{'com.telefonica.claudia.smi.drivers.provisioning'}."\n";
	$contents .= '#com.telefonica.claudia.smi.drivers.monitoring='.$tcloud_config->{'com.telefonica.claudia.smi.drivers.monitoring'}."\n";

	$contents .= "# Server the TCloud is installed in.\n";
	$contents .= 'com.telefonica.claudia.server.host='.$tcloud_config->{'com.telefonica.claudia.server.host'}."\n";
	$contents .= 'com.telefonica.claudia.server.port='.$tcloud_config->{'com.telefonica.claudia.server.port'}."\n";
	$contents .= 'com.telefonica.claudia.customization.port='.$tcloud_config->{'com.telefonica.claudia.customization.port'}."\n";

	$contents .= "# SM Driver Configuration Section
#--------------------------------------------------------------------------------------

# JNDI Connection properties (for Bus interaction)\n";
	$contents .= 'java.naming.factory.initial='.$tcloud_config->{'java.naming.factory.initial'}."\n";
	$contents .= 'java.naming.provider.url='.$tcloud_config->{'java.naming.provider.url'}."\n";

	$contents .= "# ONE Driver Configuration Section
#--------------------------------------------------------------------------------------\n";
	$contents .= 'oneUrl='.$tcloud_config->{'oneUrl'}."\n";
	$contents .= 'oneUser='.$tcloud_config->{'oneUser'}."\n";
	$contents .= 'onePassword='.$tcloud_config->{'onePassword'}."\n";
	$contents .= 'oneEnvironmentPath='.$tcloud_config->{'oneEnvironmentPath'}."\n";
	$contents .= 'oneKernel='.$tcloud_config->{'oneKernel'}."\n";
	$contents .= 'oneInitrd='.$tcloud_config->{'oneInitrd'}."\n";
	$contents .= 'oneNetworkBridge='.$tcloud_config->{'oneNetworkBridge'}."\n";
	$contents .= 'oneSshKey="'.$tcloud_config->{'oneSshKey'}."\"\n";

	$contents .= "# VMWare Driver Configuration Section
#--------------------------------------------------------------------------------------\n";
	$contents .= 'vmwareUrl='.$tcloud_config->{'vmwareUrl'}."\n";
	$contents .= 'vmwareUser='.$tcloud_config->{'vmwareUser'}."\n";
	if ( exists ($tcloud_config->{'vmwarePassword'})) {
		$contents .= 'vmwarePassword='.$tcloud_config->{'vmwarePassword'}."\n";
	} else {
		$contents .= "vmwarePassword=tcloud6000\n";
	}

	$contents .= "# Monitoring Driver Configuration Section
#--------------------------------------------------------------------------------------\n";
	$contents .= 'monitoring.wasup.uri='.$tcloud_config->{'monitoring.wasup.uri'}."\n";
	$contents .= 'monitoring.wasup.login='.$tcloud_config->{'monitoring.wasup.login'}."\n";
	if ( exists ($tcloud_config->{'monitoring.wasup.password'})) {
		$contents .= 'monitoring.wasup.password='.$tcloud_config->{'monitoring.wasup.password'}."\n";
	} else {
		$contents .= "monitoring.wasup.password=rps1\n";
	}

	return $contents;
};

sub bool_to_yesno {
	my ($bool) = @_;

	if ($bool) {
		return "yes";
	} else {
		return "no";
	}
};

sub bool_to_string {
	my ($bool) = @_;

	if ($bool) {
		return "true";
	} else {
		return "false";
	}
};

1; # Required for perl module!
