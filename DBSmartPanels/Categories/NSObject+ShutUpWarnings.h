//
//  NSObject+ShutUpWarnings.h
//  DBInspectorTuckAway
//
//  Created by Dave Blundell on 10/13/14.
//  Copyright (c) 2014 David Blundell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ShutUpWarnings)

@property BOOL showDebuggerArea;
@property (readonly) id editorArea;
@property (readonly) id activeWorkspaceTabController;
@property (readonly) id primaryEditorDocument;

- (BOOL)isUtilitiesAreaVisible;
- (void)toggleUtilitiesVisibility:(id)arg1;
- (void)toggleDebuggerVisibility:(id)arg1;
- (void)changeToStandardEditor:(id)arg1;
- (NSArray *)workspaceWindowControllers;
- (void)_setEditorMode:(int)arg1;
- (NSURL *)fileURL;
- (void)_openEditorOpenSpecifier:(id)arg1 editorContext:(id)arg2 takeFocus:(BOOL)arg3;

@end
