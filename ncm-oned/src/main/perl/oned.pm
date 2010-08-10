################################################################################
#
# VERSION:    @VERSION@, @DATE@
# AUTHOR:     @AUTHOR@
# MAINTAINER: @MAINTAINER@
# LICENSE:    @LICENSE@
#
################################################################################

package NCM::Component::@COMP@;

use strict;
use warnings;
use NCM::Component;
use EDG::WP4::CCM::Property;
use NCM::Check;
use FileHandle;

use LC::File qw (makedir);

use constant PATH => '/software/components/@COMP@';
use constant COMPONENT_NAME => '@COMP@';

our @ISA = qw (NCM::Component);
our $EC = LC::Exception::Context->new->will_store_all;

# If the value isn't a number, then quotes are added.
sub quoteValue {
    my ($v) = @_;
    return (($v =~ /^\d*$/) ? $v :  '"' . $v . '"');    
}

# Write out hash as sequence of key/value pairs.
sub writeKeyValuePairs {
    my (%pairs) = %{$_[0]};

    my @entries;
    foreach my $k (sort keys %pairs) {
        my $v = quoteValue($pairs{$k});
        push @entries, $k . '=' . $v;
    }

    $_[1] .= join("\n", @entries) . "\n";
}

# Write out the database parameters.
sub writeDatabaseParams {
    my (%pairs) = %{$_[0]};

    my @entries;
    foreach my $k (sort keys %pairs) {
        my $v = quoteValue($pairs{$k});
        push @entries, $k . '=' . $v;
    }

    $_[1] .= "DB=[ ";
    $_[1] .= join(",\n    ", @entries);
    $_[1] .= " ]\n";
}

# Write a single MAD definition.  
sub writeMad {
    my (%pairs) = %{$_[0]};
    my $name = $_[1];

    my $label = $pairs{'manager'} . '_MAD';

    my @entries;
    push @entries, 'name="' . $name . '"';
    foreach my $k (sort keys %pairs) {
        if ($k ne 'manager') {
            my $v = quoteValue($pairs{$k});
            push @entries, $k . '=' . $v;
        }
    }

    $_[2] .= $label . "=[ ";
    $_[2] .= join(",\n    ", @entries);
    $_[2] .= " ]\n\n";
}

# Process a hash of MAD definitions.
sub processMads {
    my (%pairs) = %{$_[0]};

    foreach my $k (sort keys %pairs) {
        my %hvalue = %{$pairs{$k}};
        writeMad(\%hvalue, $k, $_[1]);
    }

}

# Process a single hook definition.
sub writeHook {
    my (%pairs) = %{$_[0]};
    my $name = $_[1];

    my @entries;
    push @entries, 'name="' . $name . '"';
    foreach my $k (sort keys %pairs) {
        my $v = quoteValue($pairs{$k});
        push @entries, $k . '=' . $v;
    }

    $_[2] .= "VM_HOOK=[ ";
    $_[2] .= join(",\n    ", @entries);
    $_[2] .= " ]\n\n";
}

# Process a hash of hook definitions.
sub processHooks {
    my (%pairs) = %{$_[0]};

    foreach my $k (sort keys %pairs) {
        my %hvalue = %{$pairs{$k}};
        writeHook(\%hvalue, $k, $_[1]);
    }

}

sub Configure {
    my ($self, $config) = @_;

    my $t = $config->getElement(PATH)->getTree;

    # First retrieve the installation location and determine
    # configuration file location.
    my $location = $t->{'location'};
    my $file = $location . '/etc/oned.conf';

    # Accumulate the configuration in a string.
    my $contents = 
        "#\n". 
        '# autogenerated by ' . 
        COMPONENT_NAME .
        " configuration module\n" . 
        "#\n";

    $contents .= "\n# general parameters\n\n";
    my %pairs = %{$t->{'daemon'}};
    writeKeyValuePairs(\%pairs, $contents);

    $contents .= "\n# database parameters\n\n";
    %pairs = %{$t->{'db'}};
    writeDatabaseParams(\%pairs, $contents);

    $contents .= "\n# networking parameters\n\n";
    %pairs = %{$t->{'network'}};
    writeKeyValuePairs(\%pairs, $contents);

    $contents .= "\n# image repository parameters\n\n";
    %pairs = %{$t->{'image_repos'}};
    writeKeyValuePairs(\%pairs, $contents);

    $contents .= "\n# MAD definitions\n\n";
    %pairs = %{$t->{'mads'}};
    processMads(\%pairs, $contents);

    $contents .= "\n# hook definitions\n\n";
    %pairs = %{$t->{'hooks'}};
    processHooks(\%pairs, $contents);

    # Write out the contents of the configuration file.
    open(FH, ">" . $file);
    print FH $contents;
    close(FH);

    return 1;
}

1;
