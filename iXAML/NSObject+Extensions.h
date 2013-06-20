#import <Foundation/Foundation.h>

@class NSObject;

@interface NSObject (Extensions)

+ (BOOL)swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError **)error_;

@end