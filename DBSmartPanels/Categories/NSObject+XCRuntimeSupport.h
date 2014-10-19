//
//  NSObject+XCRuntimeSupport.h
//  DBInspectorTuckAway
//
//  Created by Dave Blundell on 10/13/14.
//  Copyright (c) 2014 David Blundell. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IDEEditorArea <NSObject>
@property (readonly) id primaryEditorDocument;
@property BOOL showDebuggerArea;
- (void)_openEditorOpenSpecifier:(id)arg1 editorContext:(id)arg2 takeFocus:(BOOL)arg3;
- (void)_setEditorMode:(int)arg1;
- (void)toggleDebuggerVisibility:(id)arg1;
@end

@protocol IDEEditorDocument <NSObject>
- (NSURL *)fileURL;
@end

@protocol IDEWorkspaceTabController <NSObject>
@property (readonly) id editorArea;
- (void)changeToStandardEditor:(id)arg1;
- (BOOL)isUtilitiesAreaVisible;
- (void)toggleUtilitiesVisibility:(id)arg1;
@end

@protocol IDEWorkspaceWindowController <NSObject>
@property (readonly) id activeWorkspaceTabController;
@property (readonly) id editorArea;
- (NSArray *)workspaceWindowControllers;
@end
