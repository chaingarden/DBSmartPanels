//
//  NSWindowController+IDEWorkspaceWindowController.h
//  DBSmartPanels
//
//  Created by Dave Blundell on 10/14/14.
//  Copyright (c) 2014 Dave Blundell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSObject+XCRuntimeSupport.h"

@interface NSWindowController (IDEWorkspaceWindowController) <IDEWorkspaceWindowController>

+ (NSWindowController *)windowControllerContainingEditorArea:(NSViewController<IDEEditorArea> *)editorArea;
+ (NSWindowController *)windowControllerContainingSourceTextView:(NSTextView *)sourceTextView;

- (void)setEditorMode:(NSNumber *)editorMode
	   debuggerHidden:(NSNumber *)debuggerHidden
	  navigatorHidden:(NSNumber *)navigatorHidden
	  utilitiesHidden:(NSNumber *)utilitiesHidden;
- (BOOL)isDebuggerHidden;

@end
