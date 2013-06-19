#import "UIApplication+Styling.h"
#import <objc/runtime.h>
#import "UIView+Styling.h"

@implementation UIApplication (Styling)

- (void)applyStylesheet {
    for (UIWindow *window in self.windows) {
        for (UIView *subview in window.subviews) {
            [self applyStyleToView:subview];
        }
    }
}

- (void)applyStyleToView:(UIView *)view {
    [view applyStyle];
    
    for (UIView *subview in view.subviews) {
        [self applyStyleToView:subview];
    }
}

- (void)setStylesheet:(iXStylesheet *)stylesheet {
    objc_setAssociatedObject(self, @"___stylesheet", stylesheet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    dispatch_async(dispatch_get_main_queue(), ^{
        [self applyStylesheet];
    });
}

- (iXStylesheet *)stylesheet {
    return objc_getAssociatedObject(self, @"___stylesheet");
}

@end
