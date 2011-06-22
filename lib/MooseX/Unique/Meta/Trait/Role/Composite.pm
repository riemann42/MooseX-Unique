package MooseX::Unique::Meta::Trait::Role::Composite;

#ABSTRACT:  MooseX::Unique helper module
use Moose::Role;
use Moose::Util::MetaRole;

with 'MooseX::Unique::Meta::Trait::Role';

around apply_params => sub {
    my $orig = shift;
    my $role = shift;
    $role = $role->$orig(@_);
    $role = Moose::Util::MetaRole::apply_metaroles(
        for            => $role,
        role_metaroles => {
            role      => ['MooseX::Unique::Meta::Trait::Role'],
            applied_attribute => ['MooseX::Unique::Meta::Trait::Attribute'],
            attribute => ['MooseX::Unique::Meta::Trait::Attribute'],
            application_to_class =>
                ['MooseX::Unique::Meta::Trait::Role::ApplicationToClass'],
            application_to_role =>
                ['MooseX::Unique::Meta::Trait::Role::ApplicationToRole'],
        },
    );
    for my $inc_role ( @{ $role->get_roles } ) {
        if ( $inc_role->can('match_attributes') ) {
            $role->add_match_attribute( $inc_role->match_attributes  );
        }
        if (   ( $inc_role->can('_has_match_requires') )
            && ( $inc_role->_has_match_requires ) ) {
            $role->add_match_requires($inc_role->match_requires);
        }
    }
    return $role;
};

no Moose::Role;
1;
__END__

=head1 SYNOPSIS

See L<MooseX::Unique|MooseX::Unique>;

=head1 DESCRIPTION

Helps when MooseX::Unique is used in role context.

=for stopwords
BUILDARGS params  readonly MetaRole metaclass
