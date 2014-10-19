//
//  NSMenu+Utilities.h
//  DBSmartPanels
//
//  Created by Dave Blundell on 10/19/14.
//  Copyright (c) 2014 David Blundell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSMenu (Utilities)

- (void)insertItem:(NSMenuItem *)newItem afterItemWithTitle:(NSString *)title;

@end
