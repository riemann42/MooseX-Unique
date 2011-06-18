package MooseX::Unique::Meta::Trait::Role;
#ABSTRACT:  MooseX::Unique Role MetaRole
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

sub apply_match_attributes_to_class {
    my ($role,$class) = @_;
    $class = Moose::Util::MetaRole::apply_metaroles(
        for             => $class,
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
        },
    );

    if ( $class->_has_match_attributes ) {
        $class->add_match_attribute( @{ $role->match_attribute } );
    }
    else {
        $class->match_attribute( $role->match_attribute );
    }
    return $class;
}

sub composition_class_roles {
    return ('MooseX::Unique::Meta::Trait::Role::Composite');
}




1;
__END__

=head1 SYNOPSIS

See L<MooseX::Unique|MooseX::Unique>;

=head1 DESCRIPTION

Provides the attribute match_attribute to your role metaclass.

=method match_attributes

Returns a list of match attributes

=method add_match_attribute

Add a match attribute

=attr match_attribute

An arrayref of match attributes

=method apply_match_attributes_to_class

Apply the role to a class (or role).

=method composition_class_roles

=for stopwords
BUILDARGS params  readonly MetaRole metaclass
