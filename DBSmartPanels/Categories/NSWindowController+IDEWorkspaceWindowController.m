//
//  NSWindowController+IDEWorkspaceWindowController.m
//  DBSmartPanels
//
//  Created by Dave Blundell on 10/14/14.
//  Copyright (c) 2014 Dave Blundell. All rights reserved.
//

#import "NSWindowController+IDEWorkspaceWindowController.h"

@implementation NSWindowController (IDEWorkspaceWindowController)

- (BOOL)isDebuggerHidden {
    NSObject<IDEEditorArea> *editorArea = self.editorArea;
    return !editorArea.showDebuggerArea;
}

- (void)setDebuggerHidden:(BOOL)hidden {
    if ([self isDebuggerHidden] != hidden) {
        NSObject<IDEEditorArea> *editorArea = self.editorArea;
        [editorArea toggleDebuggerVisibility:nil];
    }
}

- (void)setUtilitiesHidden:(BOOL)hidden {
    NSObject<IDEWorkspaceTabController> *tabController = self.activeWorkspaceTabController;
    
    if ([tabController isUtilitiesAreaVisible] == hidden) {
        [tabController toggleUtilitiesVisibility:nil];
    }
}

- (void)setEditorMode:(SPIDEEditorMode)editorMode {
//    NSObject<IDEWorkspaceTabController> *tabController = self.activeWorkspaceTabController;
//    [tabController changeToStandardEditor:nil];
    NSObject<IDEEditorArea> *editorArea = self.editorArea;
    if (editorArea.editorMode != editorMode) {
        [editorArea _setEditorMode:editorMode];
    }
}

@end
