#############################################################################
#
#  Save project
#
#  Author: L.Rochette
#
#  Copyright 2019 CloudBees Inc.
#
#     Licensed under the Apache License, Version 2.0 (the "License");
#     you may not use this file except in compliance with the License.
#     You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#     Unless required by applicable law or agreed to in writing, software
#     distributed under the License is distributed on an "AS IS" BASIS,
#     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#     See the License for the specific language governing permissions and
#     limitations under the License.
#
# History
# ---------------------------------------------------------------------------
# 2019-Jul-07 lrochette original version
#############################################################################
use File::Path;

$[/myProject/scripts/perlHeaderJSON]

#
# Parameters
#
my $path  = '$[pathname]';
my $pName = '$[projName]';

#
# Global
#
my $errorCount = 0;
my $schedCount = 0;
my $procCount  = 0;
my $stepCount  = 0;

my $includeACLs      = 1;
my $includeNotifiers = 1;
my $relocatable      = 1;
my $format           = 'DSL';

# Create the Projects directory
mkpath("$path/projects");
chmod(0777, "$path/projects") or die("Can't change permissions on $path/projects: $!");

printf("Saving Project: %s\n", $pName);
my $fileProjectName=safeFilename($pName);
mkpath("$path/projects/$fileProjectName");
chmod(0777, "$path/projects/$fileProjectName");

#
# Save schedules
#
mkpath("$path/projects/$fileProjectName/schedules");
chmod(0777, "$path/projects/$fileProjectName/schedules");

my ($success, $xPath) = InvokeCommander("SuppressLog", "getSchedules", $pName);
foreach my $proc ($xPath->findnodes('//schedule')) {
  my $schedName=$proc->{'scheduleName'};
  my $fileScheduleName=safeFilename($schedName);
  printf("  Saving schedule: %s\n", $schedName);

  mkpath("$path/projects/$fileProjectName/schedules/$fileScheduleName");
  chmod(0777, "$path/projects/$fileProjectName/schedules/$fileScheduleName");
    my ($success, $res, $errMsg, $errCode) =
    backupObject($format, "$path/projects/$fileProjectName/schedules/$fileScheduleName/schedule",
      "/projects[$pName]schedules[$schedName]", $relocatable, $includeACLs, $includeNotifiers);

  if (! $success) {
    printf("  Error exporting schedule %s", $schedName);
    printf("  %s: %s\n", $errCode, $errMsg);
    $errorCount++;
  }
  else {
    $schedCount++;
  }
}     #schedule loop


#
# Save procedures
#
mkpath("$path/projects/$fileProjectName/procedures") || die ("Cannot create procedures directory");
chmod(0777, "$path/projects/$fileProjectName/procedures");

my ($success, $xPath) = InvokeCommander("SuppressLog", "getProcedures", $pName);
foreach my $proc ($xPath->findnodes('//procedure')) {
  my $procName=$proc->{'procedureName'};
  my $fileProcedureName=safeFilename($procName);
  printf("  Saving Procedure: %s\n", $procName);

  mkpath("$path/projects/$fileProjectName/procedures/$fileProcedureName") || die ("Cannot create procedures/$fileProcedureName directory");
  chmod(0777, "$path/projects/$fileProjectName/procedures/$fileProcedureName");
  my ($success, $res, $errMsg, $errCode) =
  backupObject($format, "$path/projects/$fileProjectName/procedures/$fileProcedureName/procedure",
    "/projects[$pName]procedures[$procName]", $relocatable, $includeACLs, $includeNotifiers);

  if (! $success) {
    printf("  Error exporting procedure %s", $procName);
    printf("  %s: %s\n", $errCode, $errMsg);
    $errorCount++;
  }
  else {
    $procCount++;
  }
  #
  # Save steps
  #
  mkpath("$path/projects/$fileProjectName/procedures/$fileProcedureName/commands") || die ("Cannot create procedures/$fileProcedureName/commands directory");
  chmod(0777, "$path/projects/$fileProjectName/procedures/$fileProcedureName/commands");

  my($success, $stepNodes) = InvokeCommander("SuppressLog", "getSteps", $pName, $procName);
  foreach my $step ($stepNodes->findnodes('//step')) {
    my $stepName=$step->{'stepName'};
    my $fileStepName=safeFilename($stepName);
    my $shell=$step->{'shell'};
    my $command=$step->{'command'};

    printf("    Saving Step: %s\n", $stepName);

    my $ext=".sh"; # No way to detect whether sh or cmd
    if ($shell =~ /perl/) {
      $ext = ".pl";
    } elsif ($shell =~ /groovy/) {
      $ext = ".groovy";
    } elsif ($shell =~ /evalDsl/) {
      $ext = ".dsl";
    } elsif ($shell =~ /powershell/) {
      $ext = ".ps1";
    }

    my $commandFile = "$path/projects/$fileProjectName/procedures/$fileProcedureName/commands/$fileStepName${ext}";
    open (COMMAND, "> $commandFile") or die "$commandFile:  $!\n";
    print COMMAND $command, "\n";
    close COMMAND;
    $stepCount++;
  }  # step loop


}   # procedure loop


$[/myProject/scripts/perlBackupLib]
$[/myProject/scripts/perlLibJSON]
