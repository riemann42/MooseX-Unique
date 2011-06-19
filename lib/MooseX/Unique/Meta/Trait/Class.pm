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
    lazy => 1,
    default => sub{1},
    reader    => 'match_requires',
    writer    => '_set_match_requires',
    predicate => '_has_match_requires',
);

sub add_match_requires {
    my ($self,$val) = @_;

    my $newval = 

       ($val == 0)                         ? 0

     : (    ($self->_has_match_requires) 
         && ($self->match_requires > 0))   ? $self->match_requires + $val

     : (    ($self->_has_match_requires) 
         && ($self->match_requires == 0))  ? 0

     :                                       $val;

    $self->_set_match_requires($newval);
}

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
identical.  The default is 1.  

=method add_match_requires

Sets the minimum number of matches required to make a match.
Setting this to 0 means that a match requires that all
attributes set to unique are matched. If you run this more than once, for
example in a role, it will add to the existing unless the existing is 0.  If
you set it to 0, it will reset it to 0 regardless of current value. 

=for stopwords
BUILDARGS params  readonly MetaRole metaclass

