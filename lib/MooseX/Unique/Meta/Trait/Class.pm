package MooseX::Unique::Meta::Trait::Class;
#ABSTRACT:  MooseX::Unique Class MetaRole
use Moose::Role;

has match_attribute => (
    traits  => ['Array'],
    isa     => 'ArrayRef[Any]',
    is      => 'rw',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my @ret  = ();
        for my $attribute ( map { $self->get_attribute($_) }
            $self->get_attribute_list ) {
            next unless $attribute->can('unique');
            if ( $attribute->unique ) {
                push @ret, $attribute;
            }
        }
        return \@ret;
    },
    handles => {
        _has_match_attributes => 'count',
        match_attributes      => 'elements',
        add_match_attribute   => 'push',
    },
);

has match_requires => (
    isa => 'Int',
    is => 'rw',
    lazy => 1,
    default => sub{1},
    predicate => '_has_match_requires',
);

1;
__END__

=head1 SYNOPSIS

See L<MooseX::Unique|MooseX::Unique>;

=head1 DESCRIPTION

Provides the attribute match_attribute to your metaclass.

=method match_attributes

Returns a list of match attributes

=method add_match_attribute

Add a match attribute

=attr match_attribute

An arrayref of match attributes.

=method match_requires

The minimum number of attributes that must match to consider two objects to be
identical.  The default is 1.  Setting this to 0 will force all attributes
with unique flag to match.

=for stopwords
BUILDARGS params  readonly MetaRole metaclass

