//
//  SPPreferences.m
//  DBSmartPanels
//
//  Created by Dave Blundell on 10/19/14.
//  Copyright (c) 2014 Dave Blundell. All rights reserved.
//

#import "SPPreferences.h"

#define kAutohidingBehaviorUserDefaultsKey @"autohidingBehavior"

#define kHideDebuggerWhenTypingBeginsUserDefaultsKey @"hideDebuggerWhenTypingBegins"
#define kDontHideDebuggerWhileDebuggingWhenTypingBeginsUserDefaultsKey @"dontHideDebuggerWhileDebuggingWhenTypingBegins"
#define kHideNavigatorWhenTypingBeginsUserDefaultsKey @"hideNavigatorWhenTypingBegins"
#define kHideUtilitiesWhenTypingBeginsUserDefaultsKey @"hideUtilitiesWhenTypingBegins"

#define kRestoreEditorModeWhenOpeningTextDocumentUserDefaultsKey @"restoreEditorModeWhenOpeningTextDocument"
#define kRestoreDebuggerWhenOpeningTextDocumentUserDefaultsKey @"restoreDebuggerWhenOpeningTextDocument"
#define kHideNavigatorWhenOpeningTextDocumentUserDefaultsKey @"hideNavigatorWhenOpeningTextDocument"
#define kHideUtilitiesWhenOpeningTextDocumentUserDefaultsKey @"hideUtilitiesWhenOpeningTextDocument"

#define kSwitchToStandardEditorModeWhenOpeningInterfaceFileUserDefaultsKey @"switchToStandardEditorModeWhenOpeningInterfaceFile"
#define kHideDebuggerWhenOpeningInterfaceFileUserDefaultsKey @"hideDebuggerWhenOpeningInterfaceFile"
#define kDontHideDebuggerWhileDebuggingWhenOpeningInterfaceFileUserDefaultsKey @"dontHideDebuggerWhileDebuggingWhenOpeningInterfaceFile"
#define kHideNavigatorWhenOpeningInterfaceFileUserDefaultsKey @"hideNavigatorWhenOpeningInterfaceFile"
#define kShowUtilitiesWhenOpeningInterfaceFileUserDefaultsKey @"showUtilitiesWhenOpeningInterfaceFile"

#define LOAD_PROPERTY(NAME, KEY, DEFAULT_VALUE) \
if (![[NSUserDefaults standardUserDefaults] objectForKey:@""KEY]) self.NAME = DEFAULT_VALUE;

#define BOOL_PROPERTY(NAME, KEY, SETTER) \
- (BOOL)NAME { return [[NSUserDefaults standardUserDefaults] boolForKey:@""KEY]; } \
- (void)SETTER:(BOOL)value { [[NSUserDefaults standardUserDefaults] setBool:value forKey:@""KEY]; }

@implementation SPPreferences

#pragma mark - Singleton

static SPPreferences *sPreferences = nil;

+ (SPPreferences *)sharedPreferences {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sPreferences = [[SPPreferences alloc] init];
    });
    return sPreferences;
}

#pragma mark - Class methods

+ (NSString *)titleForAutohidingBehavior:(SPAutohidingBehavior)behavior {
    switch (behavior) {
        case SPAutohidingBehaviorNone:
            return @"None";
            break;
            
        case SPAutohidingBehaviorConservative:
            return @"Conservative";
            break;
            
        case SPAutohidingBehaviorAggressive:
            return @"Aggressive";
            break;
            
        case SPAutohidingBehaviorCustom:
            return @"Custom";
            break;
            
        default:
            return @"";
            break;
    }
}

+ (NSString *)explanationForAutohidingBehavior:(SPAutohidingBehavior)behavior {
    switch (behavior) {
        case SPAutohidingBehaviorNone:
            return @"Don't hide any panels (default Xcode behavior)";
            break;
            
        case SPAutohidingBehaviorConservative:
            return @"Hide debug and utilities areas (default plugin behavior)";
            break;
            
        case SPAutohidingBehaviorAggressive:
            return @"Hide navigator, debug, and utilities areas (good for small screens)";
            break;
            
        case SPAutohidingBehaviorCustom:
            return @"Custom preferences";
            break;
            
        default:
            return @"";
            break;
    }
}

#pragma mark - Object lifecycle

- (instancetype)init {
    if (self = [super init]) {
        [self loadProperties];
    }
    return self;
}

#pragma mark - Getters & setters

- (SPAutohidingBehavior)autohidingBehavior { return [[NSUserDefaults standardUserDefaults] integerForKey:kAutohidingBehaviorUserDefaultsKey]; }
- (void)setAutohidingBehavior:(SPAutohidingBehavior)autohidingBehavior {
    [[NSUserDefaults standardUserDefaults] setInteger:autohidingBehavior forKey:kAutohidingBehaviorUserDefaultsKey];
    [self loadPropertiesForAutohidingBehavior:autohidingBehavior];
}

BOOL_PROPERTY(hideDebuggerWhenTypingBegins, kHideDebuggerWhenTypingBeginsUserDefaultsKey, setHideDebuggerWhenTypingBegins)
BOOL_PROPERTY(dontHideDebuggerWhileDebuggingWhenTypingBegins, kDontHideDebuggerWhileDebuggingWhenTypingBeginsUserDefaultsKey, setDontHideDebuggerWhileDebuggingWhenTypingBegins)
BOOL_PROPERTY(hideNavigatorWhenTypingBegins, kHideNavigatorWhenTypingBeginsUserDefaultsKey, setHideNavigatorWhenTypingBegins)
BOOL_PROPERTY(hideUtilitiesWhenTypingBegins, kHideUtilitiesWhenTypingBeginsUserDefaultsKey, setHideUtilitiesWhenTypingBegins)

BOOL_PROPERTY(restoreEditorModeWhenOpeningTextDocument, kRestoreEditorModeWhenOpeningTextDocumentUserDefaultsKey, setRestoreEditorModeWhenOpeningTextDocument)
BOOL_PROPERTY(restoreDebuggerWhenOpeningTextDocument, kRestoreDebuggerWhenOpeningTextDocumentUserDefaultsKey, setRestoreDebuggerWhenOpeningTextDocument)
BOOL_PROPERTY(hideNavigatorWhenOpeningTextDocument, kHideNavigatorWhenOpeningTextDocumentUserDefaultsKey, setHideNavigatorWhenOpeningTextDocument)
BOOL_PROPERTY(hideUtilitiesWhenOpeningTextDocument, kHideUtilitiesWhenOpeningTextDocumentUserDefaultsKey, setHideUtilitiesWhenOpeningTextDocument)

BOOL_PROPERTY(switchToStandardEditorModeWhenOpeningInterfaceFile, kSwitchToStandardEditorModeWhenOpeningInterfaceFileUserDefaultsKey, setSwitchToStandardEditorModeWhenOpeningInterfaceFile)
BOOL_PROPERTY(hideDebuggerWhenOpeningInterfaceFile, kHideDebuggerWhenOpeningInterfaceFileUserDefaultsKey, setHideDebuggerWhenOpeningInterfaceFile)
BOOL_PROPERTY(dontHideDebuggerWhileDebuggingWhenOpeningInterfaceFile, kDontHideDebuggerWhileDebuggingWhenOpeningInterfaceFileUserDefaultsKey, setDontHideDebuggerWhileDebuggingWhenOpeningInterfaceFile)
BOOL_PROPERTY(hideNavigatorWhenOpeningInterfaceFile, kHideNavigatorWhenOpeningInterfaceFileUserDefaultsKey, setHideNavigatorWhenOpeningInterfaceFile)
BOOL_PROPERTY(showUtilitiesWhenOpeningInterfaceFile, kShowUtilitiesWhenOpeningInterfaceFileUserDefaultsKey, setShowUtilitiesWhenOpeningInterfaceFile)

#pragma mark - Loading and restoring

- (void)loadProperties {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kAutohidingBehaviorUserDefaultsKey]) {
        self.autohidingBehavior = SPAutohidingBehaviorConservative; // default to Conservative auto-hiding behavior
    } else {
        [self loadPropertiesForAutohidingBehavior:self.autohidingBehavior];
    }
}

- (void)loadPropertiesForAutohidingBehavior:(SPAutohidingBehavior)behavior {
    switch (behavior) {
        case SPAutohidingBehaviorNone:
            self.hideDebuggerWhenTypingBegins = NO;
            self.dontHideDebuggerWhileDebuggingWhenTypingBegins = NO;
            self.hideNavigatorWhenTypingBegins = NO;
            self.hideUtilitiesWhenTypingBegins = NO;
            
            self.restoreEditorModeWhenOpeningTextDocument = NO;
            self.restoreDebuggerWhenOpeningTextDocument = NO;
            self.hideNavigatorWhenOpeningTextDocument = NO;
            self.hideUtilitiesWhenOpeningTextDocument = NO;
            
            self.switchToStandardEditorModeWhenOpeningInterfaceFile = NO;
            self.hideDebuggerWhenOpeningInterfaceFile = NO;
            self.dontHideDebuggerWhileDebuggingWhenOpeningInterfaceFile = NO;
            self.hideNavigatorWhenOpeningInterfaceFile = NO;
            self.showUtilitiesWhenOpeningInterfaceFile = NO;
            break;
            
        case SPAutohidingBehaviorConservative:
            self.hideDebuggerWhenTypingBegins = YES;
            self.dontHideDebuggerWhileDebuggingWhenTypingBegins = YES;
            self.hideNavigatorWhenTypingBegins = NO;
            self.hideUtilitiesWhenTypingBegins = YES;
            
            self.restoreEditorModeWhenOpeningTextDocument = YES;
            self.restoreDebuggerWhenOpeningTextDocument = NO;
            self.hideNavigatorWhenOpeningTextDocument = NO;
            self.hideUtilitiesWhenOpeningTextDocument = YES;
            
            self.switchToStandardEditorModeWhenOpeningInterfaceFile = YES;
            self.hideDebuggerWhenOpeningInterfaceFile = YES;
            self.dontHideDebuggerWhileDebuggingWhenOpeningInterfaceFile = NO;
            self.hideNavigatorWhenOpeningInterfaceFile = NO;
            self.showUtilitiesWhenOpeningInterfaceFile = YES;
            break;
            
        case SPAutohidingBehaviorAggressive:
            self.hideDebuggerWhenTypingBegins = YES;
            self.dontHideDebuggerWhileDebuggingWhenTypingBegins = YES;
            self.hideNavigatorWhenTypingBegins = YES;
            self.hideUtilitiesWhenTypingBegins = YES;
            
            self.restoreEditorModeWhenOpeningTextDocument = YES;
            self.restoreDebuggerWhenOpeningTextDocument = NO;
            self.hideNavigatorWhenOpeningTextDocument = YES;
            self.hideUtilitiesWhenOpeningTextDocument = YES;
            
            self.switchToStandardEditorModeWhenOpeningInterfaceFile = YES;
            self.hideDebuggerWhenOpeningInterfaceFile = YES;
            self.dontHideDebuggerWhileDebuggingWhenOpeningInterfaceFile = NO;
            self.hideNavigatorWhenOpeningInterfaceFile = YES;
            self.showUtilitiesWhenOpeningInterfaceFile = YES;
            break;
            
        default:
            // otherwise, load defaults if necessary
            LOAD_PROPERTY(hideDebuggerWhenTypingBegins, kHideDebuggerWhenTypingBeginsUserDefaultsKey, YES);
            LOAD_PROPERTY(dontHideDebuggerWhileDebuggingWhenTypingBegins, kDontHideDebuggerWhileDebuggingWhenTypingBeginsUserDefaultsKey, YES);
            LOAD_PROPERTY(hideNavigatorWhenTypingBegins, kHideNavigatorWhenTypingBeginsUserDefaultsKey, NO);
            LOAD_PROPERTY(hideUtilitiesWhenTypingBegins, kHideUtilitiesWhenTypingBeginsUserDefaultsKey, YES);
            
            LOAD_PROPERTY(restoreEditorModeWhenOpeningTextDocument, kRestoreEditorModeWhenOpeningTextDocumentUserDefaultsKey, YES);
            LOAD_PROPERTY(restoreDebuggerWhenOpeningTextDocument, kRestoreDebuggerWhenOpeningTextDocumentUserDefaultsKey, NO);
            LOAD_PROPERTY(hideNavigatorWhenOpeningTextDocument, kHideNavigatorWhenOpeningTextDocumentUserDefaultsKey, NO);
            LOAD_PROPERTY(hideUtilitiesWhenOpeningTextDocument, kHideUtilitiesWhenOpeningTextDocumentUserDefaultsKey, YES);
            
            LOAD_PROPERTY(switchToStandardEditorModeWhenOpeningInterfaceFile, kSwitchToStandardEditorModeWhenOpeningInterfaceFileUserDefaultsKey, YES);
            LOAD_PROPERTY(hideDebuggerWhenOpeningInterfaceFile, kHideDebuggerWhenOpeningInterfaceFileUserDefaultsKey, YES);
            LOAD_PROPERTY(dontHideDebuggerWhileDebuggingWhenOpeningInterfaceFile, kDontHideDebuggerWhileDebuggingWhenOpeningInterfaceFileUserDefaultsKey, NO);
            LOAD_PROPERTY(hideNavigatorWhenOpeningInterfaceFile, kHideNavigatorWhenOpeningInterfaceFileUserDefaultsKey, NO);
            LOAD_PROPERTY(showUtilitiesWhenOpeningInterfaceFile, kShowUtilitiesWhenOpeningInterfaceFileUserDefaultsKey, YES);
            break;
    }
}

@end
