//
//  DBSmartPanels.m
//  DBSmartPanels
//
//  Created by Dave Blundell on 10/16/14.
//  Copyright (c) 2014 Dave Blundell. All rights reserved.
//

#import "DBSmartPanels.h"
#import "NSMenu+Utilities.h"
#import "NSObject+XCRuntimeSupport.h"
#import "NSWindowController+IDEWorkspaceWindowController.h"
#import "Aspects.h"
#import <objc/objc-runtime.h>
#import "SPPreferencesWindowController.h"
#import "SPPreferences.h"

static DBSmartPanels *sharedPlugin;

@interface DBSmartPanels()
@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic) BOOL shouldShowDebuggerWhenOpeningNextTextDocument;
@property (nonatomic, strong) SPPreferencesWindowController *preferencesWindowController;
@end

@implementation DBSmartPanels

#pragma mark - Class methods

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

#pragma mark - Plugin lifeycle

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        
        // create menu item for preferences
        [self addPreferencesMenuItem];
        
        // setup event handlers after a delay
        [self performSelector:@selector(setupEventHandlers) withObject:nil afterDelay:5.0f];
    }
    return self;
}

#pragma mark - Setup

- (void)addPreferencesMenuItem {
    NSMenuItem *xcodeMenuItem = [[NSApp mainMenu] itemWithTitle:@"Xcode"];
    if (xcodeMenuItem) {
        [[xcodeMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *preferencesMenuItem = [[NSMenuItem alloc] initWithTitle:@"Smart Panels…" action:@selector(showPreferences) keyEquivalent:@""];
        [preferencesMenuItem setTarget:self];
        [[xcodeMenuItem submenu] insertItem:preferencesMenuItem afterItemWithTitle:@"Preferences…"];
    }
}

- (void)setupEventHandlers {
    [objc_getClass("DVTSourceTextView") aspect_hookSelector:@selector(didChangeText) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        [self handleTypingBegan];
    } error:NULL];
    
    [objc_getClass("IDEEditorArea") aspect_hookSelector:@selector(_openEditorOpenSpecifier:editorContext:takeFocus:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSObject<IDEEditorArea> *editorArea = [aspectInfo instance];
        NSObject<IDEEditorDocument> *primaryEditorDocument = [editorArea primaryEditorDocument];
        NSURL *url = [primaryEditorDocument fileURL];
        
        if ([url.absoluteString hasSuffix:@".xib"] || [url.absoluteString hasSuffix:@".storyboard"]) {
            [self handleInterfaceFileOpenedEvent];
        } else {
            [self handleTextDocumentOpenedEvent];
        }
    } error:NULL];
}

#pragma mark - Actions

- (void)showPreferences {
    if (!self.preferencesWindowController) {
        self.preferencesWindowController = [[SPPreferencesWindowController alloc] initWithWindowNibName:@"SPPreferencesWindowController"];
    }
    [self.preferencesWindowController showWindow:nil];
}

#pragma mark - Event handlers

- (void)handleInterfaceFileOpenedEvent {
    // if debugger is visible and we're auto-hiding it, we should restore it when we got back to a text document
    self.shouldShowDebuggerWhenOpeningNextTextDocument = ![self isDebuggerHidden];
    
    NSNumber *debuggerHidden = [SPPreferences sharedPreferences].hideDebuggerWhenOpeningInterfaceFile ? @YES : nil;
    NSNumber *utilitiesHidden = [SPPreferences sharedPreferences].showUtilitiesWhenOpeningInterfaceFile ? @NO : nil;
    BOOL switchToStandardEditor = [SPPreferences sharedPreferences].switchToStandardEditorModeWhenOpeningInterfaceFile;
    
    [self setDebuggerHidden:debuggerHidden utilitiesHidden:utilitiesHidden switchToStandardEditor:switchToStandardEditor];
}

- (void)handleTextDocumentOpenedEvent {
    NSNumber *debuggerHidden = ([SPPreferences sharedPreferences].restoreDebuggerWhenOpeningTextDocument && self.shouldShowDebuggerWhenOpeningNextTextDocument) ? @NO : nil;
    NSNumber *utilitiesHidden = [SPPreferences sharedPreferences].hideUtilitiesWhenOpeningTextDocument ? @YES : nil;
    // TODO: restore Assistant Editor if applicable (-[IDEEditorArea _setEditorMode:])
    
    [self setDebuggerHidden:debuggerHidden utilitiesHidden:utilitiesHidden switchToStandardEditor:NO];
    
    self.shouldShowDebuggerWhenOpeningNextTextDocument = NO;
}

- (void)handleTypingBegan {
    NSNumber *debuggerHidden = [SPPreferences sharedPreferences].hideDebuggerWhenTypingBegins ? @YES : nil;
    NSNumber *utilitiesHidden = [SPPreferences sharedPreferences].hideUtilitiesWhenTypingBegins ? @YES : nil;
    
    [self setDebuggerHidden:debuggerHidden utilitiesHidden:utilitiesHidden switchToStandardEditor:NO];
}

#pragma mark - Helper methods

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
