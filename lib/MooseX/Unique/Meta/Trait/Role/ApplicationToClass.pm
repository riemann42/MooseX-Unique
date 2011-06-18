package MooseX::Unique::Meta::Trait::Role::ApplicationToClass;
#ABSTRACT:  MooseX::Unique helper module
use Moose::Role;
use Moose::Util::MetaRole;

around apply => sub {
    my ( $orig, $self, @args ) = @_;
    $self->$orig( @args );
    if ($args[0]->can('apply_match_attributes_to_class')) {
        $args[0]->apply_match_attributes_to_class($args[1]);
    }
    Moose::Util::MetaRole::apply_base_class_roles(
        for   => $args[1],
        roles => ['MooseX::Unique::Meta::Trait::Object'],
    );
    return $args[1];
};

1;
__END__

=head1 SYNOPSIS

See L<MooseX::Unique|MooseX::Unique>;

=head1 DESCRIPTION

Helps when MooseX::Unique is used in role context.


