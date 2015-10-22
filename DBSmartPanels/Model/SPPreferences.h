//
//  SPPreferences.h
//  DBSmartPanels
//
//  Created by Dave Blundell on 10/19/14.
//  Copyright (c) 2014 Dave Blundell. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SPAutohidingBehaviorNone = 0,
    SPAutohidingBehaviorConservative = 1,
    SPAutohidingBehaviorAggressive = 2,
    SPAutohidingBehaviorCustom = 3,
    SPAutohidingNumBehaviors = 4
} SPAutohidingBehavior;

@interface SPPreferences : NSObject

@property (nonatomic) SPAutohidingBehavior autohidingBehavior;

@property (nonatomic) BOOL hideDebuggerWhenTypingBegins;
@property (nonatomic) BOOL dontHideDebuggerWhileDebuggingWhenTypingBegins;
@property (nonatomic) BOOL hideNavigatorWhenTypingBegins;
@property (nonatomic) BOOL hideUtilitiesWhenTypingBegins;

@property (nonatomic) BOOL restoreEditorModeWhenOpeningTextDocument;
@property (nonatomic) BOOL restoreDebuggerWhenOpeningTextDocument;
@property (nonatomic) BOOL hideNavigatorWhenOpeningTextDocument;
@property (nonatomic) BOOL hideUtilitiesWhenOpeningTextDocument;

@property (nonatomic) BOOL switchToStandardEditorModeWhenOpeningInterfaceFile;
@property (nonatomic) BOOL hideDebuggerWhenOpeningInterfaceFile;
@property (nonatomic) BOOL dontHideDebuggerWhileDebuggingWhenOpeningInterfaceFile;
@property (nonatomic) BOOL hideNavigatorWhenOpeningInterfaceFile;
@property (nonatomic) BOOL showUtilitiesWhenOpeningInterfaceFile;

+ (SPPreferences *)sharedPreferences;

+ (NSString *)titleForAutohidingBehavior:(SPAutohidingBehavior)behavior;
+ (NSString *)explanationForAutohidingBehavior:(SPAutohidingBehavior)behavior;

@end
