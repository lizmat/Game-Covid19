NAME
====

Game::Covid19 - Play the COVID-19 game

SYNOPSIS
========

```raku
use Game::Covid19;

play(age => 64);  # must specify age

play(age => 34, :mask, :distancing);

death-rate(age => 64);
```

DESCRIPTION
===========

Game::Covid19 is an implementation of a DND-type game that is based on CDC data and was posted by Stephen Richard Watson at:

    https://www.facebook.com/photo.php?fbid=10163856786525537&set=gm.1155683021483491&type=3&theater

It exports two subroutines: `play` and `death-rate`.

SUBROUTINES
===========

play
----

```raku
play(age => 64);
```

The `play` subroutine will play the game. You need to at least specify the `age` named parameter. It will return your final constitution, with `0` indicating death. The following named parameters are optional:

### constitution

```raku
  constitution => 80,
```

A value of 1..100 indicating the state of your constitution, with `100` indicating fully healthy. Defaults to `100`.

### mask

```raku
  :mask
```

A Boolean indicating whether or not you're wearing a mask. Defaults to `False`.

### distancing

```raku
  :distancing
```

A Boolean indicating whether or not you're socially distancing. Defaults to `False`.

### verbose

```raku
  :!verbose
```

A Boolean indicating whether verbose play output is wanted. Defaults to `True`.

death-rate
----------

```raku
  death-rate(age => 64);
```

The `death-rate` sub will run the game many times and record how many times the game resulted in death, and use that to calculate a death-rate as a percentage.

It takes the same named parameters as the `play` subroutine. Additional named parameters are:

### times

```raku
  times => 10000
```

The number of times the game should be played. Defaults to 10000.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Game-Covid19 . Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

COPYRIGHT AND LICENSE
=====================

Copyright 2020, 2021, 2024 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

