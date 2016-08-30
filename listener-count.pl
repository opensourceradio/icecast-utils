#!/usr/bin/perl

use 5.014;			# so keys/values/each work on scalars
no warnings qw(experimental::autoderef); # quiet some warnings

use strict;

use Data::Dumper;
use Getopt::Long;
Getopt::Long::Configure ( "bundling" );
use Pod::Usage;
use LWP;

use constant URL => 'http://YOUR.HOSTNAME.HERE:YOUR-PORT-NUMBER-HERE/listener-count.xsl';

sub main ();
sub max ( $$$ );

main;

1;

sub main () {
    my ( $result, $verbose, $debug, $help, $man ) = ( 0, 0, 0, 0, 0 );
    my $output = $ENV{'LISTENER_COUNT'} || '/var/tmp/listener-count';

    my $ua = LWP::UserAgent->new();
    my $request = undef;
    my $response = undef;

    $result = GetOptions (
	"output|o=s" => \$output,
	"verbose|v" => \$verbose,
	"debug|d" => \$debug,
	"help|h" => \$help,
	"man|m" => \$man,
	);
    die "GetOptions returned " . $result . ". Stopped" if ( ! $result );

    pod2usage ( 1 )             if ( defined ( $help ) && $help );
    pod2usage ( -verbose => 2 ) if ( defined ( $man ) && $man );

    # see LWP
    $ua->agent( 'DataRetrieval/0.1 ' );

    $request = HTTP::Request->new( GET => URL );
    $response = $ua->request( $request );
    if ( $response->is_success()) {
	my $currentTime = time();
	my $content = $response->content();
	my @mounts = ();
	my $current = undef;

	$content =~ s{^/}{};

	@mounts = split( /\//, $content );
	chomp( @mounts );

	# this makes a hash of {mountpoint}->{count}, {mountpoint}->{time} for each mount point
	my $mountcount = map {
	    my( $mountpoint, $count, $junk ) = split( /:/, $_ );
	    $current->{$mountpoint}->{count} = $count;
	    $current->{$mountpoint}->{time} = $currentTime;
	} @mounts;

	print STDERR "Mounts: ", $mountcount, "\n", Data::Dumper->Dump( [$current], [qw(current)] ), "\n" if $verbose;

	open( OUT, ">$output" ) || die "Cannot open $output for writing ($!). Stopped";

	foreach my $mount ( keys( $current )) {
	    print OUT $mount, ":", $current->{$mount}->{count}, ":", $current->{$mount}->{time}, "\n";
	}

	close( OUT );

	max( $current, $verbose, $debug );

    } else {
	die "HTTP request failed: " . $response->status_line . ". Stopped";
    }
}

# rewrite the max file if necessary
# return true or false depending on whether we rewrote it
sub max ( $$$ ) {
    my $current = shift;
    my $verbose = shift;
    my $debug = shift;

    my $maximum = undef;
    my $touched = 0;

    my $maxfile = $ENV{'LISTENER_COUNT_MAX'} || '/var/tmp/listener-count-max';

    open( MAX, $maxfile ) || die "Cannot open $maxfile for reading ($!). Stopped";
    my @maximums = <MAX>;
    close( MAX );
    chomp( @maximums );

    foreach my $max ( @maximums ) {
	my ( $mountpoint, $count, $time ) = split( /:/, $max );

	# use the new values and set a flag if the new count for this
	# mount point is greater than the previous count
	if ( $current->{$mountpoint}->{count} > $count ) {
	    $maximum->{$mountpoint}->{count} = $current->{$mountpoint}->{count};
	    $maximum->{$mountpoint}->{time} = $current->{$mountpoint}->{time};
	    $touched = 1;
	    print STDERR "New maximum value for ", $mountpoint, ": ", $maximum->{$mountpoint}->{count}, "\n";
	} else {
	    $maximum->{$mountpoint}->{count} = $count;
	    $maximum->{$mountpoint}->{time} = $time;
	}
    }

    print STDERR Data::Dumper->Dump( [$maximum], [qw(maximum)] ), "\n" if $debug;

    if ( $touched ) {
	open( MAX, ">$maxfile" ) || die "Cannot open $maxfile for writing ($!). Stopped";

	foreach my $mountpoint ( keys( $maximum )) {
	    print MAX $mountpoint, ":", $maximum->{$mountpoint}->{count}, ":", $maximum->{$mountpoint}->{time}, "\n";
	}

	close( MAX );
    }

    $touched;
}
