//
//  NSString+ATPermission.m
//  ATPermission
//
//  Created by ablett on 2019/5/16.
//

#import "NSString+ATPermission.h"
#import "NSBundle+ATPermission.h"

@implementation NSString (ATPermission)

- (NSString *)at_localized {
    return [NSBundle at_localizedStringForKey:self];
}

@end
