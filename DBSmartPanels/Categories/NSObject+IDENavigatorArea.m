//
//  NSObject+IDENavigatorArea.m
//  DBSmartPanels
//
//  Created by David Blundell on 10/19/15.
//  Copyright © 2015 Dave Blundell. All rights reserved.
//

#import "NSObject+IDENavigatorArea.h"

@implementation NSObject (IDENavigatorArea)

- (SPIDENavigatorMode)currentMode {
    if ([self.currentNavigatorIdentifier isEqualToString:@"Xcode.IDEKit.Navigator.Structure"]) {
        return SPIDENavigatorModeProject;
    } else if ([self.currentNavigatorIdentifier isEqualToString:@"Xcode.IDEKit.Navigator.Symbol"]) {
        return SPIDENavigatorModeSymbol;
    } else if ([self.currentNavigatorIdentifier isEqualToString:@"Xcode.IDEKit.Navigator.BatchFind"]) {
        return SPIDENavigatorModeFind;
    } else if ([self.currentNavigatorIdentifier isEqualToString:@"Xcode.IDEKit.Navigator.Issues"]) {
        return SPIDENavigatorModeIssue;
    } else if ([self.currentNavigatorIdentifier isEqualToString:@"Xcode.IDEKit.Navigator.Test"]) {
        return SPIDENavigatorModeTest;
    } else if ([self.currentNavigatorIdentifier isEqualToString:@"Xcode.IDEKit.Navigator.Debug"]) {
        return SPIDENavigatorModeDebug;
    } else if ([self.currentNavigatorIdentifier isEqualToString:@"Xcode.IDEKit.Navigator.Breakpoints"]) {
        return SPIDENavigatorModeBreakpoint;
    } else if ([self.currentNavigatorIdentifier isEqualToString:@"Xcode.IDEKit.Navigator.Logs"]) {
        return SPIDENavigatorModeReport;
    }
    
    return SPIDENavigatorModeUnknown;
}

@end
