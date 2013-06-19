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

- (NSString *)binding {
    return objc_getAssociatedObject(self, @"___binding");
}

- (void)setBinding:(NSString *)binding {
    objc_setAssociatedObject(self, @"___binding", binding, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    dispatch_async(dispatch_get_main_queue(), ^{
        [self applyBinding];
    });
}

- (void)applyBinding {
    NSString *binding = [self binding];
    if (binding) {
        UIViewController *viewController = [self viewController];
        if (viewController) {
            if ([viewController respondsToSelector:NSSelectorFromString(binding)]) {
                if ([NSStringFromClass([self class]) isEqualToString:@"UILabel"]) {
                    ((UILabel *) self).text = [viewController performSelector:NSSelectorFromString(binding)];
                }
            }
        }
    }
}

@end
