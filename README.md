![Central Times Header](https://www.centraltimes.org/wp-content/uploads/2021/05/CentralTimesWebsiteMastheadred.png)

# Central Times App

<img src="https://user-images.githubusercontent.com/28021387/135775852-91b71152-3fa8-431d-8c0c-32e917b62641.png" width="200" align="right"/>
This is the repository of the official app for the award-winning Central Times high school newspaper.

Central Times utilizes
the [Wordpress website's](https://www.centraltimes.org/) [REST API](https://www.centraltimes.org/wp-json/)
as a backend, which includes [some modifications](https://github.com/CentralTimes/wp_ct_rest_api) to
provide support for [SNO FLEX](https://snosites.com/benefits/)
, [NextGEN Gallery](https://wordpress.org/plugins/nextgen-gallery/), and other custom site and app
configuration metadata.

# Installation For Android Builds

Prerequisites:
1. Flutter SDK for Windows, MacOS, or Linux https://docs.flutter.dev/get-started/install 
2. Android Studio https://developer.android.com/studio Make sure to install the Android Simulators according to the flutter SDK.
3. VSCode https://code.visualstudio.com/


Building:
1. Clone the repository.
2. Open a command prompt or terminal.
3. Change directory to the repository's main folder.
```
cd centraltimes_app
```
4. 
```
flutter pub get
```
5. Open the folder in VSCode
```
code .
```
6. Click **"Run" -> "Start Debugging"**
7. Select the test device that you created after installing android studio.


# Installation for iOS Builds

Prerequisites:
1. Flutter SDK for MacOS only https://docs.flutter.dev/get-started/install/macos
2. VSCode https://code.visualstudio.com/
3. XCode https://apps.apple.com/us/app/xcode/id497799835?mt=12

Building:
1. Clone the repository.
2. Open the terminal.
3. Change directory to the ios folder in the repository's main folder.
```
cd centraltimes_app/ios/
```
4. 
```
flutter pub get
```
5. 
```
pod update
```
6. Open Runner.xcworkspace
7. Make sure you are logged in with an eligable Apple Devloper account that has access to signing apps.
8. Make sure you have an iOS device with 12.0 or greater firmware installed and plugged in to your computer with a USB cable.
9. Select that device at the top bar next to **"Runner"** and trust the computer on the iOS device.
10. **Alternatively** you can use one of the iOS simulators but it is not garunteed that it will work.
11. In the same bar as the apple menu select **"Product" -> "Run"** or press ⌘R.

# Issues

Common issues will be posted in an FAQ page on the Wiki.
If your issue is **not** on the FAQ please submit a filled out issue report.
