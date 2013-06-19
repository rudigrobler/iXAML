#import "UIApplication+Styling.h"
#import <objc/runtime.h>
#import "UIView+Styling.h"

@implementation UIApplication (Extensions)

- (void)applyStyle:(UIView*)view{
    if (view.style)
    {
        [view applyStyle];
    }
    for (UIView *subview in view.subviews) {
        [self applyStyle:subview];
    }
}

- (void)setStylesheet:(iXStylesheet *)stylesheet {
    objc_setAssociatedObject(self, @"___stylesheet", stylesheet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    for (UIWindow *window in self.windows) {
        for (UIView *subview in window.subviews) {
            [self applyStyle:subview];
        }
    }
}

- (iXStylesheet *)stylesheet {
    return objc_getAssociatedObject(self, @"___stylesheet");
}

@end
