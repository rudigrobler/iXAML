#import "UIView+Extensions.h"
#import "UIApplication+Extensions.h"
#import "UIColor+Extensions.h"
#import "iXStyle.h"
#import <objc/runtime.h>

@implementation UIView (Extensions)

#pragma mark UIView

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveStylesheetNotification:)
                                                 name:@"StylesheetNotification"
                                               object:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self applyStyle];
        [self applyBinding];
    });

    [super awakeFromNib];
}

- (void)receiveStylesheetNotification:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self applyStyle];
    });
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"[%@:%@]", key, value);
}

#pragma mark - UIViewController

- (UIViewController *)viewController {
    UIViewController *viewController = objc_getAssociatedObject(self, @"___viewController");
    if (viewController)
        return viewController;

    viewController = [self traverseResponderChainForUIViewController];
    if (viewController) {
        objc_setAssociatedObject(self, @"___viewController", viewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return viewController;
}

- (id)traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

#pragma mark - Style

- (void)setStyle:(id)style {
    objc_setAssociatedObject(self, @"___style", style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
                        UIFont *font = [UIFont fontWithName:value size:17];
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

#pragma mark - Binding

- (id)binding {
    return objc_getAssociatedObject(self, @"___binding");
}

- (void)setBinding:(id)binding {
    objc_setAssociatedObject(self, @"___binding", binding, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)context {
    return objc_getAssociatedObject(self, @"___context");
}

- (void)setContext:(id)context {
    objc_setAssociatedObject(self, @"___context", context, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)applyBinding {
    if ([self context]) {
    }
    else {
        NSString *binding = [self binding];
        if (binding) {
            UIViewController *viewController = [self viewController];
            if (viewController) {
                if ([viewController respondsToSelector:NSSelectorFromString(binding)]) {
                    [self setContext:[NSString stringWithFormat:@"%@+%@+0x%lx", NSStringFromClass([self class]), binding, (unsigned long) [self hash]]];

                    [viewController addObserver:self forKeyPath:binding options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial) context:(__bridge void *) ([self context])];
                }
            }
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (keyPath == [self binding]) {
        if ([NSStringFromClass([self class]) isEqualToString:@"UILabel"]) {
            UILabel *label = (UILabel *) self;
            label.text = [change valueForKey:@"new"];
        }
        else if ([NSStringFromClass([self class]) isEqualToString:@"UIButton"]) {
            UIButton *button = (UIButton *) self;
            BOOL isEnabled = [[change valueForKey:@"new"] boolValue];
            [button setUserInteractionEnabled:isEnabled];
            [button setEnabled:isEnabled];
        }
    }
}

- (void)dealloc {
    if ([self context]) {
        [[self viewController] removeObserver:self forKeyPath:[self binding] context:(__bridge void *) ([self context])];
    }

    objc_setAssociatedObject(self, @"___viewController", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"___style", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"___binding", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"___context", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
