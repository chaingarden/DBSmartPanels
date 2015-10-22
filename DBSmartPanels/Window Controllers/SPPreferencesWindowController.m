//
//  SPPreferencesWindowController.m
//  DBSmartPanels
//
//  Created by Dave Blundell on 10/19/14.
//  Copyright (c) 2014 Dave Blundell. All rights reserved.
//

#import "SPPreferencesWindowController.h"
#import "SPPreferences.h"

@interface SPPreferencesWindowController ()

@property (nonatomic, strong) IBOutlet NSPopUpButton *behaviorPopUpButton;
@property (nonatomic, strong) IBOutlet NSTextField *behaviorExplanationTextField;

@property (nonatomic, strong) IBOutlet NSButton *hideDebuggerWhenTypingBeginsButton;
@property (nonatomic, strong) IBOutlet NSButton *dontHideDebuggerWhileDebuggingWhenTypingBeginsButton;
@property (nonatomic, strong) IBOutlet NSButton *hideNavigatorWhenTypingBeginsButton;
@property (nonatomic, strong) IBOutlet NSButton *hideUtilitiesWhenTypingBeginsButton;

@property (nonatomic, strong) IBOutlet NSButton *restoreEditorModeWhenOpeningTextDocumentButton;
@property (nonatomic, strong) IBOutlet NSButton *restoreDebuggerWhenOpeningTextDocumentButton;
@property (nonatomic, strong) IBOutlet NSButton *hideNavigatorWhenOpeningTextDocumentButton;
@property (nonatomic, strong) IBOutlet NSButton *hideUtilitiesWhenOpeningTextDocumentButton;

@property (nonatomic, strong) IBOutlet NSButton *switchToStandardEditorModeWhenOpeningInterfaceFileButton;
@property (nonatomic, strong) IBOutlet NSButton *hideDebuggerWhenOpeningInterfaceFileButton;
@property (nonatomic, strong) IBOutlet NSButton *dontHideDebuggerWhileDebuggingWhenOpeningInterfaceFileButton;
@property (nonatomic, strong) IBOutlet NSButton *hideNavigatorWhenOpeningInterfaceFileButton;
@property (nonatomic, strong) IBOutlet NSButton *showUtilitiesWhenOpeningInterfaceFileButton;

@end

@implementation SPPreferencesWindowController

#pragma mark - Window lifecycle

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // load preferences
	[self loadSetupOptions];
    [self updateUI];
}

#pragma mark - Initial load

- (void)loadSetupOptions {
	[self.behaviorPopUpButton removeAllItems];
    
    NSMutableArray *behaviorTitles = [NSMutableArray arrayWithCapacity:SPAutohidingNumBehaviors];
    for (NSInteger numBehavior = 0; numBehavior < SPAutohidingNumBehaviors; numBehavior++) {
        [behaviorTitles addObject:[SPPreferences titleForAutohidingBehavior:numBehavior]];
    }
    
	[self.behaviorPopUpButton addItemsWithTitles:behaviorTitles];
}

- (void)updateUI {
    SPPreferences *sharedPrefs = [SPPreferences sharedPreferences];
    
    if (sharedPrefs.autohidingBehavior < self.behaviorPopUpButton.numberOfItems) {
        [self.behaviorPopUpButton selectItemAtIndex:sharedPrefs.autohidingBehavior];
    }
    [self updateAutohidingBehaviorExplanation];
    
    self.hideDebuggerWhenTypingBeginsButton.state = sharedPrefs.hideDebuggerWhenTypingBegins ? NSOnState : NSOffState;
	self.dontHideDebuggerWhileDebuggingWhenTypingBeginsButton.state = sharedPrefs.dontHideDebuggerWhileDebuggingWhenTypingBegins ? NSOnState : NSOffState;
	self.hideNavigatorWhenTypingBeginsButton.state = sharedPrefs.hideNavigatorWhenTypingBegins ? NSOnState : NSOffState;
	self.hideUtilitiesWhenTypingBeginsButton.state = sharedPrefs.hideUtilitiesWhenTypingBegins ? NSOnState : NSOffState;
    
    self.restoreEditorModeWhenOpeningTextDocumentButton.state = sharedPrefs.restoreEditorModeWhenOpeningTextDocument ? NSOnState : NSOffState;
    self.restoreDebuggerWhenOpeningTextDocumentButton.state = sharedPrefs.restoreDebuggerWhenOpeningTextDocument ? NSOnState : NSOffState;
	self.hideNavigatorWhenOpeningTextDocumentButton.state = sharedPrefs.hideNavigatorWhenOpeningTextDocument ? NSOnState : NSOffState;
	self.hideUtilitiesWhenOpeningTextDocumentButton.state = sharedPrefs.hideUtilitiesWhenOpeningTextDocument ? NSOnState : NSOffState;
    
    self.switchToStandardEditorModeWhenOpeningInterfaceFileButton.state = sharedPrefs.switchToStandardEditorModeWhenOpeningInterfaceFile ? NSOnState : NSOffState;
	self.hideDebuggerWhenOpeningInterfaceFileButton.state = sharedPrefs.hideDebuggerWhenOpeningInterfaceFile ? NSOnState : NSOffState;
	self.dontHideDebuggerWhileDebuggingWhenOpeningInterfaceFileButton.state = sharedPrefs.dontHideDebuggerWhileDebuggingWhenOpeningInterfaceFile ? NSOnState : NSOffState;
	self.hideNavigatorWhenOpeningInterfaceFileButton.state = sharedPrefs.hideNavigatorWhenOpeningInterfaceFile ? NSOnState : NSOffState;
	self.showUtilitiesWhenOpeningInterfaceFileButton.state = sharedPrefs.showUtilitiesWhenOpeningInterfaceFile ? NSOnState : NSOffState;
	
	self.dontHideDebuggerWhileDebuggingWhenTypingBeginsButton.enabled = sharedPrefs.hideDebuggerWhenTypingBegins;
	self.dontHideDebuggerWhileDebuggingWhenOpeningInterfaceFileButton.enabled = sharedPrefs.hideDebuggerWhenOpeningInterfaceFile;
}

- (void)updateAutohidingBehaviorExplanation {
    SPPreferences *sharedPrefs = [SPPreferences sharedPreferences];
    
    [self.behaviorExplanationTextField setStringValue:[SPPreferences explanationForAutohidingBehavior:sharedPrefs.autohidingBehavior]];
}

#pragma mark - Actions

- (IBAction)autohidingBehaviorPopUpButtonValueChanged:(id)sender {
    SPPreferences *sharedPrefs = [SPPreferences sharedPreferences];
    sharedPrefs.autohidingBehavior = self.behaviorPopUpButton.indexOfSelectedItem;
    
    [self updateUI];
}

- (IBAction)hideDebuggerWhenTypingBeginsButtonPressed:(id)sender {
    if (![sender isKindOfClass:[NSButton class]]) return;
    [SPPreferences sharedPreferences].hideDebuggerWhenTypingBegins = (((NSButton *)sender).state == NSOnState);
	
	self.dontHideDebuggerWhileDebuggingWhenTypingBeginsButton.enabled = [SPPreferences sharedPreferences].hideDebuggerWhenTypingBegins;
}

- (IBAction)dontHideDebuggerWhileDebuggingWhenTypingBeginsButtonPressed:(id)sender {
	if (![sender isKindOfClass:[NSButton class]]) return;
	[SPPreferences sharedPreferences].dontHideDebuggerWhileDebuggingWhenTypingBegins = (((NSButton *)sender).state == NSOnState);
}

- (IBAction)hideNavigatorWhenTypingBeginsButtonPressed:(id)sender {
	if (![sender isKindOfClass:[NSButton class]]) return;
	[SPPreferences sharedPreferences].hideNavigatorWhenTypingBegins = (((NSButton *)sender).state == NSOnState);
}

- (IBAction)hideUtilitiesWhenTypingBeginsButtonPressed:(id)sender {
    if (![sender isKindOfClass:[NSButton class]]) return;
    [SPPreferences sharedPreferences].hideUtilitiesWhenTypingBegins = (((NSButton *)sender).state == NSOnState);
}

- (IBAction)restoreEditorModeWhenOpeningTextDocumentButtonPressed:(id)sender {
    if (![sender isKindOfClass:[NSButton class]]) return;
    [SPPreferences sharedPreferences].restoreEditorModeWhenOpeningTextDocument = (((NSButton *)sender).state == NSOnState);
}

- (IBAction)restoreDebuggerWhenOpeningTextDocumentButtonPressed:(id)sender {
    if (![sender isKindOfClass:[NSButton class]]) return;
    [SPPreferences sharedPreferences].restoreDebuggerWhenOpeningTextDocument = (((NSButton *)sender).state == NSOnState);
}

- (IBAction)hideNavigatorWhenOpeningTextDocumentButtonPressed:(id)sender {
	if (![sender isKindOfClass:[NSButton class]]) return;
	[SPPreferences sharedPreferences].hideNavigatorWhenOpeningTextDocument = (((NSButton *)sender).state == NSOnState);
}

- (IBAction)hideUtilitiesWhenOpeningTextDocumentButtonPressed:(id)sender {
    if (![sender isKindOfClass:[NSButton class]]) return;
    [SPPreferences sharedPreferences].hideUtilitiesWhenOpeningTextDocument = (((NSButton *)sender).state == NSOnState);
}

- (IBAction)switchToStandardEditorModeWhenOpeningInterfaceFileButtonPressed:(id)sender {
    if (![sender isKindOfClass:[NSButton class]]) return;
    [SPPreferences sharedPreferences].switchToStandardEditorModeWhenOpeningInterfaceFile = (((NSButton *)sender).state == NSOnState);
}

- (IBAction)hideDebuggerWhenOpeningInterfaceFileButtonPressed:(id)sender {
    if (![sender isKindOfClass:[NSButton class]]) return;
    [SPPreferences sharedPreferences].hideDebuggerWhenOpeningInterfaceFile = (((NSButton *)sender).state == NSOnState);
	
	self.dontHideDebuggerWhileDebuggingWhenOpeningInterfaceFileButton.enabled = [SPPreferences sharedPreferences].hideDebuggerWhenOpeningInterfaceFile;
}

- (IBAction)dontHideDebuggerWhileDebuggingWhenOpeningInterfaceFileButtonPressed:(id)sender {
	if (![sender isKindOfClass:[NSButton class]]) return;
	[SPPreferences sharedPreferences].dontHideDebuggerWhileDebuggingWhenOpeningInterfaceFile = (((NSButton *)sender).state == NSOnState);
}

- (IBAction)hideNavigatorWhenOpeningInterfaceFileButtonPressed:(id)sender {
	if (![sender isKindOfClass:[NSButton class]]) return;
	[SPPreferences sharedPreferences].hideNavigatorWhenOpeningInterfaceFile = (((NSButton *)sender).state == NSOnState);
}

- (IBAction)showUtilitiesWhenOpeningInterfaceFileButtonPressed:(id)sender {
    if (![sender isKindOfClass:[NSButton class]]) return;
    [SPPreferences sharedPreferences].showUtilitiesWhenOpeningInterfaceFile = (((NSButton *)sender).state == NSOnState);
}

@end
