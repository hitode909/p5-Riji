package Riji::CLI::NewEntry;
use feature ':5.10';
use strict;
use warnings;

use File::Which qw/which/;
use Path::Tiny;
use Time::Piece;

sub run {
    my ($class, @argv) = @_;
    my $subtitle = shift @argv;
    die "subtitle: $subtitle is not valid\n" if $subtitle && $subtitle =~ /[^-_a-zA-Z0-9]/;

    my $now = localtime;
    my $date_str = $now->strftime('%Y-%m-%d');
    my $file_format = "article/entry/$date_str-%s.md";
    my $file;
    if ($subtitle) {
        $file = path(sprintf $file_format, $subtitle);
    }
    else {
        my $seq = 1;
        my $seq_str = sprintf '%02d', $seq++;
        $file = path(sprintf $file_format, $seq_str) while !$file || -e $file;
    }

    $file->spew(<<'...') unless -e $file;
tags: blah
---
# title
...

    my $editor = $ENV{EDITOR};
       $editor = $editor && which $editor;

    exec $editor, "$file" if $editor;
    say "$file is created. Edit it!";
}

1;
