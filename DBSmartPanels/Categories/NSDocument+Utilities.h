//
//  NSDocument+Utilities.h
//  DBSmartPanels
//
//  Created by Dave Blundell on 10/21/14.
//  Copyright (c) 2014 Dave Blundell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum : NSUInteger {
    SPDocumentTypeText = 0,
    SPDocumentTypeInterface = 1,
    SPDocumentTypeUnknown = -1
} SPDocumentType;

@interface NSDocument (Utilities)

@property (nonatomic, readonly) SPDocumentType documentType;

@end
