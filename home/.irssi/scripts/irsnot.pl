##
## Put me in ~/.irssi/scripts, and then execute the following in irssi:
##
##       /load perl
##       /script load irsnot
##

# The file ~/.irssi/irsnotrc can be used to configure notication timeouts
# for certain channels/nicknames. Here is an example

##########################################################################
## use this to set the default notification time for private messages.
## This shows the default of 5000ms or 5s
# nick * 5000
#
## and for messages received through a channel
## this shows the default which disables notifications for channels
# chan * 0
#
# chan #chilon 5000
# nick my_boss 5000000
##########################################################################
# end config example
###

# You can use /irsnot also with the same format as a config line
# entry to adjust a binding, and /irsnot_reload to reload the config file.

use strict;
use Desktop::Notify;
use Irssi;
use vars qw($VERSION %IRSSI);

# Open a connection to the notification daemon
my $notify = Desktop::Notify->new();

$VERSION = "0.01";
%IRSSI = (
    authors     => 'James Pike',
    contact     => 'irsnot@chilon.net',
    name        => 'irsnot.pl',
    description => 'Use libnotify to alert user to messages',
    license     => 'MIT',
    url         => 'https://github.com/tuxjay/irsnot',
);

my %channels;
my %nicks;

my $default_nick = { timeout => 5000 };
my $default_chan = { timeout => 0 };

Irssi::settings_add_str('irsnot', 'notify_icon', 'gtk-dialog-info');

# fallback notify time
Irssi::settings_add_str('irsnot', 'notify_time', '5000');

load_config();

sub sanitize_msg {
    my $msg = $_[0];
    $msg =~ s/&/&amp;/g;
    $msg =~ s/</&lt;/g;
    $msg =~ s/>/&gt;/g;
    $msg =~ s/'/&apos;/g;
    return $msg;
}

sub notify_simple {
    my ($summary, $msg) = @_;
    $notify->create(
        summary => sanitize_msg($summary),
        body    => sanitize_msg($msg),
        timeout => Irssi::settings_get_str('notify_time')
    )->show();
}

sub notify {
    my ($summary, $msg, $conf) = @_;
    my $timeout = $conf->{'timeout'};
    if ($timeout) {
        $notify->create(
            summary => sanitize_msg($summary),
            body    => sanitize_msg($msg),
            timeout => $timeout
        )->show();
    }
}

sub print_text_notify {
    my ($dest, $text, $stripped) = @_;
    my $server = $dest->{server};

    return if (!$server || !($dest->{level} & MSGLEVEL_HILIGHT));
    my $sender = $stripped;
    $sender =~ s/^\<.([^\>]+)\>.+/\1/ ;
    $stripped =~ s/^\<.[^\>]+\>.// ;
    my $summary = $dest->{target} . ": " . $sender;
    notify_simple($summary, $stripped);
}

sub message_private_notify {
    my ($server, $msg, $nick, $address) = @_;
    return if (!$server);

    my $meta = $nicks{$nick};
    if ($meta) {
        notify("<$nick>", $msg, $meta);
        return;
    }
    else {
        notify("<$nick>", $msg, $default_nick);
    }
}

sub message_public_notify {
    my ($server, $msg, $nick, $address, $target) = @_;
    return if (!$server);

    my $meta = $nicks{$nick} || $channels{$target};
    if ($meta) {
        notify("<$nick|$target>", $msg, $meta);
    }
    else {
        notify("<$nick|$target>", $msg, $default_chan);
    }
}

sub dcc_request_notify {
    my ($dcc, $sendaddr) = @_;
    my $server = $dcc->{server};
    return if (!$dcc);
    notify_simple("DCC ".$dcc->{type}." request", $dcc->{nick});
}

sub load_config {
    open my $file, '<', Irssi::get_irssi_dir() . '/irsnotrc' or return;

    while (my $cmd = <$file>) {
        $cmd =~ s/# .*//;
        next if $cmd =~ /^\s*$/ or $cmd =~ /^\s*"/;
        chomp $cmd;

        cmd($cmd);
    }
    close $file;
}

sub cmd_reload {
    %channels = ();
    %nicks = ();
    load_config();
}

sub bind_line {
    my $line = shift;

    if ($line =~ /^\s*chan(?:nel)?\s+([#&]?\S+|\*)\s+(\d+)\s*$/) {
        if ($1 eq '*') {
            $default_chan->{'timeout'} = $2;
        }
        else {
            $channels{$1}->{'timeout'} = $2;
        }
    }
    elsif ($line =~ /^\s*nick\s+(\w+|\*)\s+(\d+)\s*$/) {
        $nicks{$1}->{'timeout'} = $2;
        if ($1 eq '*') {
            $default_nick->{'timeout'} = $2;
        }
        else {
            $nicks{$1}->{'timeout'} = $2;
        }
    }
    else {
        Irssi::print("Invalid irsnot command `$line'");
    }
}

sub cmd {
    my ($data, $server, $witem) = @_;
    bind_line($data);
}

# Irssi::signal_add('print text', 'print_text_notify');
Irssi::signal_add('message private', 'message_private_notify');
Irssi::signal_add('message public', 'message_public_notify');
Irssi::signal_add('dcc request', 'dcc_request_notify');

Irssi::command_bind('irsnot_reload', 'cmd_reload');
Irssi::command_bind('irsnot', 'cmd');
