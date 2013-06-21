#import "UIBarButtonItem+Styling.h"
#import "UIColor+Extensions.h"
#import "UIFont+Extensions.h"
#import "UIImage+Extensions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIBarButtonItem (Styling)

+ (void) applyStyle:(iXStyle *)style
{
    if (style)
    {
        for (NSString *property in style.keyEnumerator)
        {
            NSString *value = [style valueForKey:property];

            if ([property isEqualToString:@"style-name"])
            {
            }
            else if ([property isEqualToString:@"background-color"])
            {
                UIColor *color = [UIColor colorFromString:value];
                UIImage *backgroundImage = [UIImage backButtonImageWithColor:color
                                                                  barMetrics:UIBarMetricsDefault
                                                                cornerRadius:0.0f];
                [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backgroundImage
                                                                  forState:UIControlStateNormal
                                                                barMetrics:UIBarMetricsDefault];
            }
            else if ([property isEqualToString:@"border-color"])
            {
            }
            else if ([property isEqualToString:@"border-width"])
            {
            }
            else if ([property isEqualToString:@"corner-radius"])
            {
            }
            else if ([property isEqualToString:@"text-color"])
            {
                NSMutableDictionary *attributes = [[[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateNormal] mutableCopy];

                if (!attributes)
                {
                    attributes = [NSMutableDictionary dictionary];
                }

                [attributes setValue:[NSValue valueWithUIOffset:UIOffsetMake(0, 0)] forKey:UITextAttributeTextShadowOffset];
                [attributes setValue:[UIColor colorFromString:value] forKey:UITextAttributeTextColor];

                [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
            }
            else if ([property isEqualToString:@"font"])
            {
                NSMutableDictionary *attributes = [[[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateNormal] mutableCopy];

                if (!attributes)
                {
                    attributes = [NSMutableDictionary dictionary];
                }

                [attributes setValue:[NSValue valueWithUIOffset:UIOffsetMake(0, 0)] forKey:UITextAttributeTextShadowOffset];
                [attributes setValue:[UIFont fontWithNameAndSize:value] forKey:UITextAttributeFont];

                [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
            }
            else
            {
                NSLog( @"'%@' not found on '%@'", property, NSStringFromClass([self class]) );
            }
        }
    }
}


@end
