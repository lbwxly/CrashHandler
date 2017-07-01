//
//  TestObject.m
//  CrashHandlerTest
//
//  Created by WangJensen on 7/1/17.
//  Copyright © 2017 WangJensen. All rights reserved.
//

#import "OCCrashHandler.h"
#import <execinfo.h>

static CrashCallBack crashCallback;

@interface OCCrashHandler()

@end


void unregisterSignalHandler()
{
    signal(SIGINT, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGTRAP, SIG_DFL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    
}

NSArray* getStackTrace()
{
    //void buffer[] = void*[128];
    NSMutableArray* array = [NSMutableArray new];
    void *buffer[128];
    int frames = backtrace(buffer, 128);
    char** stackTraceFrames = backtrace_symbols(buffer, frames);
    for (int index = 0; index<frames; index++) {
        NSString *line = [NSString stringWithUTF8String:stackTraceFrames[index]];
        [array addObject:line];
    }
    
    return array;
}

void SingalHandler(int signal) {
    NSArray* stackFrames = getStackTrace();
    __block NSString *stackTrace = [NSString new];
    [stackFrames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString* frame = (NSString*)obj;
        stackTrace = [stackTrace stringByAppendingString:frame];
        stackTrace = [stackTrace stringByAppendingString:@"\r\n"];
    }];
    
    if (crashCallback != nil) {
        crashCallback(signal,stackTrace,^{
            unregisterSignalHandler();
            exit(signal);
        });
    } else {
        exit(signal);
    }
}

void registerSignalHandler()
{
    signal(SIGINT, SingalHandler);
    signal(SIGSEGV, SingalHandler);
    signal(SIGTRAP, SingalHandler);
    signal(SIGABRT, SingalHandler);
    signal(SIGILL, SingalHandler);
}

@implementation OCCrashHandler

+(void)install:(CrashCallBack)callback
{
    crashCallback = callback;
    registerSignalHandler();
}

@end
