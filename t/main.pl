use strict; use warnings;
use Test::More tests => 7;                      # last test to print

my $objecta = MyApp->new_or_matching(identity => 'Mine');
my $objectb = MyApp->new_or_matching(identity => 'Mine');
my $objectc = MyApp->new_or_matching(identity => 'Yours');

$objecta->number(40);

is($objecta->number, 40, "Object A is good (control test)");
is($objectb->number, 40, "Object B is good");
isnt($objectc->number, 40, "Object C is good");

$objectc->number(100);

isnt($objecta->number, 100, "Object A is good");
isnt($objectb->number, 100, "Object B is good");
is($objectc->number, 100, "Object C is good");

my $objectd = MyApp->new_or_matching(identity => 'Yours');

is($objectd->number, 100, "Object D is good");

1;
