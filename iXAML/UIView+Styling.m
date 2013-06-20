#import "UIApplication+Styling.h"
#import "UIButton+Styling.h"
#import "UIColor+Extensions.h"
#import "UILabel+Styling.h"
#import "UITextField+Styling.h"
#import "UIView+Styling.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Styling)

- (void)setStyle:(NSString *)style {
    objc_setAssociatedObject(self, @"___style", style, OBJC_ASSOCIATION_COPY_NONATOMIC);

    dispatch_barrier_async(dispatch_get_main_queue(), ^{
        [self applyStyle];
    });
}

- (NSString *)style {
    return objc_getAssociatedObject(self, @"___style");
}

- (void)applyStyle {
    NSString *style = [self style];
    if (style) {
        iXStylesheet *stylesheet = [UIApplication sharedApplication].stylesheet;
        if (stylesheet) {
            NSString *className = NSStringFromClass([self class]);

            if ([className isEqualToString:@"UIButton"]) {
                [((UIButton *) self) applyStyle:[stylesheet valueForKey:style]];
            }
            else if ([className isEqualToString:@"UILabel"]) {
                [((UILabel *) self) applyStyle:[stylesheet valueForKey:style]];
            }
            else if ([className isEqualToString:@"UITextField"]) {
                [((UITextField *) self) applyStyle:[stylesheet valueForKey:style]];
            }
            else if ([className isEqualToString:@"UIView"]) {
                [self applyStyle:[stylesheet valueForKey:style]];
            }
            else {
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
            else {
            }
        }
    }
}

@end
