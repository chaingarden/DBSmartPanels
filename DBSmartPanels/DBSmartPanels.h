//
//  DBSmartPanels.h
//  DBSmartPanels
//
//  Created by Dave Blundell on 10/16/14.
//  Copyright (c) 2014 Dave Blundell. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface DBSmartPanels : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle *bundle;

@end
