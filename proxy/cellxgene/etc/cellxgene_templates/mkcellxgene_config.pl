#!/usr/bin/perl
use 5.20.0;
use warnings;

my $group = $ARGV[0] // die "need a group name\n";

my $TEMPLATEDIR = $ARGV[1] // '/etc/cellxgene_templates';
my $APACHECONFDIR = $ARGV[2] // '/etc/apache2/sites-available';
my $WEBROOT = $ARGV[3] // '/var/www';

my $apache_template = $TEMPLATEDIR. '/apache.conf';
my $mapping = $TEMPLATEDIR. '/group_host_mapping';

my $dstconf = $APACHECONFDIR. '/cellxgene/'."$group".'.conf';
my $index = $WEBROOT.'/index.html';

my $tmpconf = '/tmp/'."$group".'.conf';

my @content;
sub readtemplate {
    my $file = shift;
    @content = ();
    open (my $fd, "<", $file) or die "Can't open file $file, $!";
    while (<$fd>) {
        next if $_ =~ m/^\#/;
        next if $_ =~ m/^public:/;
        push @content,$_;
    }
    close $fd;
    return @content if @content;
    return;
}

my @match = grep {/$group:/} readtemplate($mapping);
die "fix your mapping: $mapping, found multiple matches!\n" if scalar(@match) > 1;
die "fix your mapping: $mapping, found zero matches!\n" if scalar(@match) == 0;
my $host = (split(/:/,$match[0]))[1];
my $port = (split(/:/,$match[0]))[2];
die "Can't find port for group $group" if ! $port;
die "Can't find host for group $group" if ! $host;

sub gen_conf {
    my $file = shift;
    my @result;
    for my $str (readtemplate($file)) {
        chomp ($port,$group,$host);
        $str =~ s/\<group\>/$group/g;
        $str =~ s/\<PORT\>/$port/g;
        $str =~ s/\<HOST\>/$host/g;
        push @result,$str;
    }
    return \@result;
    return;
}

sub write_conf {
    my ($file,$config) = @_;
    #we expect array here
    return if ref($config) ne 'ARRAY';
    open (my $fd,">",$file) or die "can't write to file $file, $!";
    say "created $file";
    print $fd @$config;
    close $fd;
}

sub update_index{
    my $file = shift;
    my @result;
    my $newlink = "\t\t".'<li><a href="/'.$group.'/">'.$group.'</a></li>';
    for my $str (readtemplate($file)) {
        if ($str =~ m/\/$group\//) {
            say "the group already exist in $index";
            return;
        }
        push @result,$newlink."\n" if $str =~ m/\s+<!--new_links_go_here-->$/;
        push @result,$str;
    }
    return \@result;
    return;

}

write_conf($dstconf,gen_conf($apache_template));
write_conf($index,update_index($index));
