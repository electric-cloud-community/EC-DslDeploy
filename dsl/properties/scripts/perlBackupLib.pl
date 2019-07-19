#############################################################################
#
# A few functions used in the backup procedures
#
#############################################################################

#
# Make the name of an object safe to be a file or directory name
#
sub safeFilename {
  my $safe=@_[0];
  $safe =~ s#[\*\.\"/\[\]\\:;,=\|\?<>]#_#g;
  $safe =~ s/^\s+//;     # remove heading spaces
  $safe =~ s/\s+$//;      # remove trailing spaces
  $safe =~ s/\x{2013}/-/g; # replace long MS dash by normal ones
  $safe =~ s/\x{fffd}/ /g; # replace black diamond question mark with space

  return $safe;
}

#############################################################################
#
# Function to create a string "X OBJ(s) exported"
# Parameters:
#  0. Number of objects
#  1. Object name
#
#############################################################################
sub createExportString {
   my $nb  = @_[0];
   my $obj = @_[1];

   return "" if ($nb <= 0);
   my $plural=($obj eq "server property") ? "server properties" : $obj . "s";
   return sprintf("%d %s exported\n", $nb, ($nb == 1 ? $obj : $plural));
}

#############################################################################
#
# Function to backup an object to a DSL (generateDsl) or XML (export) file.
# Parameters:
#  0. Format: XML or DSL
#  1. File Path: file to save
#  2. Object to backup
#  3. Relocatable flag
#  4. WithACL flag
#  5. withNotifiers flag
#
#############################################################################
sub backupObject {
  my $format           = @_[0];
  my $path             = @_[1];
  my $obj              = @_[2];
  my $relocatable      = @_[3];
  my $includeACLs      = @_[4];
  my $includeNotifiers = @_[5];

  my $extension = ($format eq "XML")?".xml":".groovy";

  if ($format eq "XML") {
    my ($success, $res, $errMsg, $errCode) =
      InvokeCommander("SuppressLog", "export", $path . ".xml",
  					{
              'path'        => $obj,
              'relocatable' => $relocatable,
              'withAcls'    => $includeACLs,
              'withNotifiers'=>$includeNotifiers
            }
      );
  } else {
    return saveDslFile("$path.groovy", $obj, $includeACLs);
  }

}         # backupObject function

sub saveDslFile {
  my $path    = @_[0];
  my $obj     = @_[1];
  my $withAcl = @_[2];

  my $ret;
  if (getVersion() lt "6.1") {
    $ret=system("ectool generateDsl \"$obj\" > \"$path\"");
  } else {
    $ret=system("ectool generateDsl \"$obj\" --withAcls $withAcl > \"$path\"");
  }

  if ($ret == 0) {
    # my ($success, $res, $errMsg, $errCode)
    return (1, "", "", "");
  } else {
    printf(" generateDsl error $ret");
    return (0, "", "", "");
  }
}
