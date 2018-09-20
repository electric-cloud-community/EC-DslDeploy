import groovy.transform.BaseScript
import com.electriccloud.commander.dsl.util.BaseProject

//noinspection GroovyUnusedAssignment
@BaseScript BaseProject baseScript

// Variables available for use in DSL code
def projectName = '$[projName]'
def projectDir = '$[projDir]'

def pipeNbr
def relNbr
def envNbr
def svrNbr
def appNbr
def reportNbr
def dashNbr
def procNbr

project projectName, {
  loadProject(projectDir, projectName)
  loadProjectProperties(projectDir, projectName)
  procNbr = loadProcedures(projectDir, projectName)
  property "deployedBy", value: "$[/myProject/projectName]"
  property "deployedWhen", value: "$[/timestamp YYYY-MM-DD hh:mm:ss]"
}

def summaryStr="Created:"
summaryStr += $procNbr? "\n$procNbr procedures" : ""
//summaryStr += $Nbr? "\n$Nbr " : ""
//summaryStr += $Nbr? "\n$Nbr " : ""
//summaryStr += $Nbr? "\n$Nbr " : ""

setProperty(propertyName: "summary", value: summaryStr)
