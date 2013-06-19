#import "UIViewController+Binding.h"
#import "UIView+Binding.h"

@implementation UIViewController (Binding)

- (UIView *)findViewByBinding:(NSString *)binding view:(UIView *)view {
    if ([[view binding] isEqualToString:binding])
        return view;

    for (UIView *subview in view.subviews) {
        UIView *___view = [self findViewByBinding:binding view:subview];
        if (___view) {
            return ___view;
        }
    }
    return nil;
}

- (void)applyBinding:(NSString *)binding {
    UIView *viewToBind = [self findViewByBinding:binding view:self.view];
    if (viewToBind) {
        NSLog(@"%@", viewToBind);
    }
}

@end
