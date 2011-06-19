{
    package MyApp::RoleA;
    use Moose::Role;
    use MooseX::Unique;

    has identity => (
        is  => 'ro',
        isa => 'Str',
        required => 1,
        unique => 1,
    );

    has number =>  ( 
        is => 'rw',
        isa => 'Int'
    );

    no Moose::Role;
    1;

}

{
    package MyApp::RoleB;
    use Moose::Role;
    no Moose::Role;
    1;
}

{
    package MyApp;
    use Moose;
    with 'MyApp::RoleA', 'MyApp::RoleB';
    __PACKAGE__->meta->make_immutable();
}

require 't/main.pl';
