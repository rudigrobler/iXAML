#import "UIKit+Styling.h"

@implementation UINavigationBar (Styling)

+ (void) applyStyle:(iXStyle *)style
{
    if (style)
    {
        for (NSString *property in style.keyEnumerator)
        {
            NSString *value = [style valueForKey:property];

            if ([property isEqualToString:iX_backgroundColor])
            {
                UIColor *color = [UIColor colorFromString:value];
                UIImage *backgroundImage = [UIImage imageWithColor:color cornerRadius:0];
                [[UINavigationBar appearance] setBackgroundImage:backgroundImage
                                                   forBarMetrics:UIBarMetricsDefault];
            }
            else if ([property isEqualToString:iX_textColor])
            {
                NSMutableDictionary *attributes = [[[UINavigationBar appearance] titleTextAttributes] mutableCopy];

                if (!attributes)
                {
                    attributes = [NSMutableDictionary dictionary];
                }

                [attributes setValue:[NSValue valueWithUIOffset:UIOffsetMake(0, 0)] forKey:UITextAttributeTextShadowOffset];
                [attributes setValue:[UIColor colorFromString:value] forKey:UITextAttributeTextColor];

                [[UINavigationBar appearance] setTitleTextAttributes:attributes];
            }
            else if ([property isEqualToString:iX_font])
            {
                NSMutableDictionary *attributes = [[[UINavigationBar appearance] titleTextAttributes] mutableCopy];

                if (!attributes)
                {
                    attributes = [NSMutableDictionary dictionary];
                }

                [attributes setValue:[NSValue valueWithUIOffset:UIOffsetMake(0, 0)] forKey:UITextAttributeTextShadowOffset];
                [attributes setValue:[UIFont fontWithNameAndSize:value] forKey:UITextAttributeFont];

                [[UINavigationBar appearance] setTitleTextAttributes:attributes];
            }
            else
            {
            }
        }
    }
}


@end
