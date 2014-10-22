//
//  NSTextView+DVTSourceTextView.m
//  DBSmartPanels
//
//  Created by Dave Blundell on 10/22/14.
//  Copyright (c) 2014 Dave Blundell. All rights reserved.
//

#import "NSTextView+DVTSourceTextView.h"

@implementation NSTextView (DVTSourceTextView)

- (BOOL)isInPopupWindow {
	NSView *superview = self.superview;
	while (superview != nil) {
		if ([superview isKindOfClass:NSClassFromString(@"DVTHUDPopUpView")]) {
			return YES;
		}
		superview = superview.superview;
	}
	return NO;
}

@end
