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

@property (nonatomic, strong) IBOutlet NSButton *dontHideDebuggerWhileDebuggingButton;

@property (nonatomic, strong) IBOutlet NSButton *hideDebuggerWhenTypingBeginsButton;
@property (nonatomic, strong) IBOutlet NSButton *hideUtilitiesWhenTypingBeginsButton;

@property (nonatomic, strong) IBOutlet NSButton *restoreEditorModeWhenOpeningTextDocumentButton;
@property (nonatomic, strong) IBOutlet NSButton *restoreDebuggerWhenOpeningTextDocumentButton;
@property (nonatomic, strong) IBOutlet NSButton *hideUtilitiesWhenOpeningTextDocumentButton;

@property (nonatomic, strong) IBOutlet NSButton *switchToStandardEditorModeWhenOpeningInterfaceFileButton;
@property (nonatomic, strong) IBOutlet NSButton *hideDebuggerWhenOpeningInterfaceFileButton;
@property (nonatomic, strong) IBOutlet NSButton *showUtilitiesWhenOpeningInterfaceFileButton;

@end

@implementation SPPreferencesWindowController

#pragma mark - Window lifecycle

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // load preferences
    [self updateUI];
}

#pragma mark - Initial load

- (void)updateUI {
    SPPreferences *sharedPrefs = [SPPreferences sharedPreferences];
    
    self.dontHideDebuggerWhileDebuggingButton.state = sharedPrefs.dontHideDebuggerWhileDebugging ? NSOnState : NSOffState;
    
    self.hideDebuggerWhenTypingBeginsButton.state = sharedPrefs.hideDebuggerWhenTypingBegins ? NSOnState : NSOffState;
    self.hideUtilitiesWhenTypingBeginsButton.state = sharedPrefs.hideUtilitiesWhenTypingBegins ? NSOnState : NSOffState;
    
    self.restoreEditorModeWhenOpeningTextDocumentButton.state = sharedPrefs.restoreEditorModeWhenOpeningTextDocument ? NSOnState : NSOffState;
    self.restoreDebuggerWhenOpeningTextDocumentButton.state = sharedPrefs.restoreDebuggerWhenOpeningTextDocument ? NSOnState : NSOffState;
    self.hideUtilitiesWhenOpeningTextDocumentButton.state = sharedPrefs.hideUtilitiesWhenOpeningTextDocument ? NSOnState : NSOffState;
    
    self.switchToStandardEditorModeWhenOpeningInterfaceFileButton.state = sharedPrefs.switchToStandardEditorModeWhenOpeningInterfaceFile ? NSOnState : NSOffState;
    self.hideDebuggerWhenOpeningInterfaceFileButton.state = sharedPrefs.hideDebuggerWhenOpeningInterfaceFile ? NSOnState : NSOffState;
    self.showUtilitiesWhenOpeningInterfaceFileButton.state = sharedPrefs.showUtilitiesWhenOpeningInterfaceFile ? NSOnState : NSOffState;
}

#pragma mark - Actions

- (IBAction)dontHideDebuggerWhileDebuggingButtonPressed:(id)sender {
    if (![sender isKindOfClass:[NSButton class]]) return;
    [SPPreferences sharedPreferences].dontHideDebuggerWhileDebugging = (((NSButton *)sender).state == NSOnState);
}

- (IBAction)hideDebuggerWhenTypingBeginsButtonPressed:(id)sender {
    if (![sender isKindOfClass:[NSButton class]]) return;
    [SPPreferences sharedPreferences].hideDebuggerWhenTypingBegins = (((NSButton *)sender).state == NSOnState);
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
}

- (IBAction)showUtilitiesWhenOpeningInterfaceFileButtonPressed:(id)sender {
    if (![sender isKindOfClass:[NSButton class]]) return;
    [SPPreferences sharedPreferences].showUtilitiesWhenOpeningInterfaceFile = (((NSButton *)sender).state == NSOnState);
}

- (IBAction)restorePluginDefaultsButtonPressed:(id)sender {
    [[SPPreferences sharedPreferences] restoreDefaults];
    [self updateUI];
}

- (IBAction)restoreXcodeDefaultBehaviorButtonPressed:(id)sender {
    [[SPPreferences sharedPreferences] restoreXcodeBehavior];
    [self updateUI];
}

@end
