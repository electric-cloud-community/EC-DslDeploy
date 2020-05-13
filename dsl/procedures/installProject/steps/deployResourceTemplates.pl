#  
#  deployResourceTemplate.pl - Loop through the resource templates  and invoke each individually
#  
#  Copyright 2020 CloudBees, Inc.
#

use Cwd;
$[/myProject/scripts/perlHeaderJSON]

my $dsl = <<'END_MESSAGE';
import groovy.transform.BaseScript
import com.electriccloud.commander.dsl.util.BaseObject

//noinspection GroovyUnusedAssignment
@BaseScript BaseObject baseScript

$[/myProject/scripts/summaryString]

// Variables available for use in DSL code
def projectName = '$[projName]'
def projectDir = '$[projDir]'
def overwrite = '$[overwrite]'
def counters

project projectName, {
  counters = loadObjects("deployResourceTemplate", projectDir, "/projects/$projectName",
    [projectName: projectName, projectDir: projectDir], overwrite
  )
}

setProperty(propertyName: "summary", value: summaryString(counters))
END_MESSAGE

# Create dsl file in job workspace
use Cwd 'abs_path';
my $dslFile = abs_path('deployResourceTemplate.$[/myJob/id].commandDsl');

open(FH, '>', $dslFile) or die "ERROR: failed to write dsl file with error: $!";
print FH $dsl;
close(FH);

print `ectool --timeout $[/server/@PLUGIN_KEY@/timeout] evalDsl --dslFile "$dslFile" --serverLibraryPath "$[/server/settings/pluginsDirectory]/$[/myProject/projectName]/dsl" $[additionalDslArguments] 2>&1`;
