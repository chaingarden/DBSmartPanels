//
//  NSMenu+Utilities.m
//  DBSmartPanels
//
//  Created by Dave Blundell on 10/19/14.
//  Copyright (c) 2014 Dave Blundell. All rights reserved.
//

#import "NSMenu+Utilities.h"

@implementation NSMenu (Utilities)

- (void)insertItem:(NSMenuItem *)newItem afterItemWithTitle:(NSString *)title {
    NSInteger index = [self indexOfItemWithTitle:title];
    
    // if the item isn't found, insert item at end
    if (index == -1 || index >= self.itemArray.count - 1) {
        [self addItem:newItem];
    } else {
        [self insertItem:newItem atIndex:index + 1];
    }
}

@end
