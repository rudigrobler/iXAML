#import <UIKit/UIKit.h>

@interface UIFont (CustomFonts)

+ (void)registerCustomFonts;

+ (UIFont*)fontWithNameAndSize:(NSString*)nameAndSize;

@end
