Raku Utilities
==============
Module that exports several general purpose utility functions.

SYNOPSIS
========
  use Our::Utilities;

  byte-unit-to-bytes('1.0 M');      # 1048576
  number-to-metric-unit(1000);      # "1 K"
  bytes-to-byte-unit(1048576);      # "1.0M"
  seconds-to-d-hh-mm-ss(1);         # "00:00:01"
  integer-to-superscript(1);        # "Â"
  integer-to-subscript(0);          # "â‚€"
  add-commas-to-integer(1000);      # "1,000"
  put "Captured:
    $/<month>
    $/<day-of-month>
    $/<year>
    $/<hour>
    $/<minute>
    $/<second>" if $my-suspected-date ~~ date-time-regex;

AUTHOR
======
Mark Devine <mark@markdevine.com>
