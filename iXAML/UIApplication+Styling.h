#import <UIKit/UIKit.h>
#import "iXStylesheet.h"

@interface UIApplication (Extensions)

@property iXStylesheet *stylesheet;

- (void)applyStylesheet;

@end
