use strict;
use Irssi;
use vars qw($VERSION %IRSSI);

use MIME::Base64;

$VERSION = "1.1";

%IRSSI = (
    authors     => 'Michael Tharp and Jilles Tjoelker',
    contact     => 'gxti@partiallystapled.com',
    name        => 'cap_sasl.pl',
    description => 'Implements PLAIN SASL authentication mechanism for use with charybdis ircds, and enables CAP MULTI-PREFIX',
    license     => 'GNU General Public License',
    url         => 'http://sasl.charybdis.be/',
);

my %sasl_auth = ();

sub timeout;

sub server_connected {
	my $server = shift;
	$server->send_raw_now("CAP LS");
}

sub event_cap {
	my ($server, $args, $nick, $address) = @_;
	my ($subcmd, $caps, $tosend);

	$tosend = '';
	if ($args =~ /^\S+ (\S+) :(.*)$/) {
		$subcmd = uc $1;
		$caps = ' '.$2.' ';
		if ($subcmd eq 'LS') {
			$tosend .= ' multi-prefix' if $caps =~ / multi-prefix /i;
			$tosend .= ' sasl' if $caps =~ / sasl /i && defined($sasl_auth{$server->{tag}});
			$tosend =~ s/^ //;
			$server->print('', "CLICAP: supported by server:$caps");
			if (!$server->{connected}) {
				if ($tosend eq '') {
					$server->send_raw_now("CAP END");
				} else {
					$server->print('', "CLICAP: requesting: $tosend");
					$server->send_raw_now("CAP REQ :$tosend");
				}
			}
			Irssi::signal_stop();
		} elsif ($subcmd eq 'ACK') {
			$server->print('', "CLICAP: now enabled:$caps");
			if ($caps =~ / sasl /i) {
				$server->send_raw_now("AUTHENTICATE PLAIN");
				Irssi::timeout_add_once(25000, \&timeout, $server->{tag});
			}
			elsif (!$server->{connected}) {
				$server->send_raw_now("CAP END");
			}
			Irssi::signal_stop();
		} elsif ($subcmd eq 'NAK') {
			$server->print('', "CLICAP: refused:$caps");
			if (!$server->{connected}) {
				$server->send_raw_now("CAP END");
			}
			Irssi::signal_stop();
		} elsif ($subcmd eq 'LIST') {
			$server->print('', "CLICAP: currently enabled:$caps");
			Irssi::signal_stop();
		}
	}
}

sub event_authenticate {
	my ($server, $args, $nick, $address) = @_;

	advance_sasl($server, $args);
}

sub event_saslend {
	my ($server, $args, $nick, $address) = @_;
	my $data;

	$data = $args;
	$data =~ s/^\S+ :?//;
	# need this to see it, ?? -- jilles
	$server->print('', $data);
	if (!$server->{connected}) {
		$server->send_raw_now("CAP END");
	}
}

sub timeout {
	my $tag = shift;
	my $server = Irssi::server_find_tag($tag);
	if (ref($server) && !$server->{connected}) {
		$server->print('', "SASL authentication timed out");
		$server->send_raw_now("CAP END");
	}
}

sub advance_sasl {
	my($server, $data) = @_;
	my ($net, $u, $p);
 
	$net = $server->{tag};
	$u = $sasl_auth{$net}{user};
	$p = $sasl_auth{$net}{password};
	my $out = join("\0", $u, $u, $p);
	$out = encode_base64($out, "");

	if(length $out == 0) {
		$server->send_raw_now("AUTHENTICATE +");
		return;
	}else{
		while(length $out >= 400) {
			my $subout = substr($out, 0, 400, '');
			$server->send_raw_now("AUTHENTICATE $subout");
		}
		if(length $out) {
			$server->send_raw_now("AUTHENTICATE $out");
		}else{ # Last piece was exactly 400 bytes, we have to send some padding to indicate we're done
			$server->send_raw_now("AUTHENTICATE +");
		}
	}
}

sub cmd_sasl {
	my ($data, $server, $item) = @_;

	if ($data ne '') {
		Irssi::command_runsub ('sasl', $data, $server, $item);
	} else {
		cmd_sasl_show(@_);
	}
}

sub cmd_sasl_set {
	my ($data, $server, $item) = @_;
	my ($net, $u, $p);

	if ($data =~ /^(\S+) (\S+) (\S+)$/) {
		($net, $u, $p) = ($1, $2, $3);
		$sasl_auth{$net}{user} = $u;
		$sasl_auth{$net}{password} = $p;
		Irssi::print("SASL: added $net: $sasl_auth{$net}{user} *");
	} elsif ($data =~ /^(\S+)$/) {
		$net = $1;
		if (defined($sasl_auth{$net})) {
			delete $sasl_auth{$net};
			Irssi::print("SASL: deleted $net");
		} else {
			Irssi::print("SASL: no entry for $net");
		}
	} else {
		Irssi::print("SASL: usage: /sasl set <net> [user password]");
	}
}

sub cmd_sasl_show {
	#my ($data, $server, $item) = @_;
	my $net;
	my $count = 0;

	foreach $net (keys %sasl_auth) {
		Irssi::print("SASL: $net: $sasl_auth{$net}{user} *");
		$count++;
	}
	Irssi::print("SASL: no networks defined") if !$count;
}

sub cmd_sasl_save {
	#my ($data, $server, $item) = @_;
	my $file = Irssi::get_irssi_dir."/sasl.auth";
	my ($net, $u, $p);
	open FILE, "> $file" or return;
	foreach $net (keys %sasl_auth) {
		printf FILE ("%s\t%s\t%s\n", $net, $sasl_auth{$net}{user}, $sasl_auth{$net}{password});
	}
	close FILE;
	Irssi::print("SASL auth saved to $file");
}

sub cmd_sasl_load {
	#my ($data, $server, $item) = @_;
	my $file = Irssi::get_irssi_dir."/sasl.auth";

	open FILE, "< $file" or return;
	%sasl_auth = ();
	while (<FILE>) {
		chomp;
		my ($net, $u, $p) = split (/\t/, $_, 3);
		$sasl_auth{$net}{user} = $u;
		$sasl_auth{$net}{password} = $p;
	}
	close FILE;
	Irssi::print("SASL auth loaded from $file");
}

Irssi::signal_add_first('server connected', \&server_connected);
Irssi::signal_add('event cap', \&event_cap);
Irssi::signal_add('event authenticate', \&event_authenticate);
Irssi::signal_add('event 903', 'event_saslend');
Irssi::signal_add('event 904', 'event_saslend');
Irssi::signal_add('event 905', 'event_saslend');
Irssi::signal_add('event 906', 'event_saslend');
Irssi::signal_add('event 907', 'event_saslend');

Irssi::command_bind('sasl', \&cmd_sasl);
Irssi::command_bind('sasl load', \&cmd_sasl_load);
Irssi::command_bind('sasl save', \&cmd_sasl_save);
Irssi::command_bind('sasl set', \&cmd_sasl_set);
Irssi::command_bind('sasl show', \&cmd_sasl_show);

cmd_sasl_load();

# vim: ts=4
