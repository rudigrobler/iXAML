#import <UIKit/UIKit.h>
#import "iXStylesheet.h"

@interface UIApplication (Extensions)

@property iXStylesheet *stylesheet;

- (void)setStylesheet:(iXStylesheet *)stylesheet;

- (iXStylesheet *)stylesheet;

@end
