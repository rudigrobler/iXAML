#import "UIButton+Styling.h"
#import "UIColor+Extensions.h"
#import "UIFont+Extensions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIButton (Styling)

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
                [[UIButton appearance] setBackgroundColor:[UIColor colorFromString:value]];
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
            else if ([property isEqualToString:@"font"])
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

            if ([property isEqualToString:@"style-name"])
            {
            }
            else if ([property isEqualToString:@"background-color"])
            {
                [self setBackgroundColor:[UIColor colorFromString:value]];
            }
            else if ([property isEqualToString:@"border-color"])
            {
                [self.layer setBorderColor:[UIColor colorFromString:value].CGColor];
            }
            else if ([property isEqualToString:@"border-width"])
            {
                [self.layer setBorderWidth:[value floatValue]];
            }
            else if ([property isEqualToString:@"corner-radius"])
            {
                [self.layer setCornerRadius:[value floatValue]];
            }
            else if ([property isEqualToString:@"text-color"])
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
            else if ([property isEqualToString:@"font"])
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
