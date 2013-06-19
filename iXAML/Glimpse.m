#import "Glimpse.h"
#import "GlimpseVersion.h"

@implementation Glimpse

+ (NSInteger)majorVersion {
    return [[[GlimpseVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
}

+ (NSInteger)minorVersion {
    return [[[GlimpseVersion componentsSeparatedByString:@"."] objectAtIndex:1] intValue];
}

+ (NSInteger)bugfixVersion {
    return [[[GlimpseVersion componentsSeparatedByString:@"."] objectAtIndex:2] intValue];
}

+ (NSInteger)hotfixVersion {
    NSArray *components = [GlimpseVersion componentsSeparatedByString:@"."];
    if ([components count] > 3) {
        return [[components objectAtIndex:3] intValue];

    } else {
        return 0;
    }
}

+ (NSString *)version {
    return GlimpseVersion;
}

@end
