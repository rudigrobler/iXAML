#import "iXStylesheet.h"
#import <UIKit/UIKit.h>

@interface UIApplication (Styling)

@property iXStylesheet *stylesheet;

- (void) setStylesheet:(iXStylesheet *)stylesheet;

- (iXStylesheet *) stylesheet;

@end
