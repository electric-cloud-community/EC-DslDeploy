/* ###########################################################################
#
#  BaseObject: extension of BasePProject to allow the evaluation of any object
#
#  Author: L.Rochette
#
#  Copyright 2017-2019 Electric-Cloud Inc.
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
# 2019-04-02 lrochette  Inbitial version
############################################################################ */
package com.electriccloud.commander.dsl.util

import groovy.io.FileType
import groovy.json.JsonOutput
import java.io.File

import org.codehaus.groovy.control.CompilerConfiguration
import com.electriccloud.commander.dsl.DslDelegate
import com.electriccloud.commander.dsl.DslDelegatingScript

abstract class BaseObject extends DslDelegatingScript {

  // return the object.groovy or object.dsl
  //    AKA project.groovy, procedure.dsl, pipeline.groovy, ...
  // Show ignored files to make it easier to debug when a badly named file is
  // skipped
    File getObjectDSLFile(File objDir, String objectType) {
    // println "Checking $objectType in ${objDir.name}"
    File found=null
    objDir.eachFileMatch(FileType.FILES, ~/(?i)^.*\.(groovy|dsl)/) { dslFile ->
      // println "Processing ${dslFile.name}"
      if (dslFile.name ==~ /(?i)${objectType}\.(groovy|dsl)/) {
        if (found) {
          println "Multiple files match the ${objectType}.groovy or ${objectType}.dsl"
          setProperty(propertyName: "outcome", value: "warning")
        }
        found =  dslFile
      }  else {
         println "Ignoring incorrect file  ${dslFile.name} in ${objDir.name}"
         setProperty(propertyName: "outcome", value: "warning")
      }
    }
    return found
  }

  // Generic procedure to load an object in context
  /* ########################################################################
      loadObject: function to load a single DSL file passing the context
                  as a map
      Parameters:
        - dslFile: the absolute path to the DSL file to evaluate.
        - bindingMap: a list of properties to pass dow to evaluate the DSL
                      in context. Typically objectName and objectDir
     ######################################################################## */
  def loadObject(String dslFile, Map bindingMap = [:]) {
    println "Load Object:"
    println "  dslFile: $dslFile"
    println "  map: " + bindingMap.toMapString(100)
    return evalInlineDsl(dslFile, bindingMap)
  }

  /* ########################################################################
      loadObjects: function to load the top directory contains "obkects"
      Parameters:
        - objectType: the type of object like "procedure", "persona", ...
        - dir: the location where "objects" will be found.
        - bindingMap: a list of properties to pass dow to evaluate the DSL
                      in context. Typically objectName and objectDir.
     ######################################################################## */
  def loadObjects(String objectType, String topDir,
                  String objPath = "/", Map bindingMap = [:]) {

    println "Entering loadObjects"
    println "  Type:  $objectType"
    println "  dir  : $topDir"
    println "  path : $objPath"
    println "  map  : " + bindingMap.toMapString(25)
    def counter=0

    // lookking for "objects" direction i.e. "procedures", "personas"
    File dir = new File(topDir, objectType + 's')
    if (dir.exists()) {
      def dlist=[]
      // sort object alphabetically
      dir.eachDir {dlist << it }
      dlist.sort({it.name}).each {
        def objName=it.name
        def objDir=it.absolutePath
        File dslFile=getObjectDSLFile(it, objectType)
        println "Processing $objectType file ${objectType}s/$objName/${dslFile.name}"
        bindingMap[(objectType+"Name")] = objName     //=> procedureName
        bindingMap[(objectType+"Dir")]  = objDir      //=> procedureDir
        def obj=loadObject(dslFile.absolutePath, bindingMap)
        counter ++
      }
    }   // directory for "objects" exists
    return counter
  }     // loadObjects


  // Helper function to load another dsl script and evaluate it in-context
  def evalInlineDsl(String dslFile, Map bindingMap) {
    // println "evalInlineDsl: $dslFile"
    // println "  Map: " + bindingMap
    CompilerConfiguration cc = new CompilerConfiguration();
    cc.setScriptBaseClass(InnerDelegatingScript.class.getName());
    //println "Class loader class name: ${this.scriptClassLoader.class.name}"
    // NMB-27865: Use the same groovy class loader that was used for evaluating
    // the DSL passed to evalDsl.
    GroovyShell sh = new GroovyShell(this.scriptClassLoader, bindingMap? new Binding(bindingMap) : new Binding(), cc);
    DelegatingScript script = (DelegatingScript)sh.parse(new File(dslFile))
    script.setDelegate(this.delegate);
    return script.run();
  }

  /**
   * NMB-27865: Intercept the DslDelegate
   * so it can be set as the delegate on the
   * dsl scripts being evaluated in context
   * of the parent dsl script.
   * Before setting the delegate, also capture
   * the script's class loader before the dslDelegate
   * highjacks the calls. This is needed to get the
   * reference to the groovy class loader that used for
   * evaluating the DSL script passed in to evalDsl.
   */
  private def delegate;
  private def scriptClassLoader;

  public void setDelegate(DslDelegate delegate) {
    this.scriptClassLoader = this.class.classLoader
    this.delegate = delegate;
    super.setDelegate(delegate)
  }

  public def getDelegate(){
    this.delegate
  }
}