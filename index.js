import {
    NativeModules,
    findNodeHandle,
    NativeAppEventEmitter
}
    from 'react-native';

const {
    AgoraSignal
} = NativeModules

export
default {...AgoraSignal,
init(appId = null) {
    this.listener && this.listener.remove();
    AgoraSignal.init(appId);
},
login(userId) {
    AgoraSignal.login(userId);
},
// logout
logout() {
    AgoraSignal.logout();
},
// channel join
channelJoin(channelID) {
    AgoraSignal.channelJoin(channelID);
},
// send instant msg
sendSignalMsg(account, msg) {
    AgoraSignal.sendSignalMsg(account, msg);
},
// send channel msg
sendChannelMsg(channelID, msg) {
    AgoraSignal.sendChannelMsg(channelID, msg);
},
invoke(name, req, callID){
    AgoraSignal.invoke(name, req, callID);
},
channelLeave(channelID) {
    AgoraSignal.channelLeave(channelID);
},
queryUserStatus(account) {
    AgoraSignal.queryUserStatus(account);
},
channelQueryUserNum(channelID) {
    AgoraSignal.channelQueryUserNum(channelID);
},
channelInviteUser2(channelID, account, extras) {
    AgoraSignal.channelInviteUser2(channelID, account, extras);
},
channelInviteAccept(channelID, account, extras) {
    AgoraSignal.channelInviteAccept(channelID, account, extras);
},
channelInviteRefuse(channelID, account, extras) {
    AgoraSignal.channelInviteRefuse(channelID, account, extras);
},
channelInviteEnd(channelID, account) {
    AgoraSignal.channelInviteEnd(channelID, account, 0);
},
/* 回调类型如下，具体使用参考
 　android: https://docs.agora.io/cn/Signaling/signal_android?platform=Android#oninvitereceived-android
 ["onLogout","onLoginSuccess", "onLoginFailed", "onChannelJoined", "onChannelJoinFailed", "onChannelLeaved", "onChannelUserList","onChannelUserJoined","onChannelUserLeaved","onQueryUserStatusResult","onChannelQueryUserNumResult",
 "onReceiveMessage","onMessageChannelReceive", "onMessageSendSuccess", "onMessageSendError", "onInviteReceived", "onInviteReceivedByPeer","onInviteAcceptedByPeer", "onInviteRefusedByPeer", "onInviteFailed", "onInviteEndByPeer","onInviteEndByMyself", "onInviteMsg", "onError"
 ]
 */
eventEmitter(fnConf) {
    //there are no `removeListener` for NativeAppEventEmitter & DeviceEventEmitter
    this.listener && this.listener.remove();
    this.listener = NativeAppEventEmitter.addListener('agoraSignaling', event =>{
            fnConf[event['type']] && fnConf[event['type']](event);
});
},
removeEmitter() {
    this.listener && this.listener.remove();
    this.listener = null;
}
};