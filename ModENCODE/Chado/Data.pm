package ModENCODE::Chado::Data;
=pod

=head1 NAME

ModENCODE::Chado::Data - A class representing a simplified Chado I<data> object.
B<NOTE:> The data table only exists in Chado instances with the BIR-TAB
extension installed.

=head1 SYNOPSIS

This class is an object-oriented representation of an entry in a Chado B<data>
table. It provides accessors for the various attributes of a datum that are
stored in the data table itself, plus accessors for relationships to certain
other Chado tables (such as B<attribute>, B<dbxref>, etc.)

=head1 USAGE

=head2 Implications Of Class::Std

=over

As with all of the ModENCODE::Chado::* object classes, this module utilizes
L<Class::Std> to enforce object-oriented programming practices. Therefore, many
of the accessor functions are automatically generated, and are of the form
<get|set>_<attribute>, e.g. $obj->L<get_name()|/get_name() | set_name($name)> or
$obj->L<set_name()|/get_name() | set_name($name)>.

ModENCODE::Chado::* objects can also be created with values at initialization
time by passing in a hash. For instance, C<my $obj = new
ModENCODE::Chado::Data({ 'heading' =E<gt> 'A Datum', 'value' =E<gt> 'some value'
});> will create a new Data object with a heading of 'A Datum' and a value of
'some value'. For complex types (other Chado objects), the default L<Class::Std>
setters and initializers have been replaced with subroutines that make sure the
type of the object being passed in is correct.

=back

=head2 Using ModENCODE::Chado::Data

=over

  my $datum = new ModENCODE::Chado::Data({
    # Simple attributes
    'chadoxml_id'       => 'Data_111',
    'name'              => 'name',
    'heading'           => 'Heading',
    'value'             => 'some value',
    'anonymous'         => 0,

    # Object relationships
    'termsource'        => new ModENCODE::Chado::DBXref(),
    'type'              => new ModENCODE::Chado::CVTerm(),
    'attributes'        => [ new ModENCODE::Chado::Attribute(), ... ]
    'features'          => [ new ModENCODE::Chado::Feature(), ... ]
    'wiggle_datas'      => [ new ModENCODE::Chado::Wiggle_Data(), ... ]
    'organisms'         => [ new ModENCODE::Chado::Organism(), ... ]
  });

  $datum->set_name('a name');
  my $name = $datum->get_name();
  print $datum->to_string();

=back

=head1 ACCESSORS

=over

=item get_chadoxml_id() | set_chadoxml_id($chadoxml_id)

The I<chadoxml_id> is used by L<ModENCODE::Chado::XMLWriter> to keep track of
the ChadoXML Macro ID (used to refer to the same feature in XML multiple times).
It is also populated when using L<ModENCODE::Parser::Chado> to pull data out of
a Chado database. (Note that the XMLWriter will generate new I<chadoxml_id>s in
this case; it does so whenever the I<chadoxml_id> is purely numeric.

=item get_name() | set_name($name)

The name of this Chado datum; it corresponds to the data.name field in a Chado
database. In a BIR-TAB document, the data columns have both a
L<heading|/get_heading() | set_heading($heading)> and a name in the format
C<Heading [Name]>.

=item get_heading() | set_heading($heading)

The heading of this Chado datum; it corresponds to the data.heading field in a
Chado database. In a BIR-TAB document, the data columns have both a heading and
a L<name|/get_name() | set_name($name)> in the format C<Heading [Name]>.

=item get_value() | set_value($value)

The value of this Chado datum; it corresponds to the data.value field in a Chado
database. In a BIR-TAB document, this is the content of a single cell in a data
column.

=item is_anonymous() | set_anonymous($anonymous)

Whether or not this datum is an anonymous datum. This field does not correspond
to any fields in Chado and is used internally to keep track of data that have
been created to link together applied protocols with no explicitly shared
inputs/outputs. It is used as a boolean; B<0> is false, most other values
(including B<1>) are true.

=item get_termsource() | set_termsource($dbxref)

The dbxref for this Chado datum. This must be a L<ModENCODE::Chado::DBXref> or
conforming subclass (via C<isa>). The dbxref object corresponds to a dbxref in
the Chado dbxref table, and the data.dbxref_id field is used to track the
relationship. In the context of BIR-TAB, a termsource dbxref is the reference to
a term controlled by a Term Source REF column. (For instance, a datum with a
value of 'AI515079' coule have a Term Source REF of 'dbEST'.  The dbxref would
then be for the 'AI515079' EST in the dbEST repository.)

=item get_type() | set_type($type)

The type of the value of this Chado datum. This must be a
L<ModENCODE::Chado::CVTerm> or conforming subclass (via C<isa>). The type object
corresponds to a cvterm in the Chado cvterm table, and the data.type_id field is
used to track the relationship.

=item get_attributes() | add_attribute($attribute) | set_attributes(\@attributes)

A list of all the attributes associated with this Chado datum. The attributes
provide more information about this datum and reside in the Chado attribute
table. These attributes are generally attached from a BIR-TAB document - columns
with headings that are not specifically defined as data, protocol, or term
source columns are assumed to be attribute columns for the preceding data or
protocol column.

The attributes are L<ModENCODE::Chado::Attribute> objects. The adder adds
another attribute to the list, the getter returns an arrayref of
L<ModENCODE::Chado::Attribute> objects, and the setter replaces the current
list, given an (empty or populated) array of
L<Attribute|ModENCODE::Chado::Attribute> objects. The attribute objects may also
be conforming subclasses (via C<isa>) of L<ModENCODE::Chado::Attribute>. The
attribute objects corresponds to the attributes in the Chado attributes table,
and the data_attribute.attribute_id and data_attribute.data_id fields are used
to track the relationship.

=item get_features() | add_feature($feature) | set_features(\@features)

A list of all the features associated with this Chado datum. The link to the
feature table is akin to a dbxref - it provides a more controlled view of the
L<value|/get_value() | set_value($value)> of the datum, assuming the value is a
genomic feature. (For example, a value of "smaug" with a L<type|/get_type() |
set_type($type)> of 'fly gene' may refer to the spade gene in I<D.
melanogaster>, and should thus an associated entry in the feature table.)

The features are L<ModENCODE::Chado::Feature> objects. The adder adds another
feature to the list, the getter returns an arrayref of
L<ModENCODE::Chado::Feature> objects, and the setter replaces the current list,
given an (empty or populated) array of L<Feature|ModENCODE::Chado::Feature>
objects. The feature objects may also be conforming subclasses (via C<isa>) of
L<ModENCODE::Chado::Feature>. The feature objects corresponds to the features in
the Chado features table, and the data_feature.feature_id and
data_feature.data_id fields are used to track the relationship.

=item get_wiggle_datas() | add_wiggle_data($wiggle_data) | set_wiggle_datas(\@wiggle_datas)

A list of all the Wiggle (WIG) format data associated with this Chado datum. The
link to the wiggle_data table is akin to a dbxref - it provides a more
controlled view of the L<value|/get_value() | set_value($value)> of the datum,
assuming the value refers to information in Wiggle format. (For example, if the
value is 'wiggle.txt', referring to a wiggle file, and the L<type|/get_type() |
set_type($type)> is 'WIG', then the datum should thus have an associated entry
in the wiggle_data table.)

The Wiggle data are L<ModENCODE::Chado::Wiggle_Data> objects. The adder adds
another wiggle_data to the list, the getter returns an arrayref of
L<ModENCODE::Chado::Wiggle_Data> objects, and the setter replaces the current
list, given an (empty or populated) array of
L<Wiggle_Data|ModENCODE::Chado::Wiggle_Data> objects. The Wiggle objects may
also be conforming subclasses (via C<isa>) of L<ModENCODE::Chado::Wiggle_Data>.
The Wiggle objects correspond to the Wiggle data in the Chado wiggle_data table,
and the data_wiggle_data.wiggle_data_id and data_wiggle_data.data_id fields are
used to track the relationship.

=item get_organisms() | add_organism($organism) | set_organisms(\@organisms)

A list of all the organisms associated with this Chado feature. The link to
the organism table is akin to the dbxref - it provides a more controlled view of
the L<value|/get_value() | set_value($value)> of the feature, assuming the
value is an organism. (For example, a value of "Drosophila melanogaster" with a
L<type|/get_type() | set_type($type)> of 'organism' should have an associated
organism in the organism table.)

The organisms are L<ModENCODE::Chado::Organism> objects. The adder adds another
organism to the list, the getter returns an arrayref of
L<ModENCODE::Chado::Organism> objects, and the setter replaces the current list,
given an (empty or populated) array of L<Organism|ModENCODE::Chado::Organism>
objects. The organism objects may also be conforming subclasses (via C<isa>) of
L<ModENCODE::Chado::Organism>.  The organism objects corresponds to the
organisms in the Chado organisms table, and the data_organism.data_id and
data_organism.organism_id fields are used to track the relationship.

=back

=head1 UTILITY FUNCTIONS

=over

=item equals($obj)

Returns true if this feature and $obj are equal. Checks all simple and some of
the complex attributes. Also requires that this object and $obj are of the exact
same type.  (A parent class != a subclass, even if all attributes are the same.)

B<NOTE:> This does not check to see if the features, wiggle_data, organisms, or
attributes are equal, to avoid deep graph recursion. This is generally fine,
since within a given submission package, a datum with the same heading, name,
and value will be expanded into the same organisms/features/etc.

=item clone()

Returns a deep copy of this object, recursing to clone all complex type
attributes.

=item mimic($datum)

Given a ModENCODE::Chado::Data, sets all of the attributes of this datum to
be the same as $datum, including recursively cloning complex objects.

=item to_string()

Return a string representation of this analysisfeature. Attempts to print the
associated features and wiggle_data. Because the feature's to_string method
follows feature relationships, this may involve deep graph traversal and thus
can take some time.

=back

=head1 SEE ALSO

L<Class::Std>, L<ModENCODE::Chado::DBXref>, L<ModENCODE::Chado::CVTerm>,
L<ModENCODE::Chado::Attribute>, L<ModENCODE::Chado::Feature>,
L<ModENCODE::Chado::Wiggle_Data>, L<ModENCODE::Chado::Organism>

=head1 AUTHOR

E.O. Stinson L<mailto:yostinso@berkeleybop.org>, ModENCODE DCC
L<http://www.modencode.org>.
=cut

use strict;
use Class::Std;
use Carp qw(croak);


# Attributes
my %data_id          :ATTR( :name<id>,                  :default<undef> );
my %heading          :ATTR( :get<heading>,              :init_arg<heading> );
my %name             :ATTR( :get<name>,                 :init_arg<name>,        :default<''> );
my %value            :ATTR( :get<value>,                :init_arg<value> );
my %anonymous        :ATTR( :set<anonymous>,            :init_arg<anonymous>,   :default<0> );

# Relationships
my %termsource       :ATTR( :set<termsource>,           :init_arg<termsource>,  :default<undef> );
my %type             :ATTR( :set<type>,                 :init_arg<type>,        :default<undef> );
my %attributes       :ATTR( :set<attributes>,           :init_arg<attributes>,  :default<[]> );
my %features         :ATTR( :init_arg<features>,                                :default<{}> );
my %wiggle_datas     :ATTR( :set<wiggle_datas>,         :init_arg<wiggle_datas>, :default<[]> );
my %organisms        :ATTR( :set<organisms>,            :init_arg<organisms>,   :default<[]> );

sub new_no_cache {
  return Class::Std::new(@_);
}

sub set_features {
  my ($self, $new_features) = @_;
  if (ref($new_features) eq "HASH") {
    $features{ident $self} = $new_features;
  } elsif (ref($new_features) eq "ARRAY") {
    $features{ident $self} = {};
    foreach my $new_feature (@$new_features) {
      $features{ident $self}->{$new_feature->get_id} = $new_feature;
    }
  } else {
    die "Can't set_features() something that isn't a hash or array: " . ref($new_features);
  }
}

sub new {
  my $temp = Class::Std::new(@_);
  return new ModENCODE::Cache::Data({'content' => $temp }) if ModENCODE::Cache::get_paused();
  my $cached_datum = ModENCODE::Cache::get_cached_datum($temp);

  if ($cached_datum) {
    # Update any cached datum
    my $need_save = 0;
    if ($temp->get_termsource() && !($cached_datum->get_object->get_termsource())) {
      $cached_datum->get_object->set_termsource($temp->get_termsource);
      $need_save = 1;
    }
    if (scalar($temp->get_attributes) && !scalar($cached_datum->get_object->get_attributes)) {
      $cached_datum->get_object->set_attributes($temp->get_attributes);
      $need_save = 1;
    }
    if (scalar($temp->get_features) && !scalar($cached_datum->get_object->get_features)) {
      $cached_datum->get_object->set_features($temp->get_features);
      $need_save = 1;
    }
    if (scalar($temp->get_wiggle_datas) && !scalar($cached_datum->get_object->get_wiggle_datas)) {
      $cached_datum->get_object->set_wiggle_datas($temp->get_wiggle_datas);
      $need_save = 1;
    }
    if (scalar($temp->get_organisms) && !scalar($cached_datum->get_object->get_organisms)) {
      $cached_datum->get_object->set_organisms($temp->get_organisms);
      $need_save = 1;
    }
    ModENCODE::Cache::save_datum($cached_datum->get_object) if $need_save;
    return $cached_datum;
  }

  # This is a new datum
  my $self = $temp;
  return ModENCODE::Cache::add_datum_to_cache($self);
}

sub BUILD {
  my ($self, $ident, $args) = @_;
  my $termsource = $args->{'termsource'};
  if (defined($termsource)) {
    $self->set_termsource($termsource);
  }
  my $type = $args->{'type'};
  if (defined($type)) {
    $self->set_type($type);
  }
  my $features = $args->{'features'};
  if (defined($features)) {
    if (ref($features) eq 'HASH') {
      $features = [ values(%$features) ];
    } elsif (ref($features) ne 'ARRAY' && ref($features) ne 'HASH') {
      $features = [ $features ];
    }
    foreach my $feature (@$features) {
      $self->add_feature($feature);
    }
  }
  my $wiggle_datas = $args->{'wiggle_datas'};
  if (defined($wiggle_datas)) {
    if (ref($wiggle_datas) ne 'ARRAY') {
      $wiggle_datas = [ $wiggle_datas ];
    }
    foreach my $wiggle_data (@$wiggle_datas) {
      $self->add_wiggle_data($wiggle_data);
    }
  }
  my $organisms = $args->{'organisms'};
  if (defined($organisms)) {
    if (ref($organisms) ne 'ARRAY') {
      $organisms = [ $organisms ];
    }
    foreach my $organism (@$organisms) {
      $self->add_organism($organism);
    }
  }
  my $attributes = $args->{'attributes'};
  if (defined($attributes)) {
    if (ref($attributes) ne 'ARRAY') {
      $attributes = [ $attributes ];
    }
    foreach my $attribute (@$attributes) {
      $self->add_attribute($attribute);
    }
  }
}

sub is_anonymous {
  my ($self) = @_;
  return $anonymous{ident $self};
}

sub get_attribute_ids {
  my $self = shift;
  return map { $_->get_id } @{$attributes{ident $self}}
}

sub get_attributes {
  my $self = shift;
  my $get_cached_object = shift || 0;
  my $attributes = $attributes{ident $self};
  return $get_cached_object ? map { $_->get_object } @$attributes : @$attributes;
}

sub get_feature_ids {
  my $self = shift;
  return keys(%{$features{ident $self}});
}

sub get_features {
  my $self = shift;
  my $get_cached_object = shift || 0;
  my @features = values(%{$features{ident $self}});
  return $get_cached_object ? map { $_->get_object } @features : @features;
}

sub get_wiggle_data_ids {
  my $self = shift;
  return map { $_->get_id } @{$wiggle_datas{ident $self}}
}

sub get_wiggle_datas {
  my $self = shift;
  my $get_cached_object = shift || 0;
  my $wiggle_datas = $wiggle_datas{ident $self};
  return $get_cached_object ? map { $_->get_object } @$wiggle_datas : @$wiggle_datas;
}

sub get_organism_ids {
  my $self = shift;
  return map { $_->get_id } @{$organisms{ident $self}}
}

sub get_organisms {
  my $self = shift;
  my $get_cached_object = shift || 0;
  my $organisms = $organisms{ident $self};
  return $get_cached_object ? map { $_->get_object } @$organisms : @$organisms;
}

sub get_type_id {
  my $self = shift;
  return $type{ident $self} ? $type{ident $self}->get_id : undef;
}

sub get_type {
  my $self = shift;
  my $get_cached_object = shift || 0;
  my $type = $type{ident $self};
  return undef unless defined $type;
  return $get_cached_object ? $type{ident $self}->get_object : $type{ident $self};
}

sub get_termsource_id {
  my $self = shift;
  return $termsource{ident $self} ? $termsource{ident $self}->get_id : undef;
}

sub get_termsource {
  my $self = shift;
  my $get_cached_object = shift || 0;
  my $termsource = $termsource{ident $self};
  return undef unless defined $termsource;
  return $get_cached_object ? $termsource->get_object : $termsource;
}

sub add_feature {
  my ($self, $feature) = @_;
  ($feature->get_object->isa('ModENCODE::Chado::Feature')) or croak("Can't add a " . ref($feature) . " as a feature.");
  $features{ident $self}->{$feature->get_id} = $feature;
}

sub add_wiggle_data {
  my ($self, $wiggle_data) = @_;
  ($wiggle_data->get_object->isa('ModENCODE::Chado::Wiggle_Data')) or croak("Can't add a " . ref($wiggle_data) . " as a wiggle_data.");
  return if grep { $_->get_id == $wiggle_data->get_id } @{$wiggle_datas{ident $self}};
  push @{$wiggle_datas{ident $self}}, $wiggle_data;
}

sub add_organism {
  my ($self, $organism) = @_;
  ($organism->get_object->isa('ModENCODE::Chado::Organism')) or croak("Can't add a " . ref($organism) . " as an organism.");
  return if grep { $_->get_id == $organism->get_id } @{$organisms{ident $self}};
  push @{$organisms{ident $self}}, $organism;
}

sub add_attribute {
  my ($self, $attribute) = @_;
  ($attribute->get_object->isa('ModENCODE::Chado::Attribute')) or croak("Can't add a " . ref($attribute) . " as a attribute.");
  return if grep { $_->get_id == $attribute->get_id } @{$attributes{ident $self}};
  push @{$attributes{ident $self}}, $attribute;
}

sub to_string {
  my ($self) = @_;
  my $string = $self->get_heading();
  $string .= "['" . $self->get_name() . "']" if $self->get_name();
  $string .= $self->get_termsource()->get_object->to_string() if $self->get_termsource();
  if (scalar($self->get_attributes())) {
    $string .= "<";
    foreach my $attribute ($self->get_attributes(1)) {
      $string .= $attribute->to_string();
    }
    $string .= ">";
  }
  $string .= $self->get_type()->get_object->to_string() if $self->get_type();
  $string .= "=" if ($self->get_value || scalar($self->get_features) || scalar($self->get_wiggle_datas));
  $string .= $self->get_value();
  $string .= " with " . scalar($self->get_features) . " features";
  foreach my $feature ($self->get_features(1)) {
    $string .= "," . $feature->to_string();
  }
  foreach my $wiggle_data ($self->get_wiggle_datas(1)) {
    $string .= "," . $wiggle_data->to_string();
  }
  return $string;
}

sub equals {
  my ($self, $other) = @_;

  return 1 if ($self == $other);
  return 0 unless ref($self) eq ref($other);

  return 0 unless ($self->get_name() eq $other->get_name() && $self->get_heading() eq $other->get_heading()&& $self->get_value() eq $other->get_value());

  my @attributes = @{$self->get_attributes()};
  return 0 unless scalar(@attributes) == scalar(@{$other->get_attributes()});
  foreach my $attribute (@attributes) {
    return 0 unless scalar(grep { $_->equals($attribute) } @{$other->get_attributes()});
  }

  return 0 unless $self->get_termsource() == $other->get_termsource(); # Can do this by ref since we cache CVTerms and DBXrefs for uniqueness
#  if ($self->get_termsource()) {
#    return 0 unless $other->get_termsource();
#    return 0 unless $self->get_termsource()->equals($other->get_termsource());
#  } else {
#    return 0 if $other->get_termsource();
#  }

  return 0 unless $self->get_type() == $other->get_type(); # Can do this by ref since we cache CVTerms and DBXrefs for uniqueness
#  if ($self->get_type()) {
#    return 0 unless $other->get_type();
#    return 0 unless $self->get_type()->equals($other->get_type());
#  } else {
#    return 0 if $other->get_type();
#  }
#
#  my @features = @{$self->get_features()};
#  return 0 unless scalar(@features) == scalar(@{$other->get_features()});
#  foreach my $feature (@features) {
#    return 0 unless scalar(grep { $_->equals($feature) } @{$other->get_features()});
#  }

#  my @wiggle_datas = @{$self->get_wiggle_datas()};
#  return 0 unless scalar(@wiggle_datas) == scalar(@{$other->get_wiggle_datas()});
#  foreach my $wiggle_data (@wiggle_datas) {
#    return 0 unless scalar(grep { $_->equals($wiggle_data) } @{$other->get_wiggle_datas()});
#  }

#  my @organisms = @{$self->get_organisms()};
#  return 0 unless scalar(@organisms) == scalar(@{$other->get_organisms()});
#  foreach my $organism (@organisms) {
#    return 0 unless scalar(grep { $_->equals($organism) } @{$other->get_organisms()});
#  }

  return 1;
}

sub save {
  ModENCODE::Cache::save_datum(shift);
}

1;

