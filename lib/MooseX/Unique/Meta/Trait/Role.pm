package MooseX::Unique::Meta::Trait::Role;
#ABSTRACT:  MooseX::Unique Role MetaRole
use Moose::Role;

with 'MooseX::Unique::Meta::Trait::Class';

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

    if ($role->_has_match_requires) {
        if ($class->_has_match_requires) {
            $class->match_requires($class->match_requires + $role->match_requires)
        }
        else {
            $class->match_requires($role->match_requires)
        }
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
