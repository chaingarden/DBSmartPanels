//
//  SPPreferences.h
//  DBSmartPanels
//
//  Created by Dave Blundell on 10/19/14.
//  Copyright (c) 2014 Dave Blundell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPPreferences : NSObject

@property (nonatomic) BOOL hideDebuggerWhenTypingBegins;
@property (nonatomic) BOOL hideUtilitiesWhenTypingBegins;

@property (nonatomic) BOOL restoreEditorModeWhenOpeningTextDocument;
@property (nonatomic) BOOL restoreDebuggerWhenOpeningTextDocument;
@property (nonatomic) BOOL hideUtilitiesWhenOpeningTextDocument;

@property (nonatomic) BOOL switchToStandardEditorModeWhenOpeningInterfaceFile;
@property (nonatomic) BOOL hideDebuggerWhenOpeningInterfaceFile;
@property (nonatomic) BOOL showUtilitiesWhenOpeningInterfaceFile;

+ (SPPreferences *)sharedPreferences;

- (void)restoreDefaults;
- (void)restoreXcodeBehavior;

@end
