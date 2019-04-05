/*
  deployReleases.groovy - Loop through the releases and invoke each individually

  Copyright 2019 Electric-Cloud Inc.

  CHANGELOG
  ----------------------------------------------------------------------------
  2019-04-01  lrochette  Convert to loadObjects
*/
import groovy.transform.BaseScript
import com.electriccloud.commander.dsl.util.BaseObject

//noinspection GroovyUnusedAssignment
@BaseScript BaseObject baseScript

// Variables available for use in DSL code
def projectName = '$[projName]'
def projectDir = '$[projDir]'
def counters

project projectName, {
  counters = loadObjects("release", projectDir, "/projects/$projectName",
    [projectName: projectName, projectDir: projectDir]
  )
}

def relNbr=counters['release']
def summaryStr = relNbr?  "Created $relNbr releases" : "No release"
setProperty(propertyName: "summary", value: summaryStr)
return ""
