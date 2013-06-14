#import "UIApplication+Extensions.h"
#import <objc/runtime.h>

@implementation UIApplication (Extensions)

- (void)setStylesheet:(iXStylesheet *)stylesheet {
    objc_setAssociatedObject(self, @"___stylesheet", stylesheet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StylesheetNotification" object:self];
}

- (iXStylesheet *)stylesheet {
    return objc_getAssociatedObject(self, @"___stylesheet");
}

@end
