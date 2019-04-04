/*
  deployResources.groovy - Loop through the resources and invoke each individually

  Copyright 2019 Electric-Cloud Inc.

  CHANGELOG
  ----------------------------------------------------------------------------
  2019-03-27  lrochette  Initial Version
  2019-04-03  lrochette  Convertig to deployObject
*/

import groovy.io.FileType
import groovy.transform.BaseScript
import com.electriccloud.commander.dsl.util.BaseObject

//noinspection GroovyUnusedAssignment
@BaseScript BaseObject baseScript

File dir=new File('$[directory]', "resources")

if (dir.exists()) {
  def counter=loadObjects('resource', '$[directory]', '/resources')
  def nb=counter['resource']
  setProperty(propertyName:"summary", value:" $nb resources")
} else {
  setProperty(propertyName:"summary", value:" No resources")
}
