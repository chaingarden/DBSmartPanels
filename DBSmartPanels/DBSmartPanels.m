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
#import "NSTextView+DVTSourceTextView.h"

static DBSmartPanels *sharedPlugin;

@interface DBSmartPanels()
@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic) BOOL debuggerWasVisibleBeforeOpeningInterfaceFile;
@property (nonatomic, strong) NSNumber *editorModeBeforeOpeningInterfaceFile;
@property (nonatomic) BOOL isDebugging;
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
	@try {
		if (self = [super init]) {
			// reference to plugin's bundle, for resource access
			self.bundle = plugin;
			
			// create menu item for preferences (use a delay since [NSApp mainMenu] returns nil if called right away)
			[self performSelector:@selector(addPreferencesMenuItem) withObject:nil afterDelay:1.0f];
			
			// setup event handlers after a delay
			[self performSelector:@selector(setupEventHandlers) withObject:nil afterDelay:5.0f];
		}
	}
	@catch (NSException *exception) {
		self = nil;
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
    @try {
        [objc_getClass("DVTSourceTextView") aspect_hookSelector:@selector(didChangeText) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            @try {
                NSTextView *sourceTextView = [aspectInfo instance];
                
                if (![sourceTextView isInPopupWindow]) {
                    [self handleTypingBeganInSourceTextView:sourceTextView];
                }
            }
            @catch (NSException *exception) {
                [self logException:exception];
            }
        } error:NULL];
        
        [objc_getClass("IDEEditorArea") aspect_hookSelector:@selector(_openEditorOpenSpecifier:editorContext:takeFocus:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            @try {
                NSViewController<IDEEditorArea> *editorArea = [aspectInfo instance];
                
                [self handleDocumentOpenedEventForEditorArea:editorArea];
            }
            @catch (NSException *exception) {
                [self logException:exception];
            }
        } error:NULL];
        
        [objc_getClass("IDEEditorArea") aspect_hookSelector:@selector(_openEditorHistoryItem:editorContext:takeFocus:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            @try {
                NSViewController<IDEEditorArea> *editorArea = [aspectInfo instance];
                
                [self handleDocumentOpenedEventForEditorArea:editorArea];
            }
            @catch (NSException *exception) {
                [self logException:exception];
            }
        } error:NULL];
        
        [objc_getClass("IDEWorkspaceTabController") aspect_hookSelector:@selector(_updateForDebuggingKVOChange) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            @try {
                NSObject<IDEWorkspaceTabController> *tabController = [aspectInfo instance];
                NSObject *debugSessionController = [tabController debugSessionController];
                
                self.isDebugging = (debugSessionController != nil);
            }
            @catch (NSException *exception) {
                [self logException:exception];
            }
        } error:NULL];
    }
    @catch (NSException *exception) {
        [self logException:exception];
    }
}

- (void)logException:(NSException *)exception {
	NSLog(@"Exception in DBSmartPanels: %@ - %@\nCall stack:\n%@", [exception name], [exception reason], [NSThread callStackSymbols]);
}

#pragma mark - Actions

- (void)showPreferences {
    if (!self.preferencesWindowController) {
        self.preferencesWindowController = [[SPPreferencesWindowController alloc] initWithWindowNibName:@"SPPreferencesWindowController"];
    }
    [self.preferencesWindowController showWindow:nil];
}

#pragma mark - Event handlers

- (void)handleDocumentOpenedEventForEditorArea:(NSViewController<IDEEditorArea> *)editorArea {
	NSWindowController<IDEWorkspaceWindowController> *windowController = [NSWindowController windowControllerContainingEditorArea:editorArea];
	NSDocument *document = [editorArea primaryEditorDocument];
	
	if (!windowController || !document) {
		return;
	}
	
    switch (document.documentType) {
        case SPDocumentTypeInterface: {
            // remember state for restoring when returning to a text document
            self.debuggerWasVisibleBeforeOpeningInterfaceFile = ![windowController isDebuggerHidden];
            self.editorModeBeforeOpeningInterfaceFile = @(editorArea.editorMode);
			
			BOOL canHideDebugger = [self canHideDebuggerWhenOpeningInterfaceFile];
            NSNumber *debuggerHidden = (canHideDebugger && [SPPreferences sharedPreferences].hideDebuggerWhenOpeningInterfaceFile) ? @YES : nil;
            NSNumber *utilitiesHidden = [SPPreferences sharedPreferences].showUtilitiesWhenOpeningInterfaceFile ? @NO : nil;
            NSNumber *editorMode = [SPPreferences sharedPreferences].switchToStandardEditorModeWhenOpeningInterfaceFile ? @(SPIDEEditorModeStandard) : nil;
            
            [windowController setEditorMode:editorMode debuggerHidden:debuggerHidden navigatorHidden:nil utilitiesHidden:utilitiesHidden];
            break;
        }
            
        case SPDocumentTypeText: {
            NSNumber *debuggerHidden = (([SPPreferences sharedPreferences].restoreDebuggerWhenOpeningTextDocument || (self.isDebugging && [SPPreferences sharedPreferences].dontHideDebuggerWhileDebuggingWhenTypingBegins)) && self.debuggerWasVisibleBeforeOpeningInterfaceFile) ? @NO : nil;
			NSNumber *navigatorHidden = [SPPreferences sharedPreferences].hideNavigatorWhenOpeningTextDocument ? @YES : nil;
			NSNumber *utilitiesHidden = [SPPreferences sharedPreferences].hideUtilitiesWhenOpeningTextDocument ? @YES : nil;
            NSNumber *editorMode = [SPPreferences sharedPreferences].restoreEditorModeWhenOpeningTextDocument ? self.editorModeBeforeOpeningInterfaceFile : nil;
            
            [windowController setEditorMode:editorMode debuggerHidden:debuggerHidden navigatorHidden:navigatorHidden utilitiesHidden:utilitiesHidden];
            
            self.debuggerWasVisibleBeforeOpeningInterfaceFile = NO;
            self.editorModeBeforeOpeningInterfaceFile = nil;
        }
            
        default:
            break;
    }
}

- (void)handleTypingBeganInSourceTextView:(NSTextView *)textView {
	NSWindowController<IDEWorkspaceWindowController> *windowController = [NSWindowController windowControllerContainingSourceTextView:textView];
	
	if (!windowController) {
		return;
	}
	
	BOOL canHideDebugger = [self canHideDebuggerWhenTypingBegins];
	NSNumber *debuggerHidden = (canHideDebugger && [SPPreferences sharedPreferences].hideDebuggerWhenTypingBegins) ? @YES : nil;
	NSNumber *navigatorHidden = [SPPreferences sharedPreferences].hideNavigatorWhenTypingBegins ? @YES : nil;
	NSNumber *utilitiesHidden = [SPPreferences sharedPreferences].hideUtilitiesWhenTypingBegins ? @YES : nil;
	
	[windowController setEditorMode:nil debuggerHidden:debuggerHidden navigatorHidden:navigatorHidden utilitiesHidden:utilitiesHidden];
}

#pragma mark - Helper methods

- (BOOL)canHideDebuggerWhenOpeningInterfaceFile {
	return (!self.isDebugging || ![SPPreferences sharedPreferences].dontHideDebuggerWhileDebuggingWhenOpeningInterfaceFile);
}

- (BOOL)canHideDebuggerWhenTypingBegins {
	return (!self.isDebugging || ![SPPreferences sharedPreferences].dontHideDebuggerWhileDebuggingWhenTypingBegins);
}

@end
