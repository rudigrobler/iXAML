#import "UIKit+Styling.h"

@implementation UIButton (Styling)

+ (void) applyStyle:(iXStyle *)style
{
	if (style)
	{
		for (NSString *property in style.keyEnumerator)
		{
			NSString *value = [style valueForKey:property];

			if ([property isEqualToString:iX_backgroundColor])
			{
				[[UIButton appearance] setBackgroundColor:[UIColor colorFromString:value]];
			}
			else if ([property isEqualToString:iX_textColor])
			{
				NSMutableAttributedString *attributedString = [[[UIButton appearance] attributedTitleForState:UIControlStateNormal] mutableCopy];

				if (!attributedString)
				{
					attributedString = [[NSMutableAttributedString alloc] init];
				}

				[attributedString addAttribute:NSForegroundColorAttributeName
				 value:[UIColor colorFromString:value]
				 range:NSMakeRange(0, [attributedString length])];
				[[UIButton appearance] setAttributedTitle:attributedString forState:UIControlStateNormal];
			}
			else if ([property isEqualToString:iX_font])
			{
				NSMutableAttributedString *attributedString = [[[UIButton appearance] attributedTitleForState:UIControlStateNormal] mutableCopy];

				if (!attributedString)
				{
					attributedString = [[NSMutableAttributedString alloc] init];
				}

				[attributedString addAttribute:UITextAttributeFont
				 value:[UIFont fontWithNameAndSize:value]
				 range:NSMakeRange(0, [attributedString length])];
				[[UIButton appearance] setAttributedTitle:attributedString forState:UIControlStateNormal];
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

			NSRange range = [property rangeOfString:iX_backgroundColor];
			if (range.length == iX_backgroundColor.length)
			{
				NSString *state = @"[UIControlStateNormal]";
				if (property.length > iX_backgroundColor.length)
				{
					state = [property stringByReplacingOccurrencesOfString:iX_backgroundColor withString:@""];
				}

				if ([state isEqualToString:@"[UIControlStateDisabled]"])
				{
					[self setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromString:value] cornerRadius:0] forState:UIControlStateDisabled];
				}
				else if ([state isEqualToString:@"[UIControlStateHighlighted]"])
				{
					[self setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromString:value] cornerRadius:0] forState:UIControlStateHighlighted];
				}
				else if ([state isEqualToString:@"[UIControlStateSelected]"])
				{
					[self setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromString:value] cornerRadius:0] forState:UIControlStateSelected];
				}
				else
				{
					[self setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromString:value] cornerRadius:0] forState:UIControlStateNormal];
				}
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
				NSMutableAttributedString *attributedString = [[self attributedTitleForState:UIControlStateNormal] mutableCopy];

				if (!attributedString)
				{
					attributedString = [[NSMutableAttributedString alloc] initWithString:[self titleForState:UIControlStateNormal]];
				}

				[attributedString addAttribute:NSForegroundColorAttributeName
				 value:[UIColor colorFromString:value]
				 range:NSMakeRange(0, [attributedString length])];
				[self setAttributedTitle:attributedString forState:UIControlStateNormal];
			}
			else if ([property isEqualToString:iX_font])
			{
				NSMutableAttributedString *attributedString = [[self attributedTitleForState:UIControlStateNormal] mutableCopy];

				if (!attributedString)
				{
					attributedString = [[NSMutableAttributedString alloc] initWithString:[self titleForState:UIControlStateNormal]];
				}

				[attributedString addAttribute:UITextAttributeFont
				 value:[UIFont fontWithNameAndSize:value]
				 range:NSMakeRange(0, [attributedString length])];
				[self setAttributedTitle:attributedString forState:UIControlStateNormal];
			}
			else
			{
			}
		}
	}
}

@end
