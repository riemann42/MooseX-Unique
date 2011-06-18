{
    package MyApp::Role;
    use Moose::Role;
    use MooseX::Unique;

    has identity => (
        is  => 'ro',
        isa => 'Str',
        required => 1,
        unique => 1,
        traits => ['MooseX::Unique::Meta::Trait::Attribute'],
    );

    has number =>  ( 
        is => 'rw',
        isa => 'Int'
    );

    no Moose::Role;
    1;

}

{
    package MyApp;
    use Moose;
    use MooseX::Unique;
    with 'MyApp::Role';
    __PACKAGE__->meta->make_immutable();
}

require 't/main.pl';
