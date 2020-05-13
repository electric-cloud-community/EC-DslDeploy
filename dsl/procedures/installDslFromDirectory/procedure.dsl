import java.io.File

def procName = 'installDslFromDirectory'

def dslShell = 'ectool --timeout $[/server/@PLUGIN_KEY@/timeout] evalDsl --dslFile {0}.groovy --serverLibraryPath "$[/server/settings/pluginsDirectory]/$[/myProject/projectName]/dsl" $[additionalDslArguments]'

procedure procName,
  jobNameTemplate: 'install-dsl-from-directory-$[jobId]',
  resourceName: '$[pool]',
{
  step 'setAdditionalDslArguments',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/setAdditionalDslArguments.pl").text,
    resourceName: '$[pool]',
    shell: 'ec-perl',
    workingDirectory: '$[directory]',
    postProcessor: 'postp'

  step 'deployMain',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployMain.pl").text,
    resourceName: '$[pool]',
    shell: 'ec-perl',
    workingDirectory: '$[directory]'

  step 'deployTags',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployTags.pl").text,
    resourceName: '$[pool]',
    shell: 'ec-perl'

  step 'deployPersonaPages',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployPersonaPages.pl").text,
    resourceName: '$[pool]',
    shell: 'ec-perl'

  step 'deployPersonaCategories',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployPersonaCategories.pl").text,
    resourceName: '$[pool]',
    shell: 'ec-perl'

  step 'deployPersonas',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployPersonas.pl").text,
    resourceName: '$[pool]',
    shell: 'ec-perl'

  step 'deployUsers',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployUsers.pl").text,
    resourceName: '$[pool]',
    shell: 'ec-perl'

  step 'deployGroups',
     command: new File(pluginDir, "dsl/procedures/$procName/steps/deployGroups.pl").text,
     resourceName: '$[pool]',
    shell: 'ec-perl'

  step 'deployReportObjectTypes',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployReportObjectTypes.pl").text,
    resourceName: '$[pool]',
    shell: 'ec-perl'

  step 'deployResources',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployResources.pl").text,
    resourceName: '$[pool]',
    shell: 'ec-perl'

  step 'deployResourcePools',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployResourcePools.pl").text,
    resourceName: '$[pool]',
    shell: 'ec-perl'

  step 'deployProjects',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployProjects.groovy").text,
    resourceName: '$[pool]',
    shell: 'ec-groovy',
    workingDirectory: '$[/myJob/CWD]'

  step 'deployPost',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployPost.pl").text,
    resourceName: '$[pool]',
    shell: 'ec-perl',
    workingDirectory: '$[/myJob/CWD]'

}
