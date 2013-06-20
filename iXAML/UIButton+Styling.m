#import "UIFont+Extensions.h"
#import "UIColor+Extensions.h"
#import "UIButton+Styling.h"

@implementation UIButton (Styling)

+ (void)applyStyle:(iXStyle *)style {
    if (style) {
        for (NSString *property in style.keyEnumerator) {
            NSString *value = [style valueForKey:property];

            if ([property isEqualToString:@"style-name"]) {

            }
            else if ([property isEqualToString:@"background-color"]) {
                [[UIButton appearance] setBackgroundColor:[UIColor colorFromString:value]];
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
                [[UIButton appearance] setFont:[UIFont fontWithNameAndSize:value]];
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
                [self.titleLabel setTextColor:[UIColor colorFromString:value]];
            }
            else if ([property isEqualToString:@"font"]) {
                [self.titleLabel setFont:[UIFont fontWithNameAndSize:value]];
            }
            else {
                NSLog(@"'%@' not found on '%@'", property, NSStringFromClass([self class]));
            }
        }
    }
}

@end
