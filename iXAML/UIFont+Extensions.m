#import <CoreText/CoreText.h>
#import "UIFont+Extensions.h"

@implementation UIFont (CustomFonts)

+ (void)registerCustomFonts {
    NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"ttf" inDirectory:nil];
    for (NSString *path in paths) {
        CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef) path, kCFURLPOSIXPathStyle, false);
        CGDataProviderRef dataProvider = CGDataProviderCreateWithURL(url);
        CGFontRef font = CGFontCreateWithDataProvider(dataProvider);
        CTFontManagerRegisterGraphicsFont(font, nil);
        CGFontRelease(font);
        CGDataProviderRelease(dataProvider);
        CFRelease(url);
    }
}

+ (UIFont*)fontWithNameAndSize:(NSString*)nameAndSize {
    static NSMutableArray *fontNames = nil;
    if (fontNames == nil)
    {
        fontNames = [[NSMutableArray alloc] init];
        for (NSString *familyName in [UIFont familyNames]) {
            for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
                [fontNames addObject:fontName];
            }
        }
    }
    
    // TODO: Should we ignore case?
    for (NSString *fontName in fontNames) {
        NSRange range = [nameAndSize rangeOfString:fontName];
        if (range.length > 0)
        {
            if (nameAndSize.length == range.length)
            {
                return [UIFont fontWithName:nameAndSize size:[UIFont systemFontSize]];
            }
            else if (range.location > 0)
            {
                // TODO: strip px - ie. "22px SegeoUI-Light"
                NSInteger fontSize = [[[nameAndSize substringToIndex:range.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] integerValue];
                
                if (fontSize > 0)
                {
                    return [UIFont fontWithName:nameAndSize size:[UIFont systemFontSize]];
                }
            }
            else
            {
                // TODO: strip px - ie. "SegeoUI-Light 22px"
                NSInteger fontSize = [[[nameAndSize substringFromIndex:range.length] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] integerValue];
                
                if (fontSize > 0)
                {
                    return [UIFont fontWithName:nameAndSize size:[UIFont systemFontSize]];
                }
            }
        }
    }

    return [UIFont systemFontOfSize:[UIFont systemFontSize]];
}

@end
