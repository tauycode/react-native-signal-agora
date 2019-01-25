package com.ylibs.agiosignal;

import android.support.annotation.Nullable;
import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import io.agora.AgoraAPI;
import io.agora.AgoraAPIOnlySignal;
import io.agora.IAgoraAPI;

import static com.facebook.react.bridge.UiThreadUtil.runOnUiThread;

public class AgoraSignalModule extends ReactContextBaseJavaModule {
    private final String TAG ="logs";
    private boolean stateSingleMode = true; // single mode or channel mode
    private AgoraAPIOnlySignal agoraAPI;
    private static String appId = null;

    public AgoraSignalModule(ReactApplicationContext context) {
        super(context);
    }

    @Override
    public String getName() {
        return "RCTAgoraSignal";
    }

    private void commonEvent(WritableMap map) {
        sendEvent(getReactApplicationContext(), "agoraSignaling", map);
    }

    private void sendEvent(ReactContext reactContext,
                           String eventName,
                           @Nullable WritableMap params) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    // init callback
    @ReactMethod
    public void init(final String appIds) {
        if(appIds == null) return;
        appId = appIds;
        agoraAPI =  AgoraAPIOnlySignal.getInstance(getReactApplicationContext(), appId);
        Callback();
    }

    // login siginal
    @ReactMethod
    public void login(final String userId) {
        if(userId == null || userId.equals("")) return;
        agoraAPI.login2(appId, userId, "_no_need_token", 0, "", 5, 1);
        Callback();
    }

    // loginout siginal
    @ReactMethod
    public void logout() {
        agoraAPI.logout();
    }

    // join channel
    @ReactMethod
    public void channelJoin(final String roomId) {
        if(roomId == null || roomId.equals("")) {
            Log.i(TAG, "roomId is null");
        } else {
            agoraAPI.channelJoin(roomId);
        }
    }


    // send signal message
    @ReactMethod
    public void sendSignalMsg(final String channelName, String msg) {
        if(msg == null || msg.equals("")) {
            Log.i(TAG, "msg is null");
        } else {
            agoraAPI.messageInstantSend(channelName, 0, msg, "");
        }
    }


    // send channel message
    @ReactMethod
    public void sendChannelMsg(final String channelName, String msg) {
        if(msg == null || msg.equals("")) {
            Log.i(TAG, "mg is null");
        } else {
            agoraAPI.messageChannelSend(channelName, msg, "");
        }
    }

    // invoke rpc method
    @ReactMethod
    public void invoke(String name, String req, String callID) {
        agoraAPI.invoke(name, req, callID);
    }

    // leave channel by id
    @ReactMethod
    public void channelLeave(String channelId) {
        if(channelId == null || channelId.equals("")) return;
        agoraAPI.channelLeave(channelId);
    }

    // query user status
    @ReactMethod
    public void queryUserStatus(String account) {
        if(account == null || account.equals("")) return;
        agoraAPI.queryUserStatus(account);
    }

    // query channel user nums
    @ReactMethod
    public void channelQueryUserNum(String channelID) {
        if(channelID == null || channelID.equals("")) return;
        agoraAPI.channelQueryUserNum(channelID);
    }

    // accept join channnel
    @ReactMethod
    public void channelInviteAccept(String channelID, String account, String extras) {
        if(channelID == null) return;
        agoraAPI.channelInviteAccept(channelID, account, 0, extras);
    }

    // reject join channnel
    @ReactMethod
    public void channelInviteRefuse(String channelID, String account, String extras) {
        if(channelID == null) return;
        agoraAPI.channelInviteRefuse(channelID, account, 0, extras);
    }


    // invite someone join channnel
    @ReactMethod
    public void channelInviteUser2(String channelID, String account, String extras) {
        if(channelID == null) return;
        agoraAPI.channelInviteUser2(channelID, account, extras);
    }

    // 结束呼叫
    @ReactMethod
    public void channelInviteEnd(String channelID, String account, int uid) {
        if(channelID == null) return;
        agoraAPI.channelInviteEnd(channelID, account, uid);
    }



    // login callback
    private void Callback() {
        try {

            if (agoraAPI == null) {
                return;
            }

            agoraAPI.callbackSet(new AgoraAPI.CallBack() {
                @Override
                public void onLoginSuccess(final int i, final int i1) {
                    Log.i(TAG, "onLoginSuccess " + i + "  " + i1);
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onLoginSuccess");
                            map.putInt("uid", i);
                            map.putInt("fid", i1);
                            commonEvent(map);
                        }
                    });
                }

                @Override
                public void onLoginFailed(final int i) {
                    Log.i(TAG, "onLoginFailed " + i);
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onLoginFailed");
                            map.putInt("ecode", i);
                            commonEvent(map);

                        }
                    });
                }

                @Override
                public void onChannelJoined(final String channelID) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onChannelJoined");
                            map.putString("channelID", channelID);
                            commonEvent(map);
                        }
                    });

                }

                @Override
                public void onChannelJoinFailed(final String channelID, final int ecode) {
                    super.onChannelJoinFailed(channelID, ecode);
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onChannelJoinFailed");
                            map.putString("channelID", channelID);
                            map.putInt("ecode", ecode);
                            commonEvent(map);
                        }
                    });
                }

                // leave channel success
                @Override
                public void  onChannelLeaved(final String channelID, final int ecode) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onChannelLeaved");
                            map.putString("channelID", channelID);
                            map.putInt("ecode", ecode);
                            commonEvent(map);
                        }
                    });
                }



                @Override
                public void onChannelUserList(final String[] accounts, final int[] uids) {
                    super.onChannelUserList(accounts, uids);
                    // convert list to string
                    final StringBuilder sb = new StringBuilder();
                    for (String s : accounts)
                    {
                        sb.append(s);
                        sb.append(",");
                    }
                    final StringBuilder sb1 = new StringBuilder();
                    for (int s : uids)
                    {
                        sb1.append(Integer.toString(s));
                        sb1.append(",");
                    }
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onChannelUserList");
                            map.putString("accounts", sb.toString());
                            map.putString("uids", sb1.toString());
                            commonEvent(map);
                        }
                    });
                }

                @Override
                public void onLogout(final int i) {

                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
//                            if (i == IAgoraAPI.ECODE_LOGOUT_E_KICKED) { //other login the account
//                                WritableMap map = Arguments.createMap();
//                                map.putString("type", "onLogoutForceout");
//                                map.putInt("code", i);
//                                commonEvent(map);
//
//                            } else if (i == IAgoraAPI.ECODE_LOGOUT_E_NET) { //net
//                                WritableMap map = Arguments.createMap();
//                                map.putString("type", "onLogoutForNetwork");
//                                map.putInt("code", i);
//                                commonEvent(map);
//                            }else {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onLogout");
                            map.putInt("code", i);
                            commonEvent(map);
                            // }
                        }
                    });

                }

                @Override
                public void onChannelUserJoined(final String account, final int uid) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onChannelUserJoined");
                            map.putInt("uid", uid);
                            map.putString("account", account);
                            commonEvent(map);
                        }
                    });
                }

                @Override
                public void onChannelUserLeaved(final String account, final int uid) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onChannelUserLeaved");
                            map.putInt("uid", uid);
                            map.putString("account", account);
                            commonEvent(map);
                        }
                    });
                }


                @Override
                public void onQueryUserStatusResult(final String name, final String status) {
                    Log.i(TAG, "onQueryUserStatusResult  name = " + name + "  status = " + status);
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onQueryUserStatusResult");
                            map.putString("status", status);
                            map.putString("name", name);
                            commonEvent(map);
                        }
                    });
                }

                // query channel user nums
                @Override
                public void onChannelQueryUserNumResult(final String channelID, final int ecode, final int num) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onChannelQueryUserNumResult");
                            map.putString("channelID", channelID);
                            map.putInt("ecode", ecode);
                            map.putInt("num", num);
                            commonEvent(map);
                        }
                    });
                }

                // get signal message
                @Override
                public void onMessageInstantReceive(final String account, final int uid, final String msg) {
                    Log.i(TAG, "onMessageInstantReceive  account = " + account + " uid = " + uid + " msg = " + msg);
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onReceiveMessage");
                            map.putString("account", account);
                            map.putInt("uid", uid);
                            map.putString("msg", msg);
                            commonEvent(map);
                        }
                    });
                }

                @Override
                public void onMessageChannelReceive(final String channelID, final String account, final int uid, final String msg) {
                    Log.i(TAG, "onMessageChannelReceive  account = " + account + " uid = " + uid + " msg = " + msg);
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            //self message had added
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onMessageChannelReceive");
                            map.putString("account", account);
                            map.putString("channelID", channelID);
                            map.putInt("uid", uid);
                            map.putString("msg", msg);
                            commonEvent(map);
                        }
                    });
                }

                @Override
                public void onMessageSendSuccess(final String messageID) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            //self message had added
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onMessageSendSuccess");
                            map.putString("messageID", messageID);
                            commonEvent(map);
                        }
                    });
                }

                @Override
                public void onMessageSendError(final String messageID, final int ecode) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            //self message had added
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onMessageSendError");
                            map.putString("messageID", messageID);
                            map.putInt("ecode", ecode);
                            commonEvent(map);
                        }
                    });
                }

                // get call invited
                @Override
                public void onInviteReceived(final String channelID, final String account,final int uid, final String extra) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onInviteReceived");
                            map.putString("channelID", channelID);
                            map.putString("account", account);
                            map.putInt("uid", uid);
                            map.putString("extra", extra);
                            commonEvent(map);
                        }
                    });
                }


                // your call arrived
                @Override
                public void onInviteReceivedByPeer(final String channelID, final String account,final int uid) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onInviteReceivedByPeer");
                            map.putString("channelID", channelID);
                            map.putString("account", account);
                            map.putInt("uid", uid);
                            commonEvent(map);
                        }
                    });
                }

                // your call received by peer
                @Override
                public void onInviteAcceptedByPeer(final String channelID, final String account,final int uid,  final String extra) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onInviteAcceptedByPeer");
                            map.putString("channelID", channelID);
                            map.putString("account", account);
                            map.putInt("uid", uid);
                            map.putString("extra", extra);
                            commonEvent(map);
                        }
                    });
                }

                // your call refused by peer
                @Override
                public void onInviteRefusedByPeer(final String channelID, final String account,final int uid,  final String extra) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onInviteRefusedByPeer");
                            map.putString("channelID", channelID);
                            map.putString("account", account);
                            map.putInt("uid", uid);
                            map.putString("extra", extra);
                            commonEvent(map);
                        }
                    });
                }

                // invite error
                @Override
                public void onInviteFailed(final String channelID, final String account,final int uid, final int ecode, final String extra) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onInviteFailed");
                            map.putString("channelID", channelID);
                            map.putString("account", account);
                            map.putInt("uid", uid);
                            map.putInt("ecode", ecode);
                            map.putString("extra", extra);
                            commonEvent(map);
                        }
                    });
                }


                // onInviteEndByPeer
                @Override
                public void onInviteEndByPeer(final String channelID, final String account,final int uid, final String extra) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onInviteEndByPeer");
                            map.putString("channelID", channelID);
                            map.putString("account", account);
                            map.putInt("uid", uid);
                            map.putString("extra", extra);
                            commonEvent(map);
                        }
                    });
                }

                // onInviteEndByMyself
                @Override
                public void onInviteEndByMyself(final String channelID, final String account,final int uid) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onInviteEndByMyself");
                            map.putString("channelID", channelID);
                            map.putString("account", account);
                            map.putInt("uid", uid);
                            commonEvent(map);
                        }
                    });
                }


                // onInviteMsg
                @Override
                public void onInviteMsg(final String channelID, final String account,final int uid, final String msgType, final String msgData, final String extra) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onInviteMsg");
                            map.putString("channelID", channelID);
                            map.putString("account", account);
                            map.putInt("uid", uid);
                            map.putString("msgType", msgType);
                            map.putString("msgData", msgData);
                            map.putString("extra", extra);
                            commonEvent(map);
                        }
                    });
                }


                @Override
                public void onError(final String s, final int i, final String s1) {
                    Log.i(TAG, "onError s:" + s + " s1:" + s1);
                    // 把所有的错误日志收集起来
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            WritableMap map = Arguments.createMap();
                            map.putString("type", "onError");
                            map.putString("name", s);
                            map.putInt("ecode", i);
                            map.putString("desc", s1);
                            commonEvent(map);
                        }
                    });
                }

            });

        } catch (Exception e) {
            Log.e(TAG, Log.getStackTraceString(e));

            throw new RuntimeException("NEED TO check rtc sdk init fatal error\n" + Log.getStackTraceString(e));
        }
    }
}
