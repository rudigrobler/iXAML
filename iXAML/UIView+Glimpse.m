#import "NSObject+Extensions.h"
#import "UIView+Glimpse.h"

@implementation UIView (Swizzle)

+ (void)glimpse {
    [UIView swizzleMethod:NSSelectorFromString(@"init") withMethod:NSSelectorFromString(@"swizzle_init") error:nil];
    [UIView swizzleMethod:NSSelectorFromString(@"initWithCoder:") withMethod:NSSelectorFromString(@"swizzle_initWithCoder:") error:nil];
    [UIView swizzleMethod:NSSelectorFromString(@"initWithFrame:") withMethod:NSSelectorFromString(@"swizzle_initWithFrame:") error:nil];
    [UIView swizzleMethod:NSSelectorFromString(@"removeFromSuperview") withMethod:NSSelectorFromString(@"swizzle_removeFromSuperview") error:nil];
    [UIView swizzleMethod:NSSelectorFromString(@"insertSubview:atIndex:") withMethod:NSSelectorFromString(@"swizzle_insertSubview:atIndex:") error:nil];
    [UIView swizzleMethod:NSSelectorFromString(@"exchangeSubviewAtIndex:withSubviewAtIndex:") withMethod:NSSelectorFromString(@"swizzle_exchangeSubviewAtIndex:withSubviewAtIndex:") error:nil];
    [UIView swizzleMethod:NSSelectorFromString(@"addSubview:") withMethod:NSSelectorFromString(@"swizzle_addSubview:") error:nil];
    [UIView swizzleMethod:NSSelectorFromString(@"insertSubview:belowSubview:") withMethod:NSSelectorFromString(@"swizzle_insertSubview") error:nil];
    [UIView swizzleMethod:NSSelectorFromString(@"bringSubviewToFront:") withMethod:NSSelectorFromString(@"swizzle_bringSubviewToFront:") error:nil];
    [UIView swizzleMethod:NSSelectorFromString(@"sendSubviewToBack:") withMethod:NSSelectorFromString(@"swizzle_sendSubviewToBack:") error:nil];
    [UIView swizzleMethod:NSSelectorFromString(@"didAddSubview:") withMethod:NSSelectorFromString(@"swizzle_didAddSubview:") error:nil];
    [UIView swizzleMethod:NSSelectorFromString(@"willRemoveSubview:") withMethod:NSSelectorFromString(@"swizzle_willRemoveSubview:") error:nil];
    [UIView swizzleMethod:NSSelectorFromString(@"willMoveToSuperview:") withMethod:NSSelectorFromString(@"swizzle_willMoveToSuperview:") error:nil];
    [UIView swizzleMethod:NSSelectorFromString(@"didMoveToSuperview:") withMethod:NSSelectorFromString(@"swizzle_didMoveToSuperview:") error:nil];
    [UIView swizzleMethod:NSSelectorFromString(@"willMoveToWindow:") withMethod:NSSelectorFromString(@"swizzle_willMoveToWindow:") error:nil];
    [UIView swizzleMethod:NSSelectorFromString(@"didMoveToWindow") withMethod:NSSelectorFromString(@"swizzle_didMoveToWindow") error:nil];
}

- (void)log:(SEL)aSelector {
    if ([NSStringFromClass([self class]) isEqualToString:@"UIView"]) {
        NSLog(@"%@+%@", NSStringFromClass([self class]), NSStringFromSelector(aSelector));
    }
}

- (id)swizzle_init {
    [self log:_cmd];
    return [self swizzle_init];
}

- (id)swizzle_initWithCoder:(NSCoder *)aDecoder {
    [self log:_cmd];
    return [self swizzle_initWithCoder:aDecoder];
}

- (id)swizzle_initWithFrame:(CGRect)frame {
    [self log:_cmd];
    return [self swizzle_initWithFrame:frame];
}

- (void)swizzle_removeFromSuperview {
    [self log:_cmd];
    [self swizzle_removeFromSuperview];
}

- (void)swizzle_insertSubview:(UIView *)view atIndex:(NSInteger)index {
    [self log:_cmd];
    [self swizzle_insertSubview:view atIndex:index];
}

- (void)swizzle_exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2 {
    [self log:_cmd];
    [self swizzle_exchangeSubviewAtIndex:index1 withSubviewAtIndex:index2];
}

- (void)swizzle_addSubview:(UIView *)view {
    [self log:_cmd];
    [self swizzle_addSubview:view];
}

- (void)swizzle_insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview {
    [self log:_cmd];
    [self swizzle_insertSubview:view belowSubview:siblingSubview];
}

- (void)swizzle_insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview {
    [self log:_cmd];
    [self swizzle_insertSubview:view aboveSubview:siblingSubview];
}

- (void)swizzle_bringSubviewToFront:(UIView *)view {
    [self log:_cmd];
    [self swizzle_bringSubviewToFront:view];
}

- (void)swizzle_sendSubviewToBack:(UIView *)view {
    NSLog(@"%@+%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self swizzle_sendSubviewToBack:view];
}

- (void)swizzle_didAddSubview:(UIView *)subview {
    [self log:_cmd];
    [self swizzle_didAddSubview:subview];
}

- (void)swizzle_willRemoveSubview:(UIView *)subview {
    [self log:_cmd];
    [self swizzle_willRemoveSubview:subview];
}

- (void)swizzle_willMoveToSuperview:(UIView *)newSuperview {
    [self log:_cmd];
    [self swizzle_willMoveToSuperview:newSuperview];
}

- (void)swizzle_didMoveToSuperview {
    [self log:_cmd];
    [self swizzle_didMoveToSuperview];
}

- (void)swizzle_willMoveToWindow:(UIWindow *)newWindow {
    [self log:_cmd];
    [self swizzle_willMoveToWindow:newWindow];
}

- (void)swizzle_didMoveToWindow {
    [self log:_cmd];
    [self swizzle_didMoveToWindow];
}

@end