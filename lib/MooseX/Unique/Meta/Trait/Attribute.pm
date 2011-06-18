package MooseX::Unique::Meta::Trait::Attribute;
#ABSTRACT: MooseX::Unique Attribute Trait;
use Moose::Role;
use Moose::Util;

has unique => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

Moose::Util::meta_attribute_alias('UniqueIdentity');


1;
__END__

=head1 SYNOPSIS

See L<MooseX::Unique|MooseX::Unique>;

=head1 DESCRIPTION

This is the attribute trait which adds a Bool value 'unique'.

Has an alias UniqueIdentity for your convenience.

=for stopwords
BUILDARGS params  readonly MetaRole metaclass
