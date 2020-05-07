package Data::Object::Name;

use 5.014;

use strict;
use warnings;
use routines;

# VERSION

# BUILD

my $sep = qr/'|__|::|\\|\//;

# METHODS

method dist() {

  return $self->label =~ s/_/-/gr;
}

method file() {
  return $$self if $self->lookslike_a_file;

  my $string = $self->package;

  return join '__', map {
    join '_', map {lc} map {split /_/} grep {length}
    split /([A-Z]{1}[^A-Z]*)/
  } split /$sep/, $string;
}

method format($method, $format) {
  my $string = $self->$method;

  return sprintf($format || '%s', $string);
}

method label() {
  return $$self if $self->lookslike_a_label;

  return join '_', split /$sep/, $self->package;
}

method lookslike_a_file() {
  my $string = $$self;

  return $string =~ /^[a-z](?:\w*[a-z])?$/;
}

method lookslike_a_label() {
  my $string = $$self;

  return $string =~ /^[A-Z](?:\w*[a-zA-Z0-9])?$/;
}

method lookslike_a_package() {
  my $string = $$self;

  return $string =~ /^[A-Z](?:(?:\w|::)*[a-zA-Z0-9])?$/;
}

method lookslike_a_path() {
  my $string = $$self;

  return $string =~ /^[A-Z](?:(?:\w|\\|\/|[\:\.]{1}[a-zA-Z0-9])*[a-zA-Z0-9])?$/;
}

method lookslike_a_pragma() {
  my $string = $$self;

  return $string =~ /^\[\w+\]$/;
}

method new($class: $name = '') {

  return bless \$name, $class;
}

method package() {
  return $$self if $self->lookslike_a_package;

  return substr($$self, 1, -1) if $self->lookslike_a_pragma;

  my $string = $$self;

  if ($string !~ $sep) {
    return join '', map {ucfirst} split /[^a-zA-Z0-9]/, $string;
  } else {
    return join '::', map {
      join '', map {ucfirst} split /[^a-zA-Z0-9]/
    } split /$sep/, $string;
  }
}

method path() {
  return $$self if $self->lookslike_a_path;

  return join '/', split /$sep/, $self->package;
}

1;
