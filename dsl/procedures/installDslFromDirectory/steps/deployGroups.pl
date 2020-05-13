#  
#  deployGroups.pl - Loop through the groups and invoke each individually
#  
#  Copyright 2020 CloudBees, Inc.
#

use Cwd;
$[/myProject/scripts/perlHeaderJSON]

my $dsl = <<'END_MESSAGE';
import groovy.io.FileType
import groovy.transform.BaseScript
import com.electriccloud.commander.dsl.util.BaseObject

//noinspection GroovyUnusedAssignment
@BaseScript BaseObject baseScript

$[/myProject/scripts/summaryString]

def absDir='$[/myJob/CWD]'
def overwrite = '$[overwrite]'
File dir=new File(absDir, "groups")

if (dir.exists()) {
  def counters=loadObjects('group', absDir, "/", [:], overwrite, true)
  def nb=counters['group']
  setProperty(propertyName: "summary", value: summaryString(counters))
} else {
  setProperty(propertyName:"summary", value:"No groups")
}
END_MESSAGE

# Create dsl file in job workspace
use Cwd 'abs_path';
my $dslFile = abs_path('deployGroups.$[/myJob/id].commandDsl');

open(FH, '>', $dslFile) or die "ERROR: failed to write dsl file with error: $!";
print FH $dsl;
close(FH);

print `ectool --timeout $[/server/@PLUGIN_KEY@/timeout] evalDsl --dslFile "$dslFile" --serverLibraryPath "$[/server/settings/pluginsDirectory]/$[/myProject/projectName]/dsl" $[additionalDslArguments] 2>&1`;
