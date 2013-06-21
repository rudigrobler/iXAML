#import "UIKit+Styling.h"

@implementation UITextField (Styling)

+ (void) applyStyle:(iXStyle *)style
{
	if (style)
	{
		for (NSString *property in style.keyEnumerator)
		{
			NSString *value = [style valueForKey:property];

			if ([property isEqualToString:iX_backgroundColor])
			{
				[[UITextField appearance] setBackgroundColor:[UIColor colorFromString:value]];
			}
			else if ([property isEqualToString:iX_textColor])
			{
				[[UITextField appearance] setTextColor:[UIColor colorFromString:value]];
			}
			else if ([property isEqualToString:iX_font])
			{
				[[UITextField appearance] setFont:[UIFont fontWithNameAndSize:value]];
			}
			else
			{
			}
		}
	}
}

- (void) applyStyle:(iXStyle *)style
{
	if (style)
	{
		for (NSString *property in style.keyEnumerator)
		{
			NSString *value = [style valueForKey:property];

			if ([property isEqualToString:iX_backgroundColor])
			{
				[self setBackgroundColor:[UIColor colorFromString:value]];
			}
			else if ([property isEqualToString:iX_borderColor])
			{
				[self.layer setBorderColor:[UIColor colorFromString:value].CGColor];
			}
			else if ([property isEqualToString:iX_borderWidth])
			{
				[self.layer setBorderWidth:[value floatValue]];
			}
			else if ([property isEqualToString:iX_cornerRadius])
			{
				[self.layer setCornerRadius:[value floatValue]];
			}
			else if ([property isEqualToString:iX_textColor])
			{
				[self setTextColor:[UIColor colorFromString:value]];
			}
			else if ([property isEqualToString:iX_font])
			{
				[self setFont:[UIFont fontWithNameAndSize:value]];
			}
			else
			{
			}
		}
	}
}

@end
