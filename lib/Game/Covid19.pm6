use v6.c;
unit class Game::Covid19:ver<0.0.1>:auth<cpan:ELIZABETH>;

sub play(
  Int:D :$age!,                # your age
  Int:D :$constitution = 100,  # your initial constitution
  Bool  :$mask,                # are you wearing a mask?
  Bool  :$distancing,          # do you socially distance?
  Bool  :$verbose = True,      # do you want to play verbosely
) is export {

    my $state  = (1..100).roll + $age;
    my $health = $constitution;

    if $state >= 120 {
        say "You're seriously ill." if $verbose;
        $health -= (1..6).roll for ^2;
        $state = (1..100).roll + $age;

        if $state >= 120 {
            say "You're transferred to ICU" if $verbose;

            $state = (1..100).roll + $age;
            if $state >= 110 {
                say "You've been put in a ventilator." if $verbose;

                $state = (1..100).roll + $age;
                if $state >= 110 {
                    say "You've died of Covid-19." if $verbose;
                    return 0;
                }
            }

            $health = min($health + 6, $constitution);
            say "You'll need 6 months for recovery" if $verbose;
        }
    }

    elsif $state >= 60 {
        say "You're moderately ill." if $verbose;
        $health -= (1..4).roll for ^2;

        $health = min($health + 6, $constitution);
        say "You'll need 6 weeks for recovery." if $verbose;
    }

    else {
        say "You do not show any symptoms.";
        my $infecting = (1..6).roll + (1..6).roll;

        if $mask {
            if $distancing {
                $infecting -= 10;
                if $verbose {
                    say "You're wearing a mask and are socially distancing.";
                    say infecting($infecting);
                }
            }
            else {
                $infecting -= 8;
                if $verbose {
                    say "You're wearing a mask but are *not* socially distancing.";
                    say infecting($infecting);
                }
            }
        }
        else {
            $infecting -= 2;
            if $verbose {
                say "You're *not* wearing a mask and are *not* socially distancing.";
                say infecting($infecting);
            }
        }
    }

    say "You've permanently lost {
        (100 - 100 * ($health / $constitution)).fmt("%d")
    }% of your constitution." if $verbose && $health < $constitution;

    $health
}

sub infecting($infecting) {
    $infecting <= 0
      ?? "You will not infect anybody."
      !! $infecting == 1
        ?? "You will infect one other person."
        !! "You will infect $infecting people.";
}

=begin pod

=head1 NAME

Game::Covid19 - Play the COVID-19 game

=head1 SYNOPSIS

=begin code :lang<raku>

use Game::Covid::19;

play(age => 64);  # must specify age

play(age => 34, :mask, :distancing);

=end code

=head1 DESCRIPTION

Game::Covid19 is an implementation of a DND-type game that is based on
CDC data and was posted by Stephen Richard Watson at:

    https://www.facebook.com/photo.php?fbid=10163856786525537&set=gm.1155683021483491&type=3&theater

It exports a single sub called C<play>.

=head1 SUBROUTINES

=head2 play

  play(age => 64);

The C<play> subroutine will play the game.  You need to at least specify
the C<age> named parameter.  It will return your final constitution, with
C<0> indicating death.  The following named parameters are optional:

=item constitution

  constitution => 80,

A value of 1..100 indicating the state of your constitution, with C<100>
indicating fully healthy.  Defaults to C<100>.

=item mask

  :mask

A Boolean indicating whether or not you're wearing a mask.  Defaults to
C<False>.

=item distancing

  :distancing

A Boolean indicating whether or not you're socially distancing.  Defaults
to C<False>.

=item verbose

  :!verbose

A Boolean indicating whether verbose play output is wanted.  Defaults to
C<True>.

=head1 AUTHOR

Elizabeth Mattijsen <liz@wenzperl.nl>

Source can be located at: https://github.com/lizmat/Game-Covid19 . Comments and
Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2020 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under
the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
