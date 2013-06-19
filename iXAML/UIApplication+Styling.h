#import <UIKit/UIKit.h>
#import "iXStylesheet.h"

@interface UIApplication (Styling)

@property iXStylesheet *stylesheet;

- (void)setStylesheet:(iXStylesheet *)stylesheet;

- (iXStylesheet *)stylesheet;

@end
