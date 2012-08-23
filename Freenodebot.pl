#!/usr/bin/env perl6
use v6;
use Net::IRC::Bot;
use Net::IRC::Modules::Ping;

my $chan = '#perl6';

my $bot = Net::IRC::Bot.new(
	nick       => 'tadzikbot',
	server     => 'irc.freenode.org',
	channels   => [$chan],
	modules    => ( 
		Net::IRC::Modules::Ping.new
	),
	debug      => True,
);

say "Handlers set";
$bot.run;

my $a = IO::Socket::INET.new(
    localhost => 'localhost',
    localport => 1337,
    listen => 1,
);

MuEvent::socket(
    socket => $a,
    poll   => 'r',
    cb     => &socket-cb,
    params => { sock => $a },
);

sub socket-cb(:$sock) {
    say "Oh gosh a client!";
    my $s = $sock.accept;
    
    MuEvent::socket(
        socket => $s, 
        poll   => 'r',
        params => { sock => $s },
        cb     => sub (:$sock) {
            my $a = try $sock.recv;
            if $a {
                note "I can has: {$a.perl}";
                $bot.sendmsg($a.chomp, $chan);
                return True;
            } else {
                return False;
            }
        }
    );

    return True;
}

MuEvent::run;
