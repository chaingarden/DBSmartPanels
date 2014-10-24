//
//  NSView+Utilities.m
//  DBSmartPanels
//
//  Created by Dave Blundell on 10/23/14.
//  Copyright (c) 2014 Dave Blundell. All rights reserved.
//

#import "NSView+Utilities.h"

@implementation NSView (Utilities)

- (BOOL)containsSubview:(NSView *)subview {
	if (!subview) return NO;
	
	for (NSView *view in self.subviews) {
		if (view == subview || [view containsSubview:subview]) {
			return YES;
		}
	}
	
	return NO;
}

@end
