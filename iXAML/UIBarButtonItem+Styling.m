#import "UIKit+Styling.h"

@implementation UIBarButtonItem (Styling)

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
				UIImage *backgroundImage = [UIImage backButtonImageWithColor:color
							    barMetrics:UIBarMetricsDefault
							    cornerRadius:0.0f];
				[[UIBarButtonItem appearance] setBackButtonBackgroundImage:backgroundImage
				 forState:UIControlStateNormal
				 barMetrics:UIBarMetricsDefault];
			}
			else if ([property isEqualToString:iX_textColor])
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
			else if ([property isEqualToString:iX_font])
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
			}
		}
	}
}

@end
