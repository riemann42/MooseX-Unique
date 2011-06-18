package MooseX::Unique::Meta::Trait::Attribute;
#ABSTRACT: MooseX::Unique Attribute Trait;
use Moose::Role;

has unique => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

1;
__END__

=head1 SYNOPSIS

See L<MooseX::Unique|MooseX::Unique>;

=head1 DESCRIPTION

This is the attribute trait which adds a Bool value 'unique'.
