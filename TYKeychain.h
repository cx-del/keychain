//
//  TYKeychain.h
//  YKeychainDemo
//
//  Created by 戴晨惜 on 2016/10/24.
//  Copyright © 2016年 dcx. All rights reserved.
//

#import <Foundation/Foundation.h>

//UUID存储时的Key值
#define k_GROUP_KEYCHAIN_KEY     @"xxgroupkey"

#define kKEYCHAIN_KEY           @"xxkey"

/** keychain groups 跟工程设置的组名对应起来 */
#define kKEYCHAIN_GROUP             @"xx.xx"


@interface TYKeychain : NSObject

+ (id)loadValueForKey:(NSString *)keyStr;
+ (id)loadValueForKey:(NSString *)keyStr forAccessGroup:(NSString *)groupStr;

+ (BOOL)deleteValueForKey:(NSString *)keyStr;
+ (BOOL)deleteValueForKey:(NSString *)keyStr forAccessGroup:(NSString *)groupStr;

+ (BOOL)saveValue:(id)value forKey:(NSString *)keyStr;
+ (BOOL)saveValue:(id)value forKey:(NSString *)keyStr forAccessGroup:(NSString *)groupStr;

+ (NSString *)getBundleSeedID;

@end

@interface TYKeychain(TuYooKeychain)

+ (BOOL)save:(NSString *)keyStr data:(id)data;
+ (BOOL)deleteForKey:(NSString *)keyStr;
+ (id)load:(NSString *)keyStr;

@end
