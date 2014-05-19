//
//  Constants.h
//  chat
//
//  Created by brightvision on 14-5-19.
//
//

#import <Foundation/Foundation.h>

#define COLUMN_COUNT  2; // 显示列数

#define PICTURE_COUNT_PER_LOAD  20; // 每次加载30张图片

#define PICTURE_TOTAL_COUNT  10000; // 允许加载的最多图片数

#define HANDLER_WHAT  1;

#define MESSAGE_DELAY  200;

#define twitterId  @"2421760711";
#define facebookId  @"100002947367631";


//----------------- company ------------------//
/*
#define SERVER_IP  @"116.228.54.226";// 服务器ip
#define SERVER_PORT  8083;// 服务器端口
#define TOMCAT_SERVER  @"http://116.228.54.226:8084/";
#define BAIDU_MAP_API  @"9Eje5rLXl3bvyb7Dkg4rs8TM";
 //----------------- company ------------------//
 */


//----------------- personal ------------------//
#define SERVER_IP @"192.168.1.118";// 服务器ip
#define SERVER_PORT  8080;// 服务器端口
#define TOMCAT_SERVER  @"http://192.168.1.118:8088/";
#define BAIDU_MAP_API  @"ku8Ezr8HVTA8IyM9ODfYq5Rq";
//----------------- personal ------------------//


#define REGISTER_FAIL  0;// 注册失败
#define ACTION  @"com.most.message";// 消息广播action
#define MSGKEY  @"message";// 消息的key
#define IP_PORT  @"ipPort";// 保存ip、port的xml文件名
#define SAVE_USER  @"saveUser";// 保存用户信息的xml文件名
#define BACKKEY_ACTION  @"com.most.backKey";// 返回键发送广播的action
#define NOTIFY_ID  0x911;// 通知ID

//#define MOSTAPPFILE  Environment.getExternalStorageDirectory() + "most_app/chat_image/";

#define MOMENT_NOTICE  0x100;
#define THING_NOTICE  0x101;
#define CHAT_NOTICE  0x102;
#define CONTACT_NOTICE  0x103;
#define ME_NOTICE  0x104;

@interface Constants : NSObject

@end
