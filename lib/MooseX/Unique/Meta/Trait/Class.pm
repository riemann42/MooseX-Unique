package MooseX::Unique::Meta::Trait::Class;
#ABSTRACT:  MooseX::Unique Class MetaRole
use Moose::Role;
use List::MoreUtils qw(uniq);

has _match_attribute => (
    traits  => ['Array'],
    isa     => 'ArrayRef',
    is      => 'rw',
    lazy    => 1,
    default => sub {[]},
    handles => {
        add_match_attribute   => 'push',
        _match_attributes     => 'elements',
    },
);

sub _has_match_attributes {
    my $self = shift;
    return ($self->match_attributes) ? 1 : 0;
}

sub _is_attr_unique {
    my ($self, $attr) = @_;
    my $attr_obj = $self->get_attribute($attr);
    return (($attr_obj->can('unique')) && ($attr_obj->unique));
}

sub match_attributes {
    my $self = shift;

    return uniq $self->_match_attributes, 
                map { 
                    $self->_is_attr_unique($_) ? ($_) : () 
                } $self->get_attribute_list;
}


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

