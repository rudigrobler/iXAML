#import "UIFont+Extensions.h"
#import <CoreText/CoreText.h>

@implementation UIFont (Extensions)

+ (void) registerCustomFonts
{
    NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"ttf" inDirectory:nil];

    for (NSString *path in paths)
    {
        CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)path, kCFURLPOSIXPathStyle, false);
        CGDataProviderRef dataProvider = CGDataProviderCreateWithURL(url);
        CGFontRef font = CGFontCreateWithDataProvider(dataProvider);
        CTFontManagerRegisterGraphicsFont(font, nil);
        CGFontRelease(font);
        CGDataProviderRelease(dataProvider);
        CFRelease(url);
    }
}


+ (UIFont *) fontWithNameAndSize:(NSString *)nameAndSize
{
    static NSMutableArray *fontNames = nil;

    if (fontNames == nil)
    {
        fontNames = [[NSMutableArray alloc] init];

        for (NSString *familyName in [UIFont familyNames])
        {
            for (NSString *fontName in [UIFont fontNamesForFamilyName : familyName])
            {
                [fontNames addObject:fontName];
            }
        }
    }

    for (NSString *fontName in fontNames)
    {
        NSRange range = [nameAndSize rangeOfString:fontName];

        if (range.length > 0)
        {
            if (nameAndSize.length == range.length)
            {
                return [UIFont fontWithName:nameAndSize size:[UIFont systemFontSize]];
            }
            else if (range.location > 0)
            {
                float fontSize = [[[[nameAndSize substringToIndex:range.location] stringByReplacingOccurrencesOfString:@"px" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] floatValue];

                if (fontSize > 0)
                {
                    return [UIFont fontWithName:fontName size:fontSize];
                }
            }
            else
            {
                float fontSize = [[[[nameAndSize substringFromIndex:range.length] stringByReplacingOccurrencesOfString:@"px" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] floatValue];

                if (fontSize > 0)
                {
                    return [UIFont fontWithName:fontName size:fontSize];
                }
            }

            return [UIFont fontWithName:nameAndSize size:[UIFont systemFontSize]];
        }
    }

    return [UIFont systemFontOfSize:[UIFont systemFontSize]];
}


@end
