#import "UIView+Binding.h"
#import <objc/runtime.h>

@implementation UIView (Binding)

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

@end
