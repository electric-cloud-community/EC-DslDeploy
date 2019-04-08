/*
  deployTags.groovy - Loop through the tags and invoke each individually

  Copyright 2019 Electric-Cloud Inc.

  CHANGELOG
  ----------------------------------------------------------------------------
  2019-04-07  lrochette  Initial version
*/

import groovy.io.FileType
import groovy.transform.BaseScript
import com.electriccloud.commander.dsl.util.BaseObject

//noinspection GroovyUnusedAssignment
@BaseScript BaseObject baseScript

$[/myProject/scripts/summaryString]

File dir=new File('$[directory]', "tags")

if (dir.exists()) {
  def counters=loadObjects('tag', '$[directory]', '/tags')
  def nb=counters['tag']
  setProperty(propertyName: "summary", value: summaryString(counters))
} else {
  setProperty(propertyName:"summary", value:"No tags")
}
