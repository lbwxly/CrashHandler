//
//  TestObject.h
//  CrashHandlerTest
//
//  Created by WangJensen on 7/1/17.
//  Copyright © 2017 WangJensen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Completion)();
typedef void(^CrashCallBack)(int signal,NSString* callStack,Completion completion);

@interface OCCrashHandler : NSObject

+(void)install:(CrashCallBack)crashCallback;

@end
