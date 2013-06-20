#import "UIImage+Extensions.h"
#import "UIColor+Extensions.h"
#import "UINavigationBar+Styling.h"

@implementation UINavigationBar (Styling)

+ (void)applyStyle:(iXStyle *)style {
    if (style) {
        for (NSString *property in style.keyEnumerator) {
            NSString *value = [style valueForKey:property];

            if ([property isEqualToString:@"style-name"]) {
            }
            else if ([property isEqualToString:@"background-color"]) {
                [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromString:value] cornerRadius:0]
                                                   forBarMetrics:UIBarMetricsDefault & UIBarMetricsLandscapePhone];
            }
            else if ([property isEqualToString:@"border-color"]) {
            }
            else if ([property isEqualToString:@"border-width"]) {
            }
            else if ([property isEqualToString:@"corner-radius"]) {
            }
            else if ([property isEqualToString:@"text-color"]) {
            }
            else if ([property isEqualToString:@"font"]) {
            }
            else {
                NSLog(@"'%@' not found on '%@'", property, NSStringFromClass([self class]));
            }
        }
    }
}

@end
