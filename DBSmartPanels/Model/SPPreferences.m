//
//  SPPreferences.m
//  DBSmartPanels
//
//  Created by Dave Blundell on 10/19/14.
//  Copyright (c) 2014 David Blundell. All rights reserved.
//

#import "SPPreferences.h"

#define kHideDebuggerWhenTypingBeginsUserDefaultsKey @"hideDebuggerWhenTypingBegins"
#define kHideUtilitiesWhenTypingBeginsUserDefaultsKey @"hideUtilitiesWhenTypingBegins"

#define kRestoreEditorModeWhenOpeningTextDocumentUserDefaultsKey @"restoreEditorModeWhenOpeningTextDocument"
#define kRestoreDebuggerWhenOpeningTextDocumentUserDefaultsKey @"restoreDebuggerWhenOpeningTextDocument"
#define kHideUtilitiesWhenOpeningTextDocumentUserDefaultsKey @"hideUtilitiesWhenOpeningTextDocument"

#define kSwitchToStandardEditorModeWhenOpeningInterfaceFileUserDefaultsKey @"switchToStandardEditorModeWhenOpeningInterfaceFile"
#define kHideDebuggerWhenOpeningInterfaceFileUserDefaultsKey @"hideDebuggerWhenOpeningInterfaceFile"
#define kShowUtilitiesWhenOpeningInterfaceFileUserDefaultsKey @"showUtilitiesWhenOpeningInterfaceFile"

#define LOAD_PROPERTY(NAME, KEY, DEFAULT_VALUE, FORCE_DEFAULT) \
if (FORCE_DEFAULT || ![[NSUserDefaults standardUserDefaults] objectForKey:@""KEY]) self.NAME = DEFAULT_VALUE;

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

#pragma mark - Object lifecycle

- (instancetype)init {
    if (self = [super init]) {
        [self loadProperties];
    }
    return self;
}

#pragma mark - Getters & setters

BOOL_PROPERTY(hideDebuggerWhenTypingBegins, kHideDebuggerWhenTypingBeginsUserDefaultsKey, setHideDebuggerWhenTypingBegins)
BOOL_PROPERTY(hideUtilitiesWhenTypingBegins, kHideUtilitiesWhenTypingBeginsUserDefaultsKey, setHideUtilitiesWhenTypingBegins)

BOOL_PROPERTY(restoreEditorModeWhenOpeningTextDocument, kRestoreEditorModeWhenOpeningTextDocumentUserDefaultsKey, setRestoreEditorModeWhenOpeningTextDocument)
BOOL_PROPERTY(restoreDebuggerWhenOpeningTextDocument, kRestoreDebuggerWhenOpeningTextDocumentUserDefaultsKey, setRestoreDebuggerWhenOpeningTextDocument)
BOOL_PROPERTY(hideUtilitiesWhenOpeningTextDocument, kHideUtilitiesWhenOpeningTextDocumentUserDefaultsKey, setHideUtilitiesWhenOpeningTextDocument)

BOOL_PROPERTY(switchToStandardEditorModeWhenOpeningInterfaceFile, kSwitchToStandardEditorModeWhenOpeningInterfaceFileUserDefaultsKey, setSwitchToStandardEditorModeWhenOpeningInterfaceFile)
BOOL_PROPERTY(hideDebuggerWhenOpeningInterfaceFile, kHideDebuggerWhenOpeningInterfaceFileUserDefaultsKey, setHideDebuggerWhenOpeningInterfaceFile)
BOOL_PROPERTY(showUtilitiesWhenOpeningInterfaceFile, kShowUtilitiesWhenOpeningInterfaceFileUserDefaultsKey, setShowUtilitiesWhenOpeningInterfaceFile)

#pragma mark - Loading and restoring

- (void)loadProperties {
    [self loadPropertiesForceDefaults:NO];
}

- (void)loadPropertiesForceDefaults:(BOOL)forceDefaults {
    LOAD_PROPERTY(hideDebuggerWhenTypingBegins, kHideDebuggerWhenTypingBeginsUserDefaultsKey, YES, forceDefaults);
    LOAD_PROPERTY(hideUtilitiesWhenTypingBegins, kHideUtilitiesWhenTypingBeginsUserDefaultsKey, YES, forceDefaults);
    
    LOAD_PROPERTY(restoreEditorModeWhenOpeningTextDocument, kRestoreEditorModeWhenOpeningTextDocumentUserDefaultsKey, YES, forceDefaults);
    LOAD_PROPERTY(restoreDebuggerWhenOpeningTextDocument, kRestoreDebuggerWhenOpeningTextDocumentUserDefaultsKey, NO, forceDefaults);
    LOAD_PROPERTY(hideUtilitiesWhenOpeningTextDocument, kHideUtilitiesWhenOpeningTextDocumentUserDefaultsKey, YES, forceDefaults);
    
    LOAD_PROPERTY(switchToStandardEditorModeWhenOpeningInterfaceFile, kSwitchToStandardEditorModeWhenOpeningInterfaceFileUserDefaultsKey, YES, forceDefaults);
    LOAD_PROPERTY(hideDebuggerWhenOpeningInterfaceFile, kHideDebuggerWhenOpeningInterfaceFileUserDefaultsKey, YES, forceDefaults);
    LOAD_PROPERTY(showUtilitiesWhenOpeningInterfaceFile, kShowUtilitiesWhenOpeningInterfaceFileUserDefaultsKey, YES, forceDefaults);
}

- (void)restoreDefaults {
    [self loadPropertiesForceDefaults:YES];
}

@end
