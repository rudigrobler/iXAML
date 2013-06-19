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

- (BOOL)updateLayer:(NSString*)property value:(NSString*)value {
    CALayer *layer = [self layer];
    if ([property isEqualToString:@"background-color"])
    {
        [layer setBackgroundColor:[UIColor colorFromString:value].CGColor];
        return YES;
    }
    else if ([property isEqualToString:@"border-color"])
    {
        [layer setBorderColor:[UIColor colorFromString:value].CGColor];
        return YES;
    }
    else if ([property isEqualToString:@"border-width"])
    {
        [layer setBorderWidth:[value floatValue]];
        return YES;
    }
    else if ([property isEqualToString:@"corner-radius"])
    {
        [layer setCornerRadius:[value floatValue]];
        return YES;
    }
    return NO;
}

- (void)applyStyle:(iXStyle*)style {
    if (style) {
        for (NSString *property in style.keyEnumerator) {
            NSString *value = [style valueForKey:property];
            NSString *className = NSStringFromClass([self class]);
            
            if ([self updateLayer:property value:value])
            {
                // Layer property...
            }
            else if ([className isEqualToString:@"UIButton"])
            {
                UIButton *button = (UIButton*)self;
                if ([property isEqualToString:@"text-color"])
                {
                    [button.titleLabel setTextColor:[UIColor colorFromString:value]];
                }
                else if ([property isEqualToString:@"font"])
                {
                    [button.titleLabel setFont:[UIFont fontWithNameAndSize:value]];
                }
                else
                {
                    NSLog(@"Property '%@' not found on '%@'", property, className);
                }
            }
            else if ([className isEqualToString:@"UILabel"])
            {
                UILabel *label = (UILabel*)self;
                if ([property isEqualToString:@"text-color"])
                {
                    [label setTextColor:[UIColor colorFromString:value]];
                }
                else if ([property isEqualToString:@"font"])
                {
                    [label setFont:[UIFont fontWithNameAndSize:value]];
                }
                else
                {
                    NSLog(@"Property '%@' not found on '%@'", property, className);
                }
            }
            else
            {
                NSLog(@"'%@' is not supported", className);
            }            
        }
    }
}

- (void)applyStyle {
    NSString *style = [self style];
    if (style) {
        iXStylesheet *stylesheet = [UIApplication sharedApplication].stylesheet;
        if (stylesheet) {
            [self applyStyle:[stylesheet valueForKey:style]];
        }
    }
}

@end
