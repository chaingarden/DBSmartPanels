//
//  NSObject+IDENavigatorArea.h
//  DBSmartPanels
//
//  Created by David Blundell on 10/19/15.
//  Copyright © 2015 Dave Blundell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+XCRuntimeSupport.h"

@interface NSObject (IDENavigatorArea) <IDENavigatorArea>

- (SPIDENavigatorMode)currentMode;

@end
