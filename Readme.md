
# Docker Spring Demo App

This Spring Boot application help you understand how we reduce the size of image of applications while deploying on Docker using jdeps and jlink.

# jdeps
- jdeps is responsible for analysing a JAR, with its dependencies, and identifying the parts of the JVM needed to run the application.
- It can out put this to a text file, which can be used by jlink.

### Sample Commands
- jdeps  _applicationname.jar_  or jdeps -verbose:package  _applicationname.jar_ 

##### *displays package level dependencies*

- jdeps -verbose:class  _applicationname.jar_ 

##### *displays class level dependencies*
- jdeps -profile  _applicationname.jar_ 

##### *displays the profile containing the package*
- jdeps -dotoutput . -verbose  _applicationname.jar_ 

##### *write class and package level dependencies into file*
- jdeps -s  _applicationname.jar_  or jdeps  -summary  _applicationname.jar_

##### *displays dependencies summary only*

# jlink
- jlink takes a list of JVM modules, and builds a custom JVM with only those parts present.
- Depending upon our application, this can cut out massive parts of the runtime, reducing our overall Docker image size.

### Docker file is created as:
- First download java into the system
- set JAVA_HOME path
- set PATH="$PATH:$JAVA_HOME/bin"
- copy jar into target machine
- run jdeps command to identify the dependencies and write into file
- run jlink command to create custom jre with those modules that are written by jdeps command
- set JAVA_HOME path to the custom jre
- set PATH="$PATH:$JAVA_HOME/bin"
- expose spring boot app into a particular port number and give entry point to run the application.

## Build docker image
docker build -f Dockerfile -t *applicationname.jar*

## Run docker image
docker run -p 8085:8085 *applicationname.jar*
