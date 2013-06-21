#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

+ (UIColor *) colorFromString:(NSString *)str
{
    if ([[str substringToIndex:1] isEqualToString:@"#"])
    {
        unsigned rgbValue = 0;
        str = [str stringByReplacingOccurrencesOfString:@"#" withString:@""];
        NSScanner *scanner = [NSScanner scannerWithString:str];

        [scanner scanHexInt:&rgbValue];

        return [UIColor colorWithRed:( (rgbValue & 0xFF0000) >> 16 ) / 255.0 green:( (rgbValue & 0xFF00) >> 8 ) / 255.0 blue:(rgbValue & 0xFF) / 255.0 alpha:1.0];
    }
    else
    {
        NSString *colorString = [str lowercaseString];

        if ([colorString isEqualToString:@"red"])
        {
            return [UIColor redColor];
        }
        else if ([colorString isEqualToString:@"blue"])
        {
            return [UIColor blueColor];
        }
        else if ([colorString isEqualToString:@"orange"])
        {
            return [UIColor orangeColor];
        }
        else if ([colorString isEqualToString:@"yellow"])
        {
            return [UIColor yellowColor];
        }
        else if ([colorString isEqualToString:@"brown"])
        {
            return [UIColor brownColor];
        }
        else if ([colorString isEqualToString:@"gray"])
        {
            return [UIColor grayColor];
        }
        else if ([colorString isEqualToString:@"green"])
        {
            return [UIColor greenColor];
        }
        else if ([colorString isEqualToString:@"purple"])
        {
            return [UIColor purpleColor];
        }
        else if ([colorString isEqualToString:@"magenta"])
        {
            return [UIColor magentaColor];
        }
        else if ([colorString isEqualToString:@"cyan"])
        {
            return [UIColor cyanColor];
        }
        else if ([colorString isEqualToString:@"cyan"])
        {
            return [UIColor whiteColor];
        }
    }

    return [UIColor blackColor];
}


@end
