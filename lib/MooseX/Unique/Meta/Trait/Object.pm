package MooseX::Unique::Meta::Trait::Object;
#ABSTRACT:  MooseX::Unique base class role
use Moose::Role;
use strict; use warnings;

sub new_or_matching {
    my ($class,@opts) = @_;
    my $instance = $class->find_matching(@opts);
    return $instance ? $instance : $class->new(@opts);
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
                        $match_attr = $match_attr->name;
                    }
                    my $attr = $class->meta->find_attribute_by_name($match_attr);
                    if (  $attr->has_value($instance) )  {
                        if ( $attr->get_value($instance) eq $params->{$match_attr} )  {
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


1;
__END__

=head1 SYNOPSIS

See L<MooseX::Unique|MooseX::Unique>;

=head1 DESCRIPTION

This adds the methods new_or_matching and find_matching to your base
class.  For use with MooseX::Unique;

=method $class->new_or_matching

Wrapper around your new method that looks up the attribute for you.  Please
note that this module does not process your BUILDARGS before looking for an
instance.  So, values must be passed as a hash or hash reference. Any
attribute that is not flagged as unique will be ignored in the case of an
existing instance.

=method $class->find_matching(%PARAMS)

Given a set of params, finds a matching instance if available.

=for stopwords
BUILDARGS params readonly MetaRole metaclass
