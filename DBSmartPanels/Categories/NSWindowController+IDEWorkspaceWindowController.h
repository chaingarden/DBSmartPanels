//
//  NSWindowController+IDEWorkspaceWindowController.h
//  DBInspectorTuckAway
//
//  Created by Dave Blundell on 10/14/14.
//  Copyright (c) 2014 David Blundell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindowController (IDEWorkspaceWindowController)

- (BOOL)isDebuggerHidden;
- (void)setDebuggerHidden:(BOOL)hidden;
- (void)setUtilitiesHidden:(BOOL)hidden;
- (void)changeToStandardEditor;

@end
