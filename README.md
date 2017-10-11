# Build universal framework
I don't known have you every try to build iOS universal framework with [Jenkins](https://jenkins.io/)  or not. I've try to create a build script to create Universal framework package. It was very hard to find out how it work. After i don't know 1 week or 3 days i finally find out how `xcodebuild` work and when we want's to run with `iPhone device` not simulator we should remove our code.

thanks dear @himanshumahajan04 If found how can keep my script when i use `iPhone device` for test my framework in this [topic](https://gist.github.com/cromandini/1a9c4aeab27ca84f5d79).

So how to build iOS universal framework with shell script and work with `Jenkins` . Let do this guys  🏃

> `Note` :  This script give you iOS universal framework Work with any iOS devices, except `iPhone 5 simulator`. It works in iPhone 5 and iPhone 5s device.

# Add variable to project file
Go to your project and from `TARGETS` select your project and click on `Build Settings` Tab and like this image click on `(+)` button and in shown menu click on `Add User-Defined Setting` :

![Click on Add User-Defined Setting](http://uupload.ir/files/fyqu__2x-group2.png)

So now add new variable in User-Defined section. like bottom image change variable name to `JENKINS` and click on `Arrow` in left side of variable and for `Debug` mode Enter `NO` value and for `Release` mode enter `YES` value :

![Change variable to JENKINS name](http://uupload.ir/files/qaez__2x-group_2.png)

So very thinks seems to be simple. Let go to see Script and Modify it.

# Build-Script 

We have some variables in Build-Script let see them and of corse should change them.

 **Project Name :**
 
 In this variable should enter your project name or your target name
 
``` ruby
TARGET_NAME="MY PROJECT NAME"
```
 **Configuration :**
 
 Determine your `configuration` is `Debug` or `Release` :
``` ruby
CONFIGURATION="Release"
```
**Universal framework path :**

Determine you want to get universal framework was copy where :
``` ruby
UNIVERSAL_OUTPUTFOLDER="${BUILD_ROOT}/${CONFIGURATION}-universal"
```

> `Note` :  Universal build automatic was copied to root project path with this code :
>``` ruby
>cp -rf "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework" "${PROJECT_DIR}"
>```
# Add script file to Project

Link bottom image click on (+) button and when menu was shown click on `New Run Script Phase`.
So you see create new section `Run Script` enter this code here :

``` ruby
$SRCROOT/build-script.sh
```

This code get shell file from you `root project path` and run this code for `debugging` mode if you want to run sample project with your framework project.

![script in project](http://uupload.ir/files/v74i__2x-group_3.png)

Now put `build-script file beside of your project` and run this shell with `Terminal` or `Jenkins`
