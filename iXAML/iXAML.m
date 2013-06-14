#import "iXAML.h"
#import "iXAMLVersion.h"

@implementation iXAML

+ (NSInteger)majorVersion {
  return [[[iXAMLVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
}

+ (NSInteger)minorVersion {
  return [[[iXAMLVersion componentsSeparatedByString:@"."] objectAtIndex:1] intValue];
}

+ (NSInteger)bugfixVersion {
  return [[[iXAMLVersion componentsSeparatedByString:@"."] objectAtIndex:2] intValue];
}

+ (NSInteger)hotfixVersion {
  NSArray* components = [iXAMLVersion componentsSeparatedByString:@"."];
  if ([components count] > 3) {
    return [[components objectAtIndex:3] intValue];

  } else {
    return 0;
  }
}

+ (NSString*)version {
  return iXAMLVersion;
}

@end
