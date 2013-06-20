#import <Foundation/Foundation.h>

@class NSObject;

@interface Glimpse : NSObject

+ (NSString *)version;

+ (NSInteger)majorVersion;

+ (NSInteger)minorVersion;

+ (NSInteger)bugfixVersion;

+ (NSInteger)hotfixVersion;

@end