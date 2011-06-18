package MooseX::Unique;

#ABSTRACT: Make your Moose instances unique
use Moose::Exporter;
use MooseX::InstanceTracking::Role::Class;
use MooseX::Unique::Meta::Trait::Class;
use MooseX::Unique::Meta::Trait::Attribute;
use MooseX::Unique::Meta::Trait::Role::ApplicationToClass;

Moose::Exporter->setup_import_methods(
    class_metaroles => {
        class => [
            'MooseX::InstanceTracking::Role::Class',
            'MooseX::Unique::Meta::Trait::Class'
        ],
        attribute => ['MooseX::Unique::Meta::Trait::Attribute'],
    },
    role_metaroles => {
        role      => ['MooseX::Unique::Meta::Trait::Role'],
        attribute => ['MooseX::Unique::Meta::Trait::Attribute'],
        application_to_class =>
            ['MooseX::Unique::Meta::Trait::Role::ApplicationToClass'],
        application_to_role =>
            ['MooseX::Unique::Meta::Trait::Role::ApplicationToRole'],
    },
    base_class_roles => ['MooseX::Unique::Meta::Trait::Object'],
    with_meta        => ['unique'],

);

sub unique {
    my ( $meta, @att ) = @_;
    if ( ref $att[0] ) {
        @att = @{ $att[0] };
    }
    $meta->match_attribute( \@att );
}

1;
__END__


=head1 SYNOPSIS

    package MyApp;
    use Moose;
    use MooseX::Unique;

    has identity => (
        is  => 'ro',
        isa => 'Str',
        required => 1,
        unique => 1,
    );

    has number =>  ( 
        is => 'rw',
        isa => 'Int'
    );


    package main;
    use Modern::Perl;


    my $objecta = MyApp->new_or_modify(identity => 'Mine');
    my $objectb = MyApp->new_or_modify(identity => 'Mine');

    $objecta->number(40);

    # prints:  Num: 40
    say "Num: ", $objectb->number;
    

=head1 Description

This module uses L<MooseX::InstanceTracking> to keep track of your
instances.  If an attribute has a unique flag set, and a new attribute is
requested with the same value, the original will be returned.

This is useful if

=over

=item *
    
If you are creating several attributes from data, which may have 
duplicates that you would rather merge than replace.

=item *

If you want to create a new or modify and are too lazy to look up the data
yourself. 

=item *
    
You have a complicated network of data, with several cross references.
For example, a song could have an album and an artist.  That album could
have the same artist, or a different artist.  That artist can have
multiple albums.  That album, of course, has multiple songs.  When
importing song by song, this web would be lost without some sort of
instance tracking.  This module lets Moose do the work for you.

=back

That having all been said, B<think twice> before using this module.  It 
can cause spooky action at a distance.  The synopsis should indicate how 
this can be troubling, confusing, and a great source of bizarre bugs.

In addition to the spooky action at a distance, please keep in mind that the
instance tracking is performed using B<weak references>.  If you let an object
fall out of scope, it is gone, so a new object with the same unique attribute
will be new.

=method new_or_modify(%params)

This is a class method which either creates a new object, or returns one that
matches whatever unique value you set.  If it finds one that matches, it then
modifies the attributes.  Even read-only ones.  So watch-out.  See
L<MooseX::Unique::Object|MooseX::Unique::Object> for other items that will be
injected into your namespace.

=func unique($attr)

Sugar method that can be used instead of attribute labeling.  Set $attr to 
the name of an attribute and it will be unique.  If you use this keyword in
your class, all unique attribute labels will be ignored.  

