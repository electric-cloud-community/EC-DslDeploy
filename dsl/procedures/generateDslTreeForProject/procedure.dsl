/*
Copyright 2019 CloudBees Inc.

Author: L. Rochette

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

History:
------------------------------------------------------------------------------
2019-07-05 lrochette    Issue #45: New functio to export a DSL tree
*/
import java.io.File

def procName="generateDslTreeForProject"

procedure procName,
  description: "generate a DSL tree to be later inported with installDsl",
  jobNameTemplate: '$[/myProject/scripts/jobTemplate]',
{
    formalParameter 'projName',
      label: "Project Name",
      description:  "the of the project for which to generateDsl",
      type: 'project'

    formalParameter 'pathname',
      label: "Export directory",
      documentation: 'Directory where to saved the DSL files.',
      type: 'entry',
      defaultValue: '/tmp/DSL',
      required: 1

    formalParameter 'resName',
      label: 'Resource Name',
      documentation: 'Resource on which to export the project.',
      type: 'entry',
      defaultValue: 'local',
      required: '1'

    step 'saveProject',
      description: "step to save a project and all its sub-objects",
      command: new File(pluginDir, "dsl/procedures/$procName/steps/saveProject.pl").text,
      shell: 'ec-perl'
}     // procedure
