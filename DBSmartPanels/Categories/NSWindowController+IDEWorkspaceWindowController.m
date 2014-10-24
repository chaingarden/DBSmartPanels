//
//  NSWindowController+IDEWorkspaceWindowController.m
//  DBSmartPanels
//
//  Created by Dave Blundell on 10/14/14.
//  Copyright (c) 2014 Dave Blundell. All rights reserved.
//

#import "NSWindowController+IDEWorkspaceWindowController.h"
#import "NSView+Utilities.h"

@implementation NSWindowController (IDEWorkspaceWindowController)

static NSCache *editorAreaToWindowControllerCache;
static NSCache *sourceTextViewToWindowControllerCache;

@dynamic activeWorkspaceTabController;
@dynamic editorArea;

#pragma mark - Class methods

+ (void)initialize {
	editorAreaToWindowControllerCache = [[NSCache alloc] init];
	sourceTextViewToWindowControllerCache = [[NSCache alloc] init];
}

+ (NSWindowController *)windowControllerContainingEditorArea:(NSViewController<IDEEditorArea> *)editorArea {
	NSWindowController *cachedWindowController = [editorAreaToWindowControllerCache objectForKey:editorArea];
	if (cachedWindowController) {
		return [cachedWindowController isKindOfClass:[NSNull class]] ? nil : cachedWindowController;
	}
	
	for (NSWindowController *windowController in [objc_getClass("IDEWorkspaceWindowController") workspaceWindowControllers]) {
		if (windowController.editorArea == editorArea) {
			[editorAreaToWindowControllerCache setObject:windowController forKey:editorArea];
			return windowController;
		}
	}
	
	[editorAreaToWindowControllerCache setObject:[NSNull null] forKey:editorArea];
	
	return nil;
}

+ (NSWindowController *)windowControllerContainingSourceTextView:(NSTextView *)sourceTextView {
	NSWindowController *cachedWindowController = [sourceTextViewToWindowControllerCache objectForKey:sourceTextView];
	if (cachedWindowController) {
		return [cachedWindowController isKindOfClass:[NSNull class]] ? nil : cachedWindowController;
	}
	
	for (NSWindowController *windowController in [objc_getClass("IDEWorkspaceWindowController") workspaceWindowControllers]) {
		NSViewController<IDEEditorArea> *editorArea = windowController.editorArea;
		
		if ([editorArea.view containsSubview:sourceTextView]) {
			[sourceTextViewToWindowControllerCache setObject:windowController forKey:sourceTextView];
			return windowController;
		}
	}
	
	[sourceTextViewToWindowControllerCache setObject:[NSNull null] forKey:sourceTextView];
	
	return nil;
}

#pragma mark - Instance methods

- (void)setEditorMode:(NSNumber *)editorMode debuggerHidden:(NSNumber *)debuggerHidden utilitiesHidden:(NSNumber *)utilitiesHidden {
	if (editorMode) {
		[self setEditorMode:[editorMode integerValue]];
	}
	
	if (debuggerHidden) {
		[self setDebuggerHidden:[debuggerHidden boolValue]];
	}
	
	if (utilitiesHidden) {
		[self setUtilitiesHidden:[utilitiesHidden boolValue]];
	}
}

- (BOOL)isDebuggerHidden {
    NSViewController<IDEEditorArea> *editorArea = self.editorArea;
    return !editorArea.showDebuggerArea;
}

- (void)setDebuggerHidden:(BOOL)hidden {
    if ([self isDebuggerHidden] != hidden) {
        NSViewController<IDEEditorArea> *editorArea = self.editorArea;
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
    NSViewController<IDEEditorArea> *editorArea = self.editorArea;
    if (editorArea.editorMode != editorMode) {
        [editorArea _setEditorMode:editorMode];
    }
}

@end
