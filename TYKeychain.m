//
//  TYKeychain.m
//  YKeychainDemo
//
//  Created by 戴晨惜 on 2016/10/24.
//  Copyright © 2016年 dcx. All rights reserved.
//

#import "TYKeychain.h"

@implementation TYKeychain

+ (BOOL)saveValue:(id)value forKey:(NSString *)keyStr {
    return [self saveValue:value forKey:keyStr forAccessGroup:nil];
}

+ (BOOL)saveValue:(id)value forKey:(NSString *)keyStr forAccessGroup:(NSString *)groupStr {
    
    NSMutableDictionary *query = [self keychainQuery:keyStr forAccessGroup:groupStr];
    
    [self deleteValueForKey:keyStr forAccessGroup:groupStr];
    
    NSData *data = nil;
    
    @try {
        
        data = [NSKeyedArchiver archivedDataWithRootObject:value];
        
    } @catch (NSException *exception) {
        
        NSLog(@"archived failure value %@  %@",value,exception);
        
        return NO;
    }
    
    [query setObject:data forKey:(__bridge id)kSecValueData];
    
    OSStatus result = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    
    return result == errSecSuccess;
}

+ (BOOL)deleteValueForKey:(NSString *)keyStr {
    return [self deleteValueForKey:keyStr forAccessGroup:nil];
}

+ (BOOL)deleteValueForKey:(NSString *)keyStr forAccessGroup:(NSString *)groupStr {
    NSMutableDictionary *query = [self keychainQuery:keyStr forAccessGroup:groupStr];
    OSStatus result = SecItemDelete((__bridge CFDictionaryRef)query);
    return result == errSecSuccess;
}

+ (id)loadValueForKey:(NSString *)keyStr {
    return [self loadValueForKey:keyStr forAccessGroup:nil];
}

+ (id)loadValueForKey:(NSString *)keyStr forAccessGroup:(NSString *)groupStr {
    
    id value = nil;
    
    NSMutableDictionary *query = [self keychainQuery:keyStr forAccessGroup:groupStr];
    
    CFDataRef keyData = NULL;
    
    [query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&keyData) == errSecSuccess) {
        
        @try {
            
            value = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
            
        }
        @catch (NSException *e) {
            
            NSLog(@"Unarchive of %@ failed: %@", keyStr, e);
            
            value = nil;
        }
        @finally {
        }
    }
    if (keyData) {
        CFRelease(keyData);
    }
    return value;
}

#pragma mark - help 

+ (NSMutableDictionary *)keychainQuery:(NSString *)keyStr forAccessGroup:(NSString *)groupStr {
    
    if (keyStr) {
        NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                              keyStr,(__bridge_transfer id)kSecAttrService,
                                              keyStr,(__bridge_transfer id)kSecAttrAccount,
                                              (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
                                              (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
                                              nil];

        if (groupStr != nil)
        {
#if TARGET_OS_IPHONE
            [keychainQuery setObject:[self getKeychainAccessGroup:groupStr] forKey:(__bridge id)kSecAttrAccessGroup];
#endif
        }
        return keychainQuery;
    }
    return nil;
}

+ (NSString *)getKeychainAccessGroup:(NSString *)groupStr {
    
    NSString * keychainAccessGroup = nil;
    
    if (!groupStr) {
        
        return keychainAccessGroup;
        
    }
    NSString * bundleSeedID = [self getBundleSeedID];
    
    if (!bundleSeedID) {
        
        return keychainAccessGroup;
        
    }
    keychainAccessGroup = [NSString stringWithFormat:@"%@.%@",bundleSeedID,groupStr];
    
    return keychainAccessGroup;
}

+ (NSString *)getBundleSeedID {
    
    NSString * bundleSeedID = nil;
    
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)(kSecClassGenericPassword), kSecClass,
                           @"bundleSeedID", kSecAttrAccount,
                           @"", kSecAttrService,
                           (id)kCFBooleanTrue, kSecReturnAttributes,
                           nil];
    
    CFDictionaryRef result = nil;
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    
    if (status == errSecItemNotFound) {
        
        status = SecItemAdd((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    }
    if (status != errSecSuccess){
        
        return nil;
    }
    NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge id)(kSecAttrAccessGroup)];
    
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    
    bundleSeedID = [[components objectEnumerator] nextObject];
    
    CFRelease(result);
    
    return bundleSeedID;
}

@end

@implementation TYKeychain (TuYooKeychain)

+ (BOOL)save:(NSString *)keyStr data:(id)data {
    
    if ([keyStr isEqualToString:kTUYOO_GROUP_KEYCHAIN_UUIDKEY]) {
        
        return [self saveValue:data forKey:keyStr forAccessGroup:kTUYOO_KEYCHAIN_GROUP];
        
    }
    return [self saveValue:data forKey:keyStr];
}
+ (id)load:(NSString *)keyStr {
    
    if ([keyStr isEqualToString:kTUYOO_GROUP_KEYCHAIN_UUIDKEY]) {
        
        return [self loadValueForKey:keyStr forAccessGroup:kTUYOO_KEYCHAIN_GROUP];
    
    }
    return [self loadValueForKey:keyStr];
}

+ (BOOL)deleteForKey:(NSString *)keyStr {
    if ([keyStr isEqualToString:kTUYOO_GROUP_KEYCHAIN_UUIDKEY]) {
        return [self deleteValueForKey:keyStr forAccessGroup:kTUYOO_KEYCHAIN_GROUP];
    }
    return [self deleteValueForKey:keyStr];
}

@end
