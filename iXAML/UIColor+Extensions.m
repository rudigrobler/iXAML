#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

+ (UIColor *)colorFromString:(NSString *)str {
    unsigned rgbValue = 0;
    str = [str stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:str];

    [scanner scanHexInt:&rgbValue];

    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0 green:((rgbValue & 0xFF00) >> 8) / 255.0 blue:(rgbValue & 0xFF) / 255.0 alpha:1.0];
}

@end
