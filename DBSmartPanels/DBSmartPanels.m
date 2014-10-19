//
//  DBSmartPanels.m
//  DBSmartPanels
//
//  Created by Dave Blundell on 10/16/14.
//  Copyright (c) 2014 David Blundell. All rights reserved.
//

#import "DBSmartPanels.h"
#import "NSObject+XCRuntimeSupport.h"
#import "NSWindowController+IDEWorkspaceWindowController.h"
#import "Aspects.h"
#import <objc/objc-runtime.h>

static DBSmartPanels *sharedPlugin;

@interface DBSmartPanels()
@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic) BOOL shouldShowDebuggerWhenOpeningNextTextDocument;
@end

@implementation DBSmartPanels

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        
        [self performSelector:@selector(setupEventHandlers) withObject:nil afterDelay:5.0f];
    }
    return self;
}

- (void)setupEventHandlers
{
    [objc_getClass("DVTSourceTextView") aspect_hookSelector:@selector(didChangeText) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        [self setDebuggerHidden:@YES utilitiesHidden:@YES switchToStandardEditor:NO];
    } error:NULL];
    
    [objc_getClass("IDEEditorArea") aspect_hookSelector:@selector(_openEditorOpenSpecifier:editorContext:takeFocus:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSObject<IDEEditorArea> *editorArea = [aspectInfo instance];
        NSObject<IDEEditorDocument> *primaryEditorDocument = (NSObject *)[editorArea primaryEditorDocument];
        NSURL *url = [primaryEditorDocument fileURL];
        
        [self setupUIForPrimaryEditorDocumentWithURL:url];
    } error:NULL];
}

- (void)setupUIForPrimaryEditorDocumentWithURL:(NSURL *)url {
    if ([url.absoluteString hasSuffix:@".xib"] || [url.absoluteString hasSuffix:@".storyboard"]) {
        // if debugger is visible and we're auto-hiding it, we should restore it when we got back to a text document
        self.shouldShowDebuggerWhenOpeningNextTextDocument = ![self isDebuggerHidden];
        
        [self setDebuggerHidden:@YES utilitiesHidden:@NO switchToStandardEditor:YES];
    } else {
        NSNumber *debuggerHidden = self.shouldShowDebuggerWhenOpeningNextTextDocument ? @NO : nil;
        self.shouldShowDebuggerWhenOpeningNextTextDocument = NO;
        
        [self setDebuggerHidden:debuggerHidden utilitiesHidden:@YES switchToStandardEditor:NO];
        
        // TODO: restore Assistant Editor if applicable (-[IDEEditorArea _setEditorMode:])
    }
}

- (BOOL)isDebuggerHidden {
    //TODO: for now, assuming we only have one workspace...
    for (NSWindowController *workspaceWindowController in [objc_getClass("IDEWorkspaceWindowController") workspaceWindowControllers]) {
        return [workspaceWindowController isDebuggerHidden];
    }
    return YES;
}

- (void)setDebuggerHidden:(NSNumber *)debuggerHidden utilitiesHidden:(NSNumber *)utilitiesHidden switchToStandardEditor:(BOOL)standardEditor
{
    for (NSWindowController *workspaceWindowController in [objc_getClass("IDEWorkspaceWindowController") workspaceWindowControllers]) {
        if (debuggerHidden) {
            [workspaceWindowController setDebuggerHidden:[debuggerHidden boolValue]];
        }
        
        if (utilitiesHidden) {
            [workspaceWindowController setUtilitiesHidden:[utilitiesHidden boolValue]];
        }
        
        if (standardEditor) {
            [workspaceWindowController changeToStandardEditor];
        }
    }
}

@end
