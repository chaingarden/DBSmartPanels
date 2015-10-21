//
//  NSObject+XCRuntimeSupport.h
//  DBSmartPanels
//
//  Created by Dave Blundell on 10/13/14.
//  Copyright (c) 2014 Dave Blundell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

typedef enum : NSUInteger {
    SPIDEEditorModeStandard = 0,
    SPIDEEditorModeAssistant = 1,
    SPIDEEditorModeVersion = 2
} SPIDEEditorMode;

typedef enum : NSUInteger {
    SPIDENavigatorModeUnknown = -1,
    SPIDENavigatorModeProject = 0,
    SPIDENavigatorModeSymbol = 1,
    SPIDENavigatorModeFind = 2,
    SPIDENavigatorModeIssue = 3,
    SPIDENavigatorModeTest = 4,
    SPIDENavigatorModeDebug = 5,
    SPIDENavigatorModeBreakpoint = 6,
    SPIDENavigatorModeReport = 7
} SPIDENavigatorMode;

@protocol IDEEditorArea <NSObject>
@property (readonly) id primaryEditorDocument;
@property BOOL showDebuggerArea;
@property (nonatomic) int editorMode;
- (void)_openEditorOpenSpecifier:(id)arg1 editorContext:(id)arg2 takeFocus:(BOOL)arg3;
- (void)_openEditorHistoryItem:(id)arg1 editorContext:(id)arg2 takeFocus:(BOOL)arg3;
- (void)_setEditorMode:(int)arg1;
- (void)toggleDebuggerVisibility:(id)arg1;
@end

@protocol IDENavigatorArea <NSObject>
@property (readonly) NSString *currentNavigatorIdentifier;
@end

@protocol IDEWorkspaceTabController <NSObject>
@property (readonly) id<IDEEditorArea> editorArea;
@property (readonly) id<IDENavigatorArea> navigatorArea;
- (void)changeToStandardEditor:(id)arg1;
- (id)debugSessionController;
- (BOOL)isUtilitiesAreaVisible;
- (void)toggleUtilitiesVisibility:(id)arg1;
- (void)_updateForDebuggingKVOChange; // detect debug session state changes in Xcode 6; removed in Xcode 7
- (BOOL)isNavigatorVisible;
- (void)toggleNavigatorsVisibility:(id)arg1;
@end

@protocol IDEWorkspaceWindowController <NSObject>
@property (readonly) id<IDEWorkspaceTabController> activeWorkspaceTabController;
@property (readonly) id<IDEEditorArea> editorArea;
+ (NSArray *)workspaceWindowControllers;
- (void)changeFromDebugSessionState:(id)arg1 to:(id)arg2 forLaunchSession:(id)arg3; // detect debug session state changes in Xcode 7+
@end
