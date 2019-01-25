//
//  RCTAgoraSignal.m
//  RCTAgoraSignal
//
//  Created by Tauy on 2019/1/25.
//  Copyright © 2019 ylibs. All rights reserved.
//

#import "RCTAgoraSignal.h"
#import <React/RCTEventDispatcher.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import <React/RCTView.h>
#import <AgoraSigKit/AgoraSigKit.h>


@interface RCTAgoraSignal ()
@property (strong, nonatomic) AgoraAPI *agoraApi;
@end

@implementation RCTAgoraSignal

RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;


// todo destroy

//导出常量
- (NSDictionary *)constantsToExport {
    return @{};
}

- (void)sendEvent:(NSDictionary *)params {
    [_bridge.eventDispatcher sendDeviceEventWithName:@"agoraSignaling" body:params];
    
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

/**
 *  初始化AgoraSigKit
 *
 *  @param appid
 *  @return 0 when executed successfully. return negative value if failed.
 */
RCT_EXPORT_METHOD(init:(NSString *)AppId) {
    // 赋值appid
    if(AppId == nil) return;
    _appid = AppId;
    _agoraApi = [AgoraAPI getInstanceWithoutMedia: AppId];
    [self callBackSendMsgToJS];
}

// 登录
RCT_EXPORT_METHOD(login: (NSString *)account) {
    [_agoraApi login2: _appid account:account token: @"_no_need_token" uid:0  deviceID: @""  retry_time_in_s:5  retry_count:1];
}

// 登出
RCT_EXPORT_METHOD(logout) {
    [_agoraApi logout];
}

// 加入频道
RCT_EXPORT_METHOD(channelJoin: (NSString *)roomId) {
    [_agoraApi channelJoin: roomId];
}

// 发送单个消息
RCT_EXPORT_METHOD(sendSignalMsg: (NSString *)channelName msg: (NSString *) msg) {
    [_agoraApi messageInstantSend: channelName uid:0 msg:msg msgID: @""];
}

// 发送频道消息
RCT_EXPORT_METHOD(sendChannelMsg: (NSString *)channelName msg: (NSString *) msg) {
    [_agoraApi messageChannelSend: channelName msg:msg msgID: @""];
}

// channel leave
RCT_EXPORT_METHOD(channelLeave: (NSString *)channelId) {
    [_agoraApi channelLeave: channelId];
}

// query user status
RCT_EXPORT_METHOD(queryUserStatus: (NSString *)account) {
    [_agoraApi queryUserStatus: account];
}

// channel query user nun
RCT_EXPORT_METHOD(channelQueryUserNum: (NSString *)channelId) {
    [_agoraApi channelQueryUserNum: channelId];
}

// accept join channnel
RCT_EXPORT_METHOD(channelInviteAccept: (NSString *)channelId account: (NSString *) account extra:  (NSString *) extra) {
    [_agoraApi channelInviteAccept:channelId account:account uid:0 extra:extra];
}

// refuse join channnel
RCT_EXPORT_METHOD(channelInviteRefuse: (NSString *)channelId account: (NSString *) account extra:  (NSString *) extra) {
    [_agoraApi channelInviteRefuse:channelId account:account uid:0 extra:extra];
}

// invite someone join channnel
RCT_EXPORT_METHOD(channelInviteUser2: (NSString *)channelId account: (NSString *) account extra:  (NSString *) extra) {
    [_agoraApi channelInviteUser2:channelId account:account extra:extra];
}

// 结束呼叫
RCT_EXPORT_METHOD(channelInviteEnd: (NSString *)channelId account: (NSString *) account uid: (uint32_t) uid) {
    [_agoraApi channelInviteEnd:channelId account:account uid:0];
}


//回调函数

/***
 _agoraApi.(^onReconnecting)(uint32_t nretry) ;
 _agoraApi.(^onReconnected)(int fd) ;
 _agoraApi.(^onLoginSuccess)(uint32_t uid,int fd) ;
 _agoraApi.(^onLogout)(AgoraEcode ecode) ;
 _agoraApi.(^onLoginFailed)(AgoraEcode ecode) ;
 _agoraApi.(^onChannelJoined)(NSString* channelID) ;
 _agoraApi.(^onChannelJoinFailed)(NSString* channelID,AgoraEcode ecode) ;
 _agoraApi.(^onChannelLeaved)(NSString* channelID,AgoraEcode ecode) ;
 _agoraApi.(^onChannelUserJoined)(NSString* account,uint32_t uid) ;
 _agoraApi.(^onChannelUserLeaved)(NSString* account,uint32_t uid) ;
 _agoraApi.(^onChannelUserList)(NSMutableArray* accounts, NSMutableArray* uids);
 _agoraApi.(^onChannelQueryUserNumResult)(NSString* channelID,AgoraEcode ecode,int num) ;
 _agoraApi.(^onChannelQueryUserIsIn)(NSString* channelID,NSString* account,int isIn) ;
 _agoraApi.(^onChannelAttrUpdated)(NSString* channelID,NSString* name,NSString* value,NSString* type) ;
 _agoraApi.(^onInviteReceived)(NSString* channelID,NSString* account,uint32_t uid,NSString* extra) ;
 _agoraApi.(^onInviteReceivedByPeer)(NSString* channelID,NSString* account,uint32_t uid) ;
 _agoraApi.(^onInviteAcceptedByPeer)(NSString* channelID,NSString* account,uint32_t uid,NSString* extra) ;
 _agoraApi.(^onInviteRefusedByPeer)(NSString* channelID,NSString* account,uint32_t uid,NSString* extra) ;
 _agoraApi.(^onInviteFailed)(NSString* channelID,NSString* account,uint32_t uid,AgoraEcode ecode,NSString* extra) ;
 _agoraApi.(^onInviteEndByPeer)(NSString* channelID,NSString* account,uint32_t uid,NSString* extra) ;
 _agoraApi.(^onInviteEndByMyself)(NSString* channelID,NSString* account,uint32_t uid) ;
 _agoraApi.(^onInviteMsg)(NSString* channelID,NSString* account,uint32_t uid,NSString* msgType,NSString* msgData,NSString* extra) ;
 _agoraApi.(^onMessageSendError)(NSString* messageID,AgoraEcode ecode) ;
 _agoraApi.(^onMessageSendProgress)(NSString* account,NSString* messageID,NSString* type,NSString* info) ;
 _agoraApi.(^onMessageSendSuccess)(NSString* messageID) ;
 _agoraApi.(^onMessageAppReceived)(NSString* msg) ;
 _agoraApi.(^onMessageInstantReceive)(NSString* account,uint32_t uid,NSString* msg) ;
 _agoraApi.(^onMessageChannelReceive)(NSString* channelID,NSString* account,uint32_t uid,NSString* msg) ;
 _agoraApi.(^onLog)(NSString* txt) ;
 _agoraApi.(^onInvokeRet)(NSString* callID,NSString* err,NSString* resp) ;
 _agoraApi.(^onMsg)(NSString* from,NSString* t,NSString* msg) ;
 _agoraApi.(^onUserAttrResult)(NSString* account,NSString* name,NSString* value) ;
 _agoraApi.(^onUserAttrAllResult)(NSString* account,NSString* value) ;
 _agoraApi.(^onError)(NSString* name,AgoraEcode ecode,NSString* desc) ;
 _agoraApi.(^onQueryUserStatusResult)(NSString* name,NSString* status) ;
 _agoraApi.(^onDbg)(NSString* a,NSString* b) ;
 _agoraApi.(^onBCCall_result)(NSString* reason,NSString* json_ret,NSString* callID) ;
 
 */
- (void) callBackSendMsgToJS {
    __weak typeof(self) weakSelf = self;
    
    _agoraApi.onReconnecting = ^(uint32_t nretry) {
        
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onReconnecting";
        
        params[@"nretry"] = [NSString stringWithFormat:@"%d", nretry];
        
        [weakSelf sendEvent:params];
        
    };
    
    _agoraApi.onReconnected = ^(int fd) {
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onReconnected";
        
        params[@"fd"] = [NSString stringWithFormat:@"%d", fd];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onLoginSuccess = ^(uint32_t uid,int fd){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onLoginSuccess";
        
        params[@"uid"] = [NSString stringWithFormat:@"%d", uid];
        params[@"fd"] = [NSString stringWithFormat:@"%d", fd];
        
        [weakSelf sendEvent:params];
        
    } ;
    
    _agoraApi.onLogout = ^(AgoraEcode ecode){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onLogout";
        
        params[@"code"] = [NSString stringWithFormat:@"%ld", ecode];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onLoginFailed = ^(AgoraEcode ecode){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onLoginFailed";
        
        params[@"ecode"] = [NSString stringWithFormat:@"%ld", ecode];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onChannelJoined = ^(NSString* channelID){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onChannelJoined";
        
        params[@"channelID"] = [NSString stringWithFormat:@"%@", channelID];
        
        [weakSelf sendEvent:params];
    } ;
    
    _agoraApi.onChannelJoinFailed = ^(NSString* channelID,AgoraEcode ecode) {
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onChannelJoinFailed";
        
        params[@"channelID"] = [NSString stringWithFormat:@"%@", channelID];
        params[@"ecode"] = [NSString stringWithFormat:@"%ld", ecode];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onChannelLeaved = ^(NSString* channelID,AgoraEcode ecode) {
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onChannelLeaved";
        
        params[@"channelID"] = [NSString stringWithFormat:@"%@", channelID];
        params[@"ecode"] = [NSString stringWithFormat:@"%ld", ecode];
        
        [weakSelf sendEvent:params];
    } ;
    
    _agoraApi.onChannelUserJoined = ^(NSString* account,uint32_t uid){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onChannelUserJoined";
        
        params[@"account"] = [NSString stringWithFormat:@"%@", account];
        params[@"uid"] = [NSString stringWithFormat:@"%d", uid];
        
        [weakSelf sendEvent:params];
    } ;
    
    _agoraApi.onChannelUserLeaved=^(NSString* account,uint32_t uid){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onChannelUserLeaved";
        
        params[@"account"] = [NSString stringWithFormat:@"%@", account];
        params[@"uid"] = [NSString stringWithFormat:@"%d", uid];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onChannelUserList=^(NSMutableArray* accounts, NSMutableArray* uids){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onChannelUserList";
        
        params[@"accounts"] = [NSString stringWithFormat:@"%@", accounts];
        params[@"uids"] = [NSString stringWithFormat:@"%@", uids];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onChannelQueryUserNumResult=^(NSString* channelID,AgoraEcode ecode,int num){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onChannelQueryUserNumResult";
        
        params[@"channelID"] = [NSString stringWithFormat:@"%@", channelID];
        params[@"ecode"] = [NSString stringWithFormat:@"%ld", ecode];
        params[@"num"] = [NSString stringWithFormat:@"%d", num];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onChannelQueryUserIsIn=^(NSString* channelID,NSString* account,int isIn){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onChannelQueryUserIsIn";
        
        params[@"channelID"] = [NSString stringWithFormat:@"%@", channelID];
        params[@"account"] = [NSString stringWithFormat:@"%@", account];
        params[@"isIn"] = [NSString stringWithFormat:@"%d", isIn];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onChannelAttrUpdated=^(NSString* channelID,NSString* name,NSString* value,NSString* type){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onChannelAttrUpdated";
        
        params[@"channelID"] = [NSString stringWithFormat:@"%@", channelID];
        params[@"name"] = [NSString stringWithFormat:@"%@", name];
        params[@"value"] = [NSString stringWithFormat:@"%@", value];
        params[@"type1"] = [NSString stringWithFormat:@"%@", type];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onInviteReceived=^(NSString* channelID,NSString* account,uint32_t uid,NSString* extra){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onInviteReceived";
        
        params[@"channelID"] = [NSString stringWithFormat:@"%@", channelID];
        params[@"account"] = [NSString stringWithFormat:@"%@", account];
        params[@"uid"] = [NSString stringWithFormat:@"%d", uid];
        params[@"extra"] = [NSString stringWithFormat:@"%@", extra];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onInviteReceivedByPeer=^(NSString* channelID,NSString* account,uint32_t uid){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onInviteReceivedByPeer";
        
        params[@"channelID"] = [NSString stringWithFormat:@"%@", channelID];
        params[@"account"] = [NSString stringWithFormat:@"%@", account];
        params[@"uid"] = [NSString stringWithFormat:@"%d", uid];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onInviteAcceptedByPeer=^(NSString* channelID,NSString* account,uint32_t uid,NSString* extra){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onInviteAcceptedByPeer";
        
        params[@"channelID"] = [NSString stringWithFormat:@"%@", channelID];
        params[@"account"] = [NSString stringWithFormat:@"%@", account];
        params[@"uid"] = [NSString stringWithFormat:@"%d", uid];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onInviteRefusedByPeer=^(NSString* channelID,NSString* account,uint32_t uid,NSString* extra){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onInviteRefusedByPeer";
        
        params[@"channelID"] = [NSString stringWithFormat:@"%@", channelID];
        params[@"account"] = [NSString stringWithFormat:@"%@", account];
        params[@"uid"] = [NSString stringWithFormat:@"%d", uid];
        params[@"extra"] = [NSString stringWithFormat:@"%@", extra];
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onInviteFailed=^(NSString* channelID,NSString* account,uint32_t uid,AgoraEcode ecode,NSString* extra){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onInviteFailed";
        
        params[@"channelID"] = [NSString stringWithFormat:@"%@", channelID];
        params[@"account"] = [NSString stringWithFormat:@"%@", account];
        params[@"uid"] = [NSString stringWithFormat:@"%d", uid];
        params[@"ecode"] = [NSString stringWithFormat:@"%ld", ecode];
        params[@"extra"] = [NSString stringWithFormat:@"%@", extra];
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onInviteEndByPeer=^(NSString* channelID,NSString* account,uint32_t uid,NSString* extra){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onInviteEndByPeer";
        
        params[@"channelID"] = [NSString stringWithFormat:@"%@", channelID];
        params[@"account"] = [NSString stringWithFormat:@"%@", account];
        params[@"uid"] = [NSString stringWithFormat:@"%d", uid];
        params[@"extra"] = [NSString stringWithFormat:@"%@", extra];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onInviteEndByMyself=^(NSString* channelID,NSString* account,uint32_t uid){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onInviteEndByMyself";
        
        params[@"channelID"] = [NSString stringWithFormat:@"%@", channelID];
        params[@"account"] = [NSString stringWithFormat:@"%@", account];
        params[@"uid"] = [NSString stringWithFormat:@"%d", uid];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onInviteMsg=^(NSString* channelID,NSString* account,uint32_t uid,NSString* msgType,NSString* msgData,NSString* extra){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onInviteMsg";
        params[@"channelID"] = [NSString stringWithFormat:@"%@", channelID];
        params[@"account"] = [NSString stringWithFormat:@"%@", account];
        params[@"uid"] = [NSString stringWithFormat:@"%d", uid];
        
        params[@"msgType"] = [NSString stringWithFormat:@"%@", msgType];
        params[@"msgData"] = [NSString stringWithFormat:@"%@", msgData];
        
        params[@"extra"] = [NSString stringWithFormat:@"%@", extra];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onMessageSendError=^(NSString* messageID,AgoraEcode ecode){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onMessageSendError";
        
        params[@"messageID"] = [NSString stringWithFormat:@"%@", messageID];
        params[@"ecode"] = [NSString stringWithFormat:@"%ld", ecode];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onMessageSendProgress=^(NSString* account,NSString* messageID,NSString* type,NSString* info){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onMessageSendProgress";
        
        params[@"messageID"] = [NSString stringWithFormat:@"%@", messageID];
        params[@"account"] = [NSString stringWithFormat:@"%@", account];
        params[@"type"] = [NSString stringWithFormat:@"%@", type];
        params[@"info"] = [NSString stringWithFormat:@"%@", info];
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onMessageSendSuccess=^(NSString* messageID){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onMessageSendSuccess";
        
        params[@"messageID"] = [NSString stringWithFormat:@"%@", messageID];
        
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onMessageAppReceived=^(NSString* msg){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onMessageAppReceived";
        
        params[@"msg"] = [NSString stringWithFormat:@"%@", msg];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onMessageInstantReceive=^(NSString* account,uint32_t uid,NSString* msg){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onMessageInstantReceive";
        
        params[@"account"] = [NSString stringWithFormat:@"%@", account];
        params[@"uid"] = [NSString stringWithFormat:@"%d", uid];
        params[@"msg"] = [NSString stringWithFormat:@"%@", msg];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onMessageChannelReceive=^(NSString* channelID,NSString* account,uint32_t uid,NSString* msg){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onMessageChannelReceive";
        
        params[@"channelID"] = [NSString stringWithFormat:@"%@", channelID];
        params[@"account"] = [NSString stringWithFormat:@"%@", account];
        params[@"uid"] = [NSString stringWithFormat:@"%d", uid];
        params[@"msg"] = [NSString stringWithFormat:@"%@", msg];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onLog=^(NSString* txt){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onLog";
        
        params[@"txt"] = [NSString stringWithFormat:@"%@", txt];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onInvokeRet=^(NSString* callID,NSString* err,NSString* resp){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onInvokeRet";
        
        params[@"callID"] = [NSString stringWithFormat:@"%@", callID];
        params[@"err"] = [NSString stringWithFormat:@"%@", err];
        params[@"resp"] = [NSString stringWithFormat:@"%@", resp];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onMsg=^(NSString* from,NSString* t,NSString* msg){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onMsg";
        
        params[@"from"] = [NSString stringWithFormat:@"%@", from];
        params[@"t"] = [NSString stringWithFormat:@"%@", t];
        params[@"msg"] = [NSString stringWithFormat:@"%@", msg];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onUserAttrResult=^(NSString* account,NSString* name,NSString* value){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onUserAttrResult";
        
        params[@"account"] = [NSString stringWithFormat:@"%@", account];
        params[@"name"] = [NSString stringWithFormat:@"%@", name];
        params[@"value"] = [NSString stringWithFormat:@"%@", value];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onUserAttrAllResult=^(NSString* account,NSString* value){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onUserAttrAllResult";
        
        params[@"account"] = [NSString stringWithFormat:@"%@", account];
        params[@"value"] = [NSString stringWithFormat:@"%@", value];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onError=^(NSString* name,AgoraEcode ecode,NSString* desc){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onError";
        
        params[@"name"] = [NSString stringWithFormat:@"%@", name];
        params[@"ecode"] = [NSString stringWithFormat:@"%ld", ecode];
        params[@"desc"] = [NSString stringWithFormat:@"%@", desc];
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onQueryUserStatusResult=^(NSString* name,NSString* status){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onQueryUserStatusResult";
        params[@"name"] = [NSString stringWithFormat:@"%@", name];
        params[@"status"] = [NSString stringWithFormat:@"%@", status];
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onDbg=^(NSString* a,NSString* b){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onDbg";
        
        params[@"channelID"] = [NSString stringWithFormat:@"%@", a];
        params[@"account"] = [NSString stringWithFormat:@"%@", b];
        
        
        [weakSelf sendEvent:params];
    };
    
    _agoraApi.onBCCall_result=^(NSString* reason,NSString* json_ret,NSString* callID){
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"type"] = @"onBCCall_result";
        
        params[@"reason"] = [NSString stringWithFormat:@"%@", reason];
        params[@"json_ret"] = [NSString stringWithFormat:@"%@", json_ret];
        params[@"callID"] = [NSString stringWithFormat:@"%@", callID];
        
        [weakSelf sendEvent:params];
        
    };
}


@end
