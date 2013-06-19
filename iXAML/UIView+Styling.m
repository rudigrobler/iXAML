#import "UIView+Styling.h"
#import "UIColor+Extensions.h"
#import "UIApplication+Styling.h"
#import "UIFont+Extensions.h"
#import "iXStyle.h"
#import "iXStylesheet.h"
#import <objc/runtime.h>

@implementation UIView (Style)

- (void)setStyle:(id)style {
    objc_setAssociatedObject(self, @"___style", style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    dispatch_async(dispatch_get_main_queue(), ^{
        [self applyStyle];
    });
}

- (id)style {
    return objc_getAssociatedObject(self, @"___style");
}

- (void)applyStyle {
    NSString *styleName = [self style];
    if (styleName) {
        iXStylesheet *stylesheet = [UIApplication sharedApplication].stylesheet;
        if (stylesheet) {
            iXStyle *style = [stylesheet valueForKey:styleName];
            if (style) {
                for (NSString *key in style.keyEnumerator) {
                    id value = [style valueForKey:key];
                    if ([key isEqualToString:@"backgroundColor"])
                    {
                        UIColor *color = [UIColor colorFromString:value];
                        if (color) {
                            [self setValue:color forKey:key];
                        }
                    }
                    else if ([key isEqualToString:@"textColor"])
                    {
                        UIColor *color = [UIColor colorFromString:value];
                        if (color) {
                            if ([NSStringFromClass([self class]) isEqualToString:@"UIButton"]) {
                                ((UIButton*)self).titleLabel.textColor = color;
                            }
                            else
                            {
                                [self setValue:color forKey:key];
                            }
                        }
                    }
                    else if ([key isEqualToString:@"font"]) {
                        UIFont *font = [UIFont fontWithNameAndSize:value];
                        if (font) {
                            [self setValue:font forKey:key];
                        }
                    }
                    else {
                        NSLog(@"[%@:%@]", key, value);
                    }
                }
            }
        }
    }
}

@end
