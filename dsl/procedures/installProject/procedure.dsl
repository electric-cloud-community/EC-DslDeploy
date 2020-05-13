import java.io.File

def procName = 'installProject'

def dslShell = 'ectool --timeout $[/server/@PLUGIN_KEY@/timeout] evalDsl --dslFile {0}.groovy --serverLibraryPath "$[/server/settings/pluginsDirectory]/$[/myProject/projectName]/dsl" $[additionalDslArguments]'

procedure procName, {

    step 'setAdditionalDslArguments',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/setAdditionalDslArguments.pl").text,
    shell: 'ec-perl',
    postProcessor: 'postp'

    //evalDsl the main.groovy if it exists
    step 'deployProject',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployProject.pl").text,
    shell: 'ec-perl'

    step 'deployProcedures',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployProcedures.pl").text,
    shell: 'ec-perl'

    step 'deployResourceTemplates',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployResourceTemplates.pl").text,
    shell: 'ec-perl'

    step 'deployWorkflowDefinitions',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployWorkflowDefinitions.pl").text,
    shell: 'ec-perl'

    step 'deployEnvironmentTemplates',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployEnvironmentTemplates.pl").text,
    shell: 'ec-perl'

    step 'deployEnvironments',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployEnvironments.pl").text,
    shell: 'ec-perl'

    step 'deployComponentTemplates',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployComponentTemplates.pl").text,
    shell: 'ec-perl'

    step 'deployApplications',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployApplications.pl").text,
    shell: 'ec-perl'

    step 'deployServices',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployServices.pl").text,
    shell: 'ec-perl'

    step 'deployPipelines',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployPipelines.pl").text,
    shell: 'ec-perl'

    step 'deployReleases',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployReleases.pl").text,
    shell: 'ec-perl'

    step 'deploySchedules',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deploySchedules.pl").text,
    shell: 'ec-perl'

    step 'deployCatalogs',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployCatalogs.pl").text,
    shell: 'ec-perl'

    step 'deployReports',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployReports.pl").text,
    shell: 'ec-perl'

    step 'deployDashboards',
    command: new File(pluginDir, "dsl/procedures/$procName/steps/deployDashboards.pl").text,
    shell: 'ec-perl'

  // Do not Display in the property picker
  property 'standardStepPicker', value: false
}
