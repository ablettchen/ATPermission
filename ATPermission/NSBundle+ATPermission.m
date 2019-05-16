//
//  NSBundle+ATPermission.m
//  ATPermission
//
//  Created by ablett on 2019/5/16.
//

#import "NSBundle+ATPermission.h"
#import "ATPermission.h"

@implementation NSBundle (ATPermission)

+ (instancetype)at_permissionBundle {
    static NSBundle *permissionBundle = nil;
    if (permissionBundle == nil) {
        NSString *path = [[NSBundle bundleForClass:[ATPermission class]] pathForResource:@"ATPermission" ofType:@"bundle"];
        permissionBundle = [NSBundle bundleWithPath:path];
    }
    return permissionBundle;
}

+ (NSString *)at_localizedStringForKey:(NSString *)key {
    return [self at_localizedStringForKey:key value:nil];
}

+ (NSString *)at_localizedStringForKey:(NSString *)key value:(NSString *)value {
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *language = ATPermissionConfig.globalConfig.languageCode;
        if (!language) {language = [NSLocale preferredLanguages].firstObject;}
        
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        }else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans"; // 简体中文
            }
        }else {
            language = @"en";
        }

        bundle = [NSBundle bundleWithPath:[[NSBundle at_permissionBundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

@end
