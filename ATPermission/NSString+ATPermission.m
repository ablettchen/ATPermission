//
//  NSString+ATPermission.m
//  ATPermission
//
//  Created by ablett on 2019/5/16.
//

#import "NSString+ATPermission.h"
#import "ATPermission.h"
#import <ATCategories/ATCategories.h>

@implementation NSString (ATPermission)

- (NSString *)at_localized {
    NSBundle *permissionBundle = [NSBundle at_bundleForClass:[ATPermission class] resource:@"ATPermission" ofType:@"bundle"];
    NSString *ss = [permissionBundle at_localizedStringForKey:self language:@"zh-Hans"];
    return ss;
}

@end
