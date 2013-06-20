#import "UIColor+Extensions.h"
#import "UIFont+Extensions.h"
#import "UILabel+Styling.h"
#import <QuartzCore/QuartzCore.h>

@implementation UILabel (Styling)

+ (void)applyStyle:(iXStyle *)style {
    if (style) {
        for (NSString *property in style.keyEnumerator) {
            NSString *value = [style valueForKey:property];

            if ([property isEqualToString:@"style-name"]) {
            }
            else if ([property isEqualToString:@"background-color"]) {
                [[UILabel appearance] setBackgroundColor:[UIColor colorFromString:value]];
            }
            else if ([property isEqualToString:@"border-color"]) {
            }
            else if ([property isEqualToString:@"border-width"]) {
            }
            else if ([property isEqualToString:@"corner-radius"]) {
            }
            else if ([property isEqualToString:@"text-color"]) {
                [[UILabel appearance] setTextColor:[UIColor colorFromString:value]];
            }
            else if ([property isEqualToString:@"font"]) {
                [[UILabel appearance] setFont:[UIFont fontWithNameAndSize:value]];
            }
            else {
                NSLog(@"'%@' not found on '%@'", property, NSStringFromClass([self class]));
            }
        }
    }
}

- (void)applyStyle:(iXStyle *)style {
    if (style) {
        for (NSString *property in style.keyEnumerator) {
            NSString *value = [style valueForKey:property];

            if ([property isEqualToString:@"style-name"]) {
            }
            else if ([property isEqualToString:@"background-color"]) {
                [self setBackgroundColor:[UIColor colorFromString:value]];
            }
            else if ([property isEqualToString:@"border-color"]) {
                [self.layer setBorderColor:[UIColor colorFromString:value].CGColor];
            }
            else if ([property isEqualToString:@"border-width"]) {
                [self.layer setBorderWidth:[value floatValue]];
            }
            else if ([property isEqualToString:@"corner-radius"]) {
                [self.layer setCornerRadius:[value floatValue]];
            }
            else if ([property isEqualToString:@"text-color"]) {
                [self setTextColor:[UIColor colorFromString:value]];
            }
            else if ([property isEqualToString:@"font"]) {
                [self setFont:[UIFont fontWithNameAndSize:value]];
            }
            else {
                NSLog(@"'%@' not found on '%@'", property, NSStringFromClass([self class]));
            }
        }
    }
}

@end
