#import <Foundation/Foundation.h>

@interface Glimpse : NSObject

+ (NSString *)version;

+ (NSInteger)majorVersion;

+ (NSInteger)minorVersion;

+ (NSInteger)bugfixVersion;

+ (NSInteger)hotfixVersion;

@end