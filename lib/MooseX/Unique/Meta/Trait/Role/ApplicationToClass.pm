package MooseX::Unique::Meta::Trait::Role::ApplicationToClass;
#ABSTRACT:  MooseX::Unique helper module
use Moose::Role;
use Moose::Util::MetaRole;

around apply => sub {
    my ( $orig, $self,$role,$class ) = @_;


    Moose::Util::MetaRole::apply_base_class_roles(
        for   => $class,
        roles => ['MooseX::Unique::Meta::Trait::Object'],
    );


    if ($role->can('apply_match_attributes_to_class')) {
        $class = $role->apply_match_attributes_to_class($class);
    }

    $self->$orig( $role,$class );

    return $class;
};

1;
__END__

=head1 SYNOPSIS

See L<MooseX::Unique|MooseX::Unique>;

=head1 DESCRIPTION

Helps when MooseX::Unique is used in role context.



=for stopwords
BUILDARGS params  readonly MetaRole metaclass
