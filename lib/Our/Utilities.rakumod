unit module Our::Utilities:api<1>:auth<Mark Devine (mark@markdevine.com)>;

use NativeCall;

constant \KILOBYTE  = 1024;
constant \MEGABYTE  = KILOBYTE  * KILOBYTE;
constant \GIGABYTE  = MEGABYTE  * KILOBYTE;
constant \TERABYTE  = GIGABYTE  * KILOBYTE;
constant \PETABYTE  = TERABYTE  * KILOBYTE;
constant \KILO      = 1000;
constant \MEGA      = KILO      * KILO;
constant \GIGA      = MEGA      * KILO;
constant \TERA      = GIGA      * KILO;
constant \PETA      = TERA      * KILO;
constant \SECOND    = 1;
constant \MINUTE    = 60        * SECOND;
constant \HOUR      = 60        * MINUTE;
constant \DAY       = 24        * HOUR;

sub bytes-unit-to-bytes (Str:D $num-unit, :$commas, :$round) is export {
    if $num-unit ~~ / ^ (\d+ '.'* \d*) \s* (\w*) $ / {
        my $actual  = $0.Str.comb.grep(/ \d | '.' /).join;
        my $unit    = $1.Str with $1;
        given $unit {
            when .starts-with: 'P'  { $actual *= PETABYTE                       }
            when .starts-with: 'T'  { $actual *= TERABYTE                       }
            when .starts-with: 'G'  { $actual *= GIGABYTE                       }
            when .starts-with: 'M'  { $actual *= MEGABYTE                       }
            when .starts-with: 'K'  { $actual *= KILOBYTE                       }
            when .starts-with: 'B'  { ;                                         }
            default                 { warn 'Unknown UNIT'; return $num-unit;    }
        }
        my $number  = $actual;
        $number     = $number.round                 if $round;
        $number     = add-commas-to-digits($number) if $commas;
        return $number;
    }
    warn 'Unknown "number UNIT" format';
    return $num-unit;
}

sub bytes-to-bytes-unit (Int:D $bytes, Int:D :$digits = 1) is export {
    given $bytes {
        when $_ >= PETABYTE { return ($bytes / PETABYTE).fmt("%.{$digits}f P"); }
        when $_ >= TERABYTE { return ($bytes / TERABYTE).fmt("%.{$digits}f T"); }
        when $_ >= GIGABYTE { return ($bytes / GIGABYTE).fmt("%.{$digits}f G"); }
        when $_ >= MEGABYTE { return ($bytes / MEGABYTE).fmt("%.{$digits}f M"); }
        when $_ >= KILOBYTE { return ($bytes / KILOBYTE).fmt("%.{$digits}f K"); }
        default             { return $bytes.fmt("%s B");                        }
    }
}

sub number-metric-unit-to-number (Str:D $num-unit, :$commas, :$round) is export {
    if $num-unit ~~ / ^ (\d+ '.'* \d*) \s* (\w*) $ / {
        my $actual  = $0.Str.comb.grep(/ \d | '.' /).join;
        my $unit    = $1.Str with $1;
        given $unit {
            when .starts-with: 'P'  { $actual *= PETA                           }
            when .starts-with: 'T'  { $actual *= TERA                           }
            when .starts-with: 'G'  { $actual *= GIGA                           }
            when .starts-with: 'M'  { $actual *= MEGA                           }
            when .starts-with: 'K'  { $actual *= KILO                           }
            default                 { warn 'Unknown UNIT'; return $num-unit;    }
        }
        my $number  = $actual;
        $number     = $number.round                 if $round;
        $number     = add-commas-to-digits($number) if $commas;
        return $number;
    }
    warn 'Unknown "number UNIT" format';
    return $num-unit;
}

sub number-to-metric-unit (Real:D $num is copy, Int:D :$digits = 1) is export {
    my $neg = False;
    if $num < 0 {
        $neg = True;
        $num *= -1;
    }
    given $num {
        when $_ >= PETA { return $neg ?? (-1 * ($num / PETA)).fmt("%.{$digits}f P") !! ($num / PETA).fmt("%.{$digits}f P"); }
        when $_ >= TERA { return $neg ?? (-1 * ($num / TERA)).fmt("%.{$digits}f T") !! ($num / TERA).fmt("%.{$digits}f T"); }
        when $_ >= GIGA { return $neg ?? (-1 * ($num / GIGA)).fmt("%.{$digits}f G") !! ($num / GIGA).fmt("%.{$digits}f G"); }
        when $_ >= MEGA { return $neg ?? (-1 * ($num / MEGA)).fmt("%.{$digits}f M") !! ($num / MEGA).fmt("%.{$digits}f M"); }
        when $_ >= KILO { return $neg ?? (-1 * ($num / KILO)).fmt("%.{$digits}f K") !! ($num / KILO).fmt("%.{$digits}f K"); }
        default         { return $neg ?? (-1 * $num) !! $num;                                                               }
    }
}

sub seconds-to-y-d-hh-mm-ss (Int:D $total-seconds) is export {
    my $years       = 0;
    my $days        = 0;
    my $hours       = 0;
    my $minutes     = 0;
    my $seconds     = $total-seconds;
    my $result;
    if $seconds >= 31557556 {
        $years      = ($seconds / 31557556).Int;
        $result     = $years ~ 'y ';
        $seconds   -= $years * 31557556;
    }
    if $seconds >= DAY {
        $days       = ($seconds / DAY).Int;
        $result    ~= $days ~ 'd ';
        $seconds   -= $days * DAY;
    }
    if $seconds >= HOUR {
        $hours      = ($seconds / HOUR).Int;
        $result    ~= $hours.fmt("%02d");
        $seconds   -= $hours * HOUR;
    }
    else {
        $result    ~= '00';
    }
    if $seconds >= MINUTE {
        $minutes    = ($seconds / MINUTE).Int;
        $result    ~= ':' ~ $minutes.fmt("%02d") ~ ':';
        $seconds   -= $minutes * MINUTE;
    }
    else {
        $result    ~= ':00:';
    }
    $seconds        = 0 if $seconds < 0;
    $result        ~= $seconds.fmt("%02d");
    return $result;
}

my @SUB-DIGITS;
@SUB-DIGITS[0]    = "\x[2080]";
@SUB-DIGITS[1]    = "\x[2081]";
@SUB-DIGITS[2]    = "\x[2082]";
@SUB-DIGITS[3]    = "\x[2083]";
@SUB-DIGITS[4]    = "\x[2084]";
@SUB-DIGITS[5]    = "\x[2085]";
@SUB-DIGITS[6]    = "\x[2086]";
@SUB-DIGITS[7]    = "\x[2087]";
@SUB-DIGITS[8]    = "\x[2088]";
@SUB-DIGITS[9]    = "\x[2089]";

sub integer-to-subscript (Int:D $i) is export {
    my $accumulator = '';
    for $i.Int.comb -> $c {
        $accumulator ~= @SUB-DIGITS[$c.Int];
    }
    return $accumulator;
}

my @SUPER-DIGITS;
@SUPER-DIGITS[0]    = "\x[2070]";
@SUPER-DIGITS[1]    = "\x[00B9]";
@SUPER-DIGITS[2]    = "\x[00B2]";
@SUPER-DIGITS[3]    = "\x[00B3]";
@SUPER-DIGITS[4]    = "\x[2074]";
@SUPER-DIGITS[5]    = "\x[2075]";
@SUPER-DIGITS[6]    = "\x[2076]";
@SUPER-DIGITS[7]    = "\x[2077]";
@SUPER-DIGITS[8]    = "\x[2078]";
@SUPER-DIGITS[9]    = "\x[2079]";

sub integer-to-superscript (Int:D $i) is export {
    my $accumulator = '';
    for $i.Int.comb -> $c {
        $accumulator ~= @SUPER-DIGITS[$c.Int];
    }
    return $accumulator;
}

multi sub add-commas-to-digits (Str:D $data is copy, :$fractional-digits) is export {
    $data   = $data.trim;
    given $data {
        when / ^ <[+-]>* \s* \d+ $/ {
            return add-commas-to-digits($data.Int);
        }
        when / ^ <[+-]>* \s* \d+ '.' (\d+) $/ {
            my ($, $fraction)   = $data.Str.split('.');
            my $f-ds            = $fraction.chars;
            $f-ds               = $fractional-digits with $fractional-digits;
            return add-commas-to-digits($data.Real, :fractional-digits($f-ds));
        }
        default                 {
            die 'NaN';
        }
    }
}

multi sub add-commas-to-digits (Int:D $data is copy) is export {
    return $data.Str.flip.comb(3).join(',').flip if $data >= 0;
    $data *= -1;
    return '-' ~ $data.Str.flip.comb(3).join(',').flip;
}

multi sub add-commas-to-digits (Real:D $data is copy, :$fractional-digits) is export {
    my ($whole, $fraction)  = $data.Str.split('.');
    my $f-ds                = $fraction.chars;
    $f-ds                   = $fractional-digits    with $fractional-digits;
    if $fraction.chars < $f-ds {
        $fraction          ~= '0' x ($f-ds - $fraction.chars);
    }
    elsif $fraction.chars > $f-ds {
        $fraction           = $fraction.substr(0, $f-ds);
    }
    return add-commas-to-digits($whole.Int) ~ '.' ~ $fraction;
}

sub add-commas-to-integer (Int:D $i is copy) is export is DEPRECATED {
    return $i.Str.flip.comb(3).join(',').flip if $i >= 0;
    $i *= -1;
    return '-' ~ $i.Str.flip.comb(3).join(',').flip;
}

my grammar String-to-Date-Time {
    token TOP               { <date> <dt-separator> <time>                              }
    token dt-separator      { . || \s+                                                  }
    token date              { <yyyymd> || <mdyyyy>                                      }
    token yyyymd            { <year> <month-separator> <month> <month-separator> <day>  }
    token mdyyyy            { <month> <month-separator> <day> <month-separator> <year>  }
    token month-separator   { '/' || '-'                                                }
    token year              { \d ** 4                                                   }
    token month             { \d ** 1..2                                                }
    token day               { \d ** 1..2                                                }
    token time              { <hour> ':' <minute> ':'* <second>*                        }
    token hour              { \d ** 1..2                                                }
    token minute            { \d ** 1..2                                                }
    token second            { \d ** 1..2                                                }
}

sub string-to-date-time (Str:D $date-time) is export {
    my $parse;
    my $year;
    my $month;
    my $day;
    my $hour;
    my $minute;
    my $second      = '00';
    if $parse = String-to-Date-Time.parse($date-time) {
        if $parse<date><yyyymd><year>:exists {
            $year   = $parse<date><yyyymd><year>.Str;
            $month  = $parse<date><yyyymd><month>.Str;
            $day    = $parse<date><yyyymd><day>.Str;
        }
        elsif $parse<date><mdyyyy><year>:exists {
            $year   = $parse<date><mdyyyy><year>.Str;
            $month  = $parse<date><mdyyyy><month>.Str;
            $day    = $parse<date><mdyyyy><day>.Str;
        }
        else {
            die 'Unable to determine <year> (should be impossible)';
        }
        $hour       = $parse<time><hour>.Str;
        $minute     = $parse<time><minute>.Str;
        $second     = $parse<time><second>.Str  if $parse<time><second>;
        return(DateTime.new(:$year, :$month, :$day, :$hour, :$minute, :$second));
    }
    return Nil;
}

class winsize is repr('CStruct') {
    has uint16 $.rows;
    has uint16 $.cols;
    has uint16 $.xpixels;
    has uint16 $.ypixels;
    method gist() {
        return "rows={self.rows} cols={self.cols} {self.xpixels}x{self.ypixels}"
    }
}

constant TIOCGWINSZ = 0x5413;

sub term-size(--> winsize) is export {
    sub ioctl(int32 $fd, int32 $cmd, winsize $winsize) is native {*}
    my winsize $winsize .= new;
    ioctl(0,TIOCGWINSZ,$winsize);
    return $winsize;
}

our $Sort-Type is export    = set <digits string string-digits digits-string>;

enum Our-UNICODE-Chars is export (
    ouc-infinity            => "\x[221E]",
    ouc-superscript-x       => "\x[02E3]",
    ouc-delta               => "\x[0394]",
    ouc-hourglass           => "\x[029D6]",
    ouc-superscript-plus    => "\x[207A]",
    ouc-superscript-minus   => "\x[207B]",
    ouc-superscript-equals  => "\x[207C]",
    ouc-superscript-lparen  => "\x[207D]",
    ouc-superscript-rparen  => "\x[207E]",
    ouc-subscript-plus      => "\x[208A]",
    ouc-subscript-minus     => "\x[208B]",
    ouc-subscript-equals    => "\x[208C]",
    ouc-subscript-lparen    => "\x[208D]",
    ouc-subscript-rparen    => "\x[208E]",
    ouc-superscript-H       => "\x[1D34]",
);

enum ANSI-Effects is export (
    bold                    => 1,
    faint                   => 2,
    italic                  => 3,
    underline               => 4,
    blink                   => 5,
    reverse                 => 7,
    hide                    => 8,
    strikethrough           => 9,
    doubleunderline         => 21,
);

our $Justification is export = set <left center right>;

our %box-char is export = (
        side                => '│',
        horizontal          => '─',
        down-and-horizontal => '┬', 
        up-and-horizontal   => '┴',
        top-left-corner     => '┌',
        top-right-corner    => '┐',
        bottom-left-corner  => '└',
        bottom-right-corner => '┘',
        side-row-left-sep   => '├',
        side-row-right-sep  => '┤',
    );

subset Email-Address is export of Str where $_ ~~ /^ .+? '@' <[<alnum>-]>+ '.' <[<alnum>-]>+ $/;

=finish
