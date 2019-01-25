# react-native-signal-agora

#### 介绍
声网信令

## 安装使用

 `npm install --save react-native-signal-agora`

Then link with:

 `react-native link react-native-signal-agora`

 #### iOS

TARGETS->Build Phases-> Link Binary With Libaries中点击“+”按钮，选择

    AgoraSigKit.framework

TARGETS->Build Phases-> Link Binary With Libaries中点击“+”按钮，在弹出的窗口中点击“Add Other”按钮，选择
```
node_modules/react-native-signal-agora/ios/RCTAgoraSignal/Frameworks/AgoraSignalSDK/AgoraSigKit.framework

```
TARGETS->Build Settings->Search Paths->Framework Search Paths添加
```
"$(SRCROOT)/../node_modules/react-native-signal-agora/ios/RCTAgoraSignal/Frameworks/AgoraSignalSDK"
```
TARGETS->Build Settings->Search Paths->Library Search Paths添加
```
"$(SRCROOT)/../node_modules/react-native-signal-agora/ios/RCTAgoraSignal/Frameworks/AgoraSignalSDK"

#### Android
link is ok

