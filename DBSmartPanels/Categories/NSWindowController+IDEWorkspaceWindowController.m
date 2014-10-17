//
//  NSWindowController+IDEWorkspaceWindowController.m
//  DBInspectorTuckAway
//
//  Created by Dave Blundell on 10/14/14.
//  Copyright (c) 2014 David Blundell. All rights reserved.
//

#import "NSWindowController+IDEWorkspaceWindowController.h"
#import "NSObject+ShutUpWarnings.h"

@implementation NSWindowController (IDEWorkspaceWindowController)

- (BOOL)isDebuggerHidden {
    NSObject *editorArea = self.editorArea;
    return !editorArea.showDebuggerArea;
}

- (void)setDebuggerHidden:(BOOL)hidden {
    if ([self isDebuggerHidden] != hidden) {
        NSObject *editorArea = self.editorArea;
        [editorArea toggleDebuggerVisibility:nil];
    }
}

- (void)setUtilitiesHidden:(BOOL)hidden {
    NSObject *tabController = self.activeWorkspaceTabController;
    
    if ([tabController isUtilitiesAreaVisible] == hidden) {
        [tabController toggleUtilitiesVisibility:nil];
    }
}

- (void)changeToStandardEditor {
    NSObject *tabController = self.activeWorkspaceTabController;
    [tabController changeToStandardEditor:nil];
}

@end
