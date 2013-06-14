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

@end
