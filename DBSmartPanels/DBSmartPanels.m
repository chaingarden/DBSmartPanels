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
#import "NSDocument+Utilities.h"

static DBSmartPanels *sharedPlugin;

@interface DBSmartPanels()
@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic) BOOL debuggerWasVisibleBeforeOpeningInterfaceFile;
@property (nonatomic, strong) NSNumber *editorModeBeforeOpeningInterfaceFile;
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
        NSDocument *primaryEditorDocument = [editorArea primaryEditorDocument];
        
        [self handleDocumentOpenedEventForDocument:primaryEditorDocument editorArea:editorArea];
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

- (void)handleDocumentOpenedEventForDocument:(NSDocument *)document editorArea:(NSObject<IDEEditorArea> *)editorArea {
    switch (document.documentType) {
        case SPDocumentTypeInterface: {
            // remember state for restoring when returning to a text document
            self.debuggerWasVisibleBeforeOpeningInterfaceFile = ![self isDebuggerHidden];
            self.editorModeBeforeOpeningInterfaceFile = @(editorArea.editorMode);
            
            NSNumber *debuggerHidden = [SPPreferences sharedPreferences].hideDebuggerWhenOpeningInterfaceFile ? @YES : nil;
            NSNumber *utilitiesHidden = [SPPreferences sharedPreferences].showUtilitiesWhenOpeningInterfaceFile ? @NO : nil;
            NSNumber *editorMode = [SPPreferences sharedPreferences].switchToStandardEditorModeWhenOpeningInterfaceFile ? @(SPIDEEditorModeStandard) : nil;
            
            [self setEditorMode:editorMode debuggerHidden:debuggerHidden utilitiesHidden:utilitiesHidden];
            break;
        }
            
        case SPDocumentTypeText: {
            NSNumber *debuggerHidden = ([SPPreferences sharedPreferences].restoreDebuggerWhenOpeningTextDocument && self.debuggerWasVisibleBeforeOpeningInterfaceFile) ? @NO : nil;
            NSNumber *utilitiesHidden = [SPPreferences sharedPreferences].hideUtilitiesWhenOpeningTextDocument ? @YES : nil;
            NSNumber *editorMode = [SPPreferences sharedPreferences].restoreEditorModeWhenOpeningTextDocument ? self.editorModeBeforeOpeningInterfaceFile : nil;
            
            [self setEditorMode:editorMode debuggerHidden:debuggerHidden utilitiesHidden:utilitiesHidden];
            
            self.debuggerWasVisibleBeforeOpeningInterfaceFile = NO;
            self.editorModeBeforeOpeningInterfaceFile = nil;
        }
            
        default:
            break;
    }
}

- (void)handleTypingBegan {
    NSNumber *debuggerHidden = [SPPreferences sharedPreferences].hideDebuggerWhenTypingBegins ? @YES : nil;
    NSNumber *utilitiesHidden = [SPPreferences sharedPreferences].hideUtilitiesWhenTypingBegins ? @YES : nil;
    
    [self setEditorMode:nil debuggerHidden:debuggerHidden utilitiesHidden:utilitiesHidden];
}

#pragma mark - Helper methods

- (BOOL)isDebuggerHidden {
    //TODO: for now, assuming we only have one workspace...
    for (NSWindowController *workspaceWindowController in [objc_getClass("IDEWorkspaceWindowController") workspaceWindowControllers]) {
        return [workspaceWindowController isDebuggerHidden];
    }
    return YES;
}

- (void)setEditorMode:(NSNumber *)editorMode debuggerHidden:(NSNumber *)debuggerHidden utilitiesHidden:(NSNumber *)utilitiesHidden
{
    for (NSWindowController *workspaceWindowController in [objc_getClass("IDEWorkspaceWindowController") workspaceWindowControllers]) {
        if (editorMode) {
            [workspaceWindowController setEditorMode:[editorMode integerValue]];
        }
        
        if (debuggerHidden) {
            [workspaceWindowController setDebuggerHidden:[debuggerHidden boolValue]];
        }
        
        if (utilitiesHidden) {
            [workspaceWindowController setUtilitiesHidden:[utilitiesHidden boolValue]];
        }
    }
}

@end
