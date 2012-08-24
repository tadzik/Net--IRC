use v6;
class Net::IRC::Modules::Ping;

method said($ev) {
    return unless $ev.what.chomp eq ':ping';
    $ev.msg($ev.who ~ ": pong")
}
