Raku Utilities
==============
Module that exports several general purpose utility functions.

SYNOPSIS
========

    use Our::Utilities;

    byte-unit-to-bytes('1 M');
    bytes-to-byte-unit(211231231231);
    number-metric-unit-to-number('211.2 G');
    real-to-metric-unit(211231231231);
    seconds-to-y-d-hh-mm-ss(12345678);
    integer-to-subscript(1234567890);
    integer-to-superscript(1234567890);
    add-commas-to-integer(1234567890);
    add-commas-to-integer(-1234567890);
    string-to-date-time('3/5/2023 9:35:01');
    string-to-date-time('2023-3-5 9:35:10');

AUTHOR
======
Mark Devine <mark@markdevine.com>
