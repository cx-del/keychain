# keychain

``
#define kKEYCHAIN_GROUP             @"xx.xx"

``
kKEYCHAIN_GROUP 改为对应的组名

用法

```
//查
+ (id)loadValueForKey:(NSString *)keyStr;
+ (id)loadValueForKey:(NSString *)keyStr forAccessGroup:(NSString *)groupStr;
//删
+ (BOOL)deleteValueForKey:(NSString *)keyStr;
+ (BOOL)deleteValueForKey:(NSString *)keyStr forAccessGroup:(NSString *)groupStr;
//增
+ (BOOL)saveValue:(id)value forKey:(NSString *)keyStr;
+ (BOOL)saveValue:(id)value forKey:(NSString *)keyStr forAccessGroup:(NSString *)groupStr;

```
