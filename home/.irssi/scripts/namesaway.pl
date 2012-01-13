use strict;
use vars qw($VERSION %IRSSI);

use Irssi;

######## config stuff 

my $sort_by_op_voice_normal = 0; # if 1, ops come first, then voices and finally normal
my $sort_by_away_before_ops = 0; # if 1, all away nicks come last, even opped and voiced away nicks
my $sort_by_away_after_ops = 0; # if 1, away nicks come last in each group of ops, voices etc
my $sort_case_insensitive = 1; # if 0, uppercase comes before lowercase
my $sort_ignore_special_characters = 1; # if 1, ignore underscores and other stuff in nicknames

my $COLOR_BRACE = "14";

# colour of the prefix character @ or + or space
my $COLOR_OP    = "4";
my $COLOR_VOICE = "4";

# colour of the nick
my $COLOR_GONE  = "7";
my $COLOR_SSL   = "11";

# ansi <-> mirc colors
# 30   <->  1   black
# 31   <->  5   red
# 32   <->  3   green
# 33   <->  7   brown
# 34   <->  2   blue
# 35   <->  6   violet
# 36   <-> 10   cyan
# 37   <-> 15   grey
# 30;1 <-> 14   dark grey
# 31;1 <->  4   bright red
# 32;1 <->  9   bright green
# 33;1 <->  8   yellow
# 34;1 <-> 12   bright blue
# 35;1 <-> 13   bright violet
# 36;1 <-> 11   bright cyan
# 37;1 <->  0   white

######## config stuff ends

my $current = undef;

Irssi::command_bind 'na' => sub {
    my ($data, $server, $witem) = @_;

    unless(defined($witem) && $witem != 0) {
	Irssi::print("Not joined to any channel");
	  return;
      }

    if(defined $current) {
	Irssi::print("Another /na is in progress");
	  return;
      }
    
    $server->redirect_event("who", 1, "", 0, undef, {
	"event 352" => "redir namesawayitem",
	"event 315" => "redir namesawayend",
	"event 403" => "redir namesawayend",
	"" => "event empty"
	});
    
    $server->send_raw("WHO ".$witem->{name});
    
    $current = { "win"=>$witem, "list"=>[] };
};

Irssi::signal_add 'redir namesawayitem' => sub {
    my($server, $data) = @_;

#    $$current{"win"}->print($data);

    my($mynick, $channel, $user, $host, $ircserver, $nick, $flags, $dunno, $homepage) = split(/ /, $data, 9);

    my $curlist = $$current{"list"};
    push @$curlist, [$nick,$flags];
};

sub try_list {
    my ($per_row, $win, @list) = @_;
    my @collen;
    my $div = int($#list / $per_row) + 1;
    for(my $i=0; $i<$div*$per_row; ++$i) {
	my $e = $list[($i % $per_row) * $div + int($i / $per_row)];
	my $len = length(@$e[0]);
	$collen[$i % $per_row] = $len if($len > $collen[$i % $per_row]);
    }
    my $totlen = 0;
    for(my $i=0; $i<$per_row; ++$i) {
	$totlen += $collen[$i] + 4;
    }
    return undef if($totlen >= 65);
    
#    $win->print("dbg $per_row $div");

    my $str = "";
    for(my $i=0; $i<$div*$per_row; ++$i) {
	my $e = $list[($i % $per_row) * $div + int($i / $per_row)];

	if(defined(@$e[0])) {
	    $str .= "\003".$COLOR_BRACE."[";
	    if(@$e[1] =~ /@/) {
		$str .= "\003".$COLOR_OP."@";
	    } elsif(@$e[1] =~ /\+/) {
		$str .= "\003".$COLOR_VOICE."+";
	    } else{
		$str .= " ";
	    }
	    $str .= @$e[1] =~ /^G/ ? "\003".$COLOR_GONE : @$e[1] =~ /S/ ? "\003".$COLOR_SSL : "\017";
	    $str .= sprintf("%-*s", $collen[$i % $per_row], @$e[0]);
	    $str .= "\003".$COLOR_BRACE."]\017 ";
	}

	if($i % $per_row == $per_row - 1) {
	    $win->print($str, MSGLEVEL_CLIENTCRAP);
	    $str = "";
	  }
    }
    if(length($str) > 0) {
	$win->print($str);
    }
    return 1;
}

Irssi::signal_add 'redir namesawayend' => sub {
    my $curlist = $$current{"list"};
    my @list = sort {
	my $aa = $$a[0];
	my $bb = $$b[0];
	my $aaf = $$a[1];
	my $bbf = $$b[1];

	if($sort_case_insensitive) {
	    $aa = lc($aa);
	    $bb = lc($bb);
	}

	if($sort_ignore_special_characters) {
	    $aa =~ s/[\W_]//g;
	    $bb =~ s/[\W_]//g;
	}

	if($sort_by_away_after_ops) {
	    if($aaf =~ /^G/) {
		$aa = "2".$aa;
	    } else {
		$aa = "1".$aa;
	    }
	    if($bbf =~ /^G/) {
		$bb = "2".$bb;
	    } else {
		$bb = "1".$bb;
	    }
	}

	if($sort_by_op_voice_normal) {
	    if($aaf =~ /@/) {
		$aa = "1" . $aa;
	    } elsif($aaf =~ /\+/) {
		$aa = "2" . $aa;
	    } else {
		$aa = "3" . $aa;
	    }
	    if($bbf =~ /@/) {
		$bb = "1" . $bb;
	    } elsif($bbf =~ /\+/) {
		$bb = "2" . $bb;
	    } else {
		$bb = "3" . $bb;
	    }
	}

	if($sort_by_away_before_ops) {
	    if($aaf =~ /^G/) {
		$aa = "2".$aa;
	    } else {
		$aa = "1".$aa;
	    }
	    if($bbf =~ /^G/) {
		$bb = "2".$bb;
	    } else {
		$bb = "1".$bb;
	    }
	}

	$aa cmp $bb;
    } @$curlist;
    for(my $i=$#list+1; $i>=1; --$i) {
	last if(try_list($i, $$current{"win"}, @list));
    }
    $current = undef;
};

