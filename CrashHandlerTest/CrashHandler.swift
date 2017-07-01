//
//  CrashHandler.swift
//  CrashHandlerTest
//
//  Created by WangJensen on 6/30/17.
//  Copyright © 2017 WangJensen. All rights reserved.
//

import Foundation

public typealias Completion = ()->Void;
public typealias CrashCallback = (String,Completion)->Void;

public var crashCallBack:CrashCallback?

func signalHandler(signal:Int32) -> Void {
    var stackTrace = String();
    for symbol in Thread.callStackSymbols {
        stackTrace = stackTrace.appendingFormat("%@\r\n", symbol);
    }
    
    if crashCallBack != nil {
        crashCallBack!(stackTrace,{
            unregisterSignalHandler();
            exit(signal);
        });
    }
}

func registerSignalHanlder()
{
    signal(SIGINT, signalHandler);
    signal(SIGSEGV, signalHandler);
    signal(SIGTRAP, signalHandler);
    signal(SIGABRT, signalHandler);
    signal(SIGILL, signalHandler);
}

func unregisterSignalHandler()
{
    signal(SIGINT, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGTRAP, SIG_DFL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
}

public class CrashHandler
{
    public static func setup(callBack:@escaping CrashCallback){
        crashCallBack = callBack;
        registerSignalHanlder();
    }
}
