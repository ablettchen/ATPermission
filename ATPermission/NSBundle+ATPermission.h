//
//  NSBundle+ATPermission.h
//  ATPermission
//
//  Created by ablett on 2019/5/16.
//

#import <Foundation/Foundation.h>

@interface NSBundle (ATPermission)
+ (instancetype)at_permissionBundle;
+ (NSString *)at_localizedStringForKey:(NSString *)key;
+ (NSString *)at_localizedStringForKey:(NSString *)key value:(NSString *)value;
@end
