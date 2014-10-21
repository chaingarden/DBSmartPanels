//
//  NSDocument+Utilities.m
//  DBSmartPanels
//
//  Created by Dave Blundell on 10/21/14.
//  Copyright (c) 2014 Dave Blundell. All rights reserved.
//

#import "NSDocument+Utilities.h"

#define kTextDocumentFileExtensions @[@"h", @"m", @"c", @"cpp", @"txt", @"rtf"]
#define kInterfaceDocumentFileExtensions @[@"xib", @"storyboard"]

@implementation NSDocument (Utilities)

#pragma mark - Custom getters

- (SPDocumentType)documentType {
    NSString *fileExtension = [self fileExtension];
    
    if ([kTextDocumentFileExtensions containsObject:fileExtension]) {
        return SPDocumentTypeText;
    } else if ([kInterfaceDocumentFileExtensions containsObject:fileExtension]) {
        return SPDocumentTypeInterface;
    } else {
        return SPDocumentTypeUnknown;
    }
}

#pragma mark - Helper methods

- (NSString *)fileExtension {
    return [[[self fileURL].absoluteString componentsSeparatedByString:@"."] lastObject];
}

@end
