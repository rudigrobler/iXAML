#import "iXStylesheet.h"
#import <UIKit/UIKit.h>

@interface UIApplication (Styling)

- (void) setStylesheet:(iXStylesheet *)stylesheet;

- (iXStylesheet *) stylesheet;

@end
