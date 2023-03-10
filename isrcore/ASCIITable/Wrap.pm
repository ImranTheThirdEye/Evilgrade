###############
# Wrap.pm
#
# Copyright 2007 Francisco Amato
#
# This file is part of isr-evilgrade, www.faradaysec.com .
#
# isr-evilgrade is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation version 2 of the License.
#
# isr-evilgrade is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with isr-evilgrade; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
# '''
##
package isrcore::ASCIITable::Wrap;

@ISA=qw(Exporter);
@EXPORT = qw();
@EXPORT_OK = qw(wrap);
$VERSION = '0.2';
use Exporter;
use strict;
use Carp;

=head1 NAME

isrcore::ASCIITable::Wrap - Wrap text

=head1 SHORT DESCRIPTION

Make sure a text never gets wider than the specified width using wordwrap.

=head1 SYNOPSIS

  use isrcore::ASCIITable::Wrap qw{ wrap };
  print wrap('This is a long line which will be cut down to several lines',10);

=head1 FUNCTIONS

=head2 wrap($text,$width[,$nostrict]) (exportable)

Wraps text at the specified width. Unless the $nostrict parameter is set, it
will cut down the word if a word is wider than $width. Also supports text with linebreaks.

=cut

sub wrap {
  my ($text,$width,$nostrict) = @_;
  Carp::shortmess('Missing required text or width parameter.') if (!defined($text) || !defined($width));
  my $result='';
  for (split(/\n/,$text)) {
    $result .= _wrap($_,$width,$nostrict)."\n";
  }
  chop($result);
  return $result;
}

sub _wrap {
  my ($text,$width,$nostrict) = @_;
  my @result;
  my $line='';
  $nostrict = defined($nostrict) && $nostrict == 1 ? 1 : 0;
  for (split(/ /,$text)) {
    my $spc = $line eq '' ? 0 : 1;
    my $len = length($line);
    my $newlen = $len + $spc + length($_);
    if ($len == 0 && $newlen > $width) {
      push @result, $nostrict == 1 ? $_ : substr($_,0,$width); # kutt ned bredden
      $line='';
    }
    elsif ($len != 0 && $newlen > $width) {
      push @result, $nostrict == 1 ? $line : substr($line,0,$width);
      $line = $_;
    } else {
      $line .= (' ' x $spc).$_;
    }
  }
  push @result,$nostrict == 1 ? $line : substr($line,0,$width) if $line ne '';
  return join("\n",@result);
}


1;

__END__

=head1 REQUIRES

Exporter, Carp

=head1 AUTHOR

H?kon Nessj?en, lunatic@cpan.org

=head1 VERSION

Current version is 0.2.

=head1 COPYRIGHT

Copyright 2002-2003 by H?kon Nessj?en.
All rights reserved.
This module is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

isrcore::ASCIITable, isrcore::Wrap

=cut

