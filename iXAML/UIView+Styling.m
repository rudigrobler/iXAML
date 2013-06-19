#import <QuartzCore/QuartzCore.h>
#import "UIView+Styling.h"
#import "UIColor+Extensions.h"
#import "UIApplication+Styling.h"
#import "UIFont+Extensions.h"
#import "iXStyle.h"
#import <objc/runtime.h>

@implementation UIView (Style)

- (void)setStyle:(NSString *)style {
    objc_setAssociatedObject(self, @"___style", style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    dispatch_async(dispatch_get_main_queue(), ^{
        [self applyStyle];
    });
}

- (NSString *)style {
    return objc_getAssociatedObject(self, @"___style");
}

- (void)applyStyle:(iXStyle*)style {
    if (style) {        
        for (NSString *property in style.keyEnumerator) {
            NSString *value = [style valueForKey:property];
            NSString *className = NSStringFromClass([self class]);

            if ([className isEqualToString:@"UIView"])
            {
                CALayer *layer = [self layer];
                if ([property isEqualToString:@"background-color"])
                {
                    [layer setBackgroundColor:[UIColor colorFromString:value].CGColor];
                }
            }
            else if ([className isEqualToString:@"UIButton"])
            {
                CALayer *layer = [self layer];
                if ([property isEqualToString:@"background-color"])
                {
                    [layer setBackgroundColor:[UIColor colorFromString:value].CGColor];
                }
                else if ([property isEqualToString:@"text-color"])
                {
                    UIButton *button = (UIButton*)self;
                    [button.titleLabel setTextColor:[UIColor colorFromString:value]];
                }
                else if ([property isEqualToString:@"font"])
                {
                    UIButton *button = (UIButton*)self;
                    [button.titleLabel setFont:[UIFont fontWithNameAndSize:value]];
                }
                else if ([property isEqualToString:@"border-color"])
                {
                    [layer setBorderColor:[UIColor colorFromString:value].CGColor];
                }
                else if ([property isEqualToString:@"border-width"])
                {
                    [layer setBorderWidth:[value floatValue]];
                }
                else if ([property isEqualToString:@"corner-radius"])
                {
                    [layer setCornerRadius:[value floatValue]];
                }
            }
            else if ([className isEqualToString:@"UILabel"])
            {
                CALayer *layer = [self layer];
                if ([property isEqualToString:@"background-color"])
                {
                    [layer setBackgroundColor:[UIColor colorFromString:value].CGColor];
                }
                else if ([property isEqualToString:@"text-color"])
                {
                    UILabel *label = (UILabel*)self;
                    [label setTextColor:[UIColor colorFromString:value]];
                }
                else if ([property isEqualToString:@"font"])
                {
                    UILabel *label = (UILabel*)self;
                    [label setFont:[UIFont fontWithNameAndSize:value]];
                }
            }
            else
            {
                NSLog(@"%@", className);
            }            
        }
    }
}

- (void)applyStyle {
    NSString *styleName = [self style];
    if (styleName) {
        iXStylesheet *stylesheet = [UIApplication sharedApplication].stylesheet;
        if (stylesheet) {
            iXStyle *style = [stylesheet valueForKey:styleName];
            [self applyStyle:style];
        }
    }
}

@end
