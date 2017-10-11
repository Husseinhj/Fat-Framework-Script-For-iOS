# Build universal framework
I don't known have you every try to build iOS universal framework with [Jenkins](https://jenkins.io/)  or not. I've try to create a build script to create Universal framework package. It was very hard to find out how it work. After i don't know 1 week or 3 days i finally find out how `xcodebuild` work and when we want's to run with `iPhone device` not simulator we should remove our code.

thanks dear @himanshumahajan04 If found how can keep my script when i use `iPhone device` for test my framework in this [topic](https://gist.github.com/cromandini/1a9c4aeab27ca84f5d79).

So how to build iOS universal framework with shell script and work with `Jenkins` . Let do this guys  🏃

# Add variable to project file
Go to your project and from `TARGETS` select your project and click on `Build Settings` Tab and like this image click on `(+)` button and in shown menu click on `Add User-Defined Setting` :

![Click on Add User-Defined Setting](http://uupload.ir/files/fyqu__2x-group2.png)

So now add new variable in User-Defined section. like bottom image change variable name to `JENKINS` and click on `Arrow` in left side of variable and for `Debug` mode Enter `NO` value and for `Release` mode enter `YES` value :

![Change variable to JENKINS name](http://uupload.ir/files/qaez__2x-group_2.png)

So very thinks seems to be simple. Let go to see Script and Modify it.

# Build-Script 



