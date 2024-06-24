my sub play(
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
        if $health <= 0 {
            say "You've died of Covid-19." if $verbose;
            return 0;
        }

        $state = (1..100).roll + $age;
        if $state >= 120 {
            say "You're transferred to ICU." if $verbose;

            $state = (1..100).roll + $age;
            if $state >= 110 {
                say "You've been put on a ventilator." if $verbose;

                $state = (1..100).roll + $age;
                if $state >= 110 {
                    say "You've died of Covid-19." if $verbose;
                    return 0;
                }
            }
        }

        $health = min($health + 6, $constitution);
        say "You'll need 6 months for recovery." if $verbose;
    }

    elsif $state >= 60 {
        say "You're moderately ill." if $verbose;
        $health -= (1..4).roll for ^2;
        if $health <= 0 {
            say "You've died of Covid-19." if $verbose;
            return 0;
        }

        $health = min($health + 6, $constitution);
        say "You'll need 6 weeks for recovery." if $verbose;
    }

    else {
        say "You do not show any symptoms." if $verbose;
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

my sub infecting($infecting) {
    $infecting <= 0
      ?? "You will not infect anybody."
      !! $infecting == 1
        ?? "You will infect one other person."
        !! "You will infect $infecting people.";
}

my sub death-rate(
  :$times = 10000,   # the number of times to play the game
  :$verbose = True,  # whether to tell the result
  |c,                # parameters to play routine
) is export {
    my $died = 0;
    ++$died if play(:!verbose, |c) == 0 for ^$times;
    my $death-rate = 100 * ($died / $times);
    say $death-rate.fmt("The death-rate is %.2f%%.") if $verbose;
    $death-rate
}

=begin pod

=head1 NAME

Game::Covid19 - Play the COVID-19 game

=head1 SYNOPSIS

=begin code :lang<raku>

use Game::Covid19;

play(age => 64);  # must specify age

play(age => 34, :mask, :distancing);

death-rate(age => 64);

=end code

=head1 DESCRIPTION

Game::Covid19 is an implementation of a DND-type game that is based on
CDC data and was posted by Stephen Richard Watson at:

    https://www.facebook.com/photo.php?fbid=10163856786525537&set=gm.1155683021483491&type=3&theater

It exports two subroutines: C<play> and C<death-rate>.

=head1 SUBROUTINES

=head2 play

=begin code :lang<raku>

play(age => 64);

=end code

The C<play> subroutine will play the game.  You need to at least specify
the C<age> named parameter.  It will return your final constitution, with
C<0> indicating death.  The following named parameters are optional:

=head3 constitution

=begin code :lang<raku>

  constitution => 80,

=end code

A value of 1..100 indicating the state of your constitution, with C<100>
indicating fully healthy.  Defaults to C<100>.

=head3 mask

=begin code :lang<raku>

  :mask

=end code

A Boolean indicating whether or not you're wearing a mask.  Defaults to
C<False>.

=head3 distancing

=begin code :lang<raku>

  :distancing

=end code

A Boolean indicating whether or not you're socially distancing.  Defaults
to C<False>.

=head3 verbose

=begin code :lang<raku>

  :!verbose

=end code

A Boolean indicating whether verbose play output is wanted.  Defaults to
C<True>.

=head2 death-rate

=begin code :lang<raku>

  death-rate(age => 64);

=end code

The C<death-rate> sub will run the game many times and record how many times
the game resulted in death, and use that to calculate a death-rate as a
percentage.

It takes the same named parameters as the C<play> subroutine.  Additional
named parameters are:

=head3 times

=begin code :lang<raku>

  times => 10000

=end code

The number of times the game should be played.  Defaults to 10000.

=head1 AUTHOR

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Game-Covid19 . Comments and
Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a
L<small sponsorship|https://github.com/sponsors/lizmat/>  would mean a great
deal to me!

=head1 COPYRIGHT AND LICENSE

Copyright 2020, 2021, 2024 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under
the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
