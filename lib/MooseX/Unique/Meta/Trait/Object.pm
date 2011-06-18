package MooseX::Unique::Meta::Trait::Object;
#ABSTRACT:  MooseX::Unique base class role
use Moose::Role;
use strict; use warnings;

sub new_or_modify {
    my ($class,@opts) = @_;
    my $instance = $class->find_matching(@opts);
    if ($instance) {
        return $instance->modify(@opts);
    }
    return $class->new(@opts);
};

sub find_matching {
    my ($class,@opts) = @_;
    if ( $class->meta->_has_match_attributes ) {
        my $params =   ( ref $opts[0] )      ?  $opts[0]  
                     : ( !scalar @opts % 2 ) ?  {@opts}   
                     :  undef;
        if ($params) {
            for my $instance ( $class->meta->instances ) {
                my ($match,$potential) = (0,0);
                MATCH_ATTR:
                for my $match_attr ( $class->meta->match_attributes ) {
                    if ( ref $match_attr ) {
                        next MATCH_ATTR unless $match_attr->has_value($instance);
                        $match_attr = $match_attr->get_read_method;
                    }
                    if ( $instance->{$match_attr} )  {
                        if ( $instance->$match_attr eq $params->{$match_attr} )  {
                            $match++;
                        }
                        $potential++;    
                    }
                }
                #if (($match) && ($match == $potential)) { return $instance; }
                if ($match) { 
                    return $instance; 
                }  
            }
        }
    }
    return;
}

sub modify {
    my ($self,@opts) = @_;
    my $params =   ( ref $opts[0] )      ?  $opts[0]  
                    : ( !scalar @opts % 2 ) ?  {@opts}   
                    : {};
    my $meta = $self->meta;
    while (my ($attr,$value) = each %{$params}) {
        $meta->find_attribute_by_name($attr)->set_value($self, $value);
    }
    return $self;
}

1;
__END__

=head1 SYNOPSIS

See L<MooseX::Unique|MooseX::Unique>;

=head1 DESCRIPTION

This adds the methods new_or_modify, modify, and find_matching to your base
class.  For use with MooseX::Unique;

=method $class->new_or_modify

Wrapper around your new method that looks up the attribute for you.  Please
note that this module does not (yet) process your BUILDARGS.  So, values must
be passed as a hash or hash reference.

=method $instance->modify(%PARAMS)

Applies the params to the instance.  Will happily change readonly params.
Will fire off triggers (this may change!).

=method $class->find_matching(%PARAMS)

Given a set of params, finds a matching instance if available.


=for stopwords
BUILDARGS params  readonly MetaRole metaclass
