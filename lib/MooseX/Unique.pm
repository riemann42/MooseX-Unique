package MooseX::Unique;

#ABSTRACT: Make your Moose instances as unique as you are
use Moose 1.9900; no Moose;  # Lazy hack for auto prereqs.
use Moose::Exporter;
use MooseX::InstanceTracking 0.06;
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
        applied_attribute => ['MooseX::Unique::Meta::Trait::Attribute'],
        attribute => ['MooseX::Unique::Meta::Trait::Attribute'],
        application_to_class =>
            ['MooseX::Unique::Meta::Trait::Role::ApplicationToClass'],
        application_to_role =>
            ['MooseX::Unique::Meta::Trait::Role::ApplicationToRole'],
    },
    base_class_roles => ['MooseX::Unique::Meta::Trait::Object'],
    with_meta        => ['unique', 'required_matches'],

);

sub unique {
    my ( $meta, @att ) = @_;
    if ( ref $att[0] ) {
        @att = @{ $att[0] };
    }
    $meta->add_match_attribute( @att );
}

sub required_matches {
    my ( $meta, $val) = @_;
    $meta->add_match_requires( $val );
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


    my $objecta = MyApp->new_or_matching(identity => 'Mine');
    my $objectb = MyApp->new_or_matching(identity => 'Mine');

    $objecta->number(40);

    # prints:  Num: 40
    say "Num: ", $objectb->number;
    

=head1 DESCRIPTION

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
can cause spooky action at a distance.  Be sure to use it only on immutable
objects. The synopsis should indicate how this can be troubling, confusing, 
and a great source of bizarre bugs if you are not paying attention.

In addition to the spooky action at a distance, please keep in mind that the
instance tracking is performed using B<weak references>.  If you let an object
fall out of scope, it is gone, so a new object with the same unique attribute
will be new.

=method new_or_matching(%params)

Provided by L<MooseX::Unique::Object|MooseX::Unique::Object>.

This is a wrapper around your new method that looks up the attribute for you.  
Please note that this module does not process your BUILDARGS before looking for 
an instance.  So, values must be passed as a hash or hash reference. Any
attribute that is not flagged as unique will be ignored in the case of an
existing instance.

=func unique($attr)

Sugar method that can be used instead of attribute labeling.  Set $attr to 
the name of an attribute and it will be unique.

This can be used in a role even if the attribute is not defined in the role.

=func required_matches($int)

Sugar method that sets the minimum number of matches required to make a match.
The default is 1.  Setting this to 0 means that a match requires that all
attributes set to unique are matched. If you run this more than once, for
example in a role, it will add to the existing unless the existing is 0.  If
you set it to 0, it will reset it to 0 regardless of current value. 

=head1 BUGS

I'm sure there are a few in the shadows.  Please submit test cases to the bug
tracker web link above.  

=head1 SEE ALSO
MooseX::InstanceTracking


=head1 ACKNOWLEDGMENTS

Thanks to Jesse (doy) Luehrs for steering me clear of bad code design.

Thanks to Shawn (sartak) Moore for L<MooseX::InstanceTracking>.

And thanks to the rest of the Moose team for L<Moose>.

=for stopwords
BUILDARGS params  readonly MetaRole metaroles metaclass doy Luehrs sartak UniqueIdentity

