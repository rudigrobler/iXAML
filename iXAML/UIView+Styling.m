#import "UIKit+Styling.h"
#import "UIApplication+Styling.h"
#import <objc/runtime.h>

static char iX_styleAssociatedObjectKey;

@implementation UIView (Styling)

- (void) setStyle:(NSString *)style
{
	objc_setAssociatedObject(self, @"___style", style, OBJC_ASSOCIATION_COPY_NONATOMIC);

	dispatch_barrier_async(dispatch_get_main_queue(), ^{
				       [self applyStyle];
			       }

			       );
}

- (NSString *) style
{
	return objc_getAssociatedObject(self, @"___style");
}

- (void) applyStyle
{
	NSString *style = [self style];

	if (style)
	{
		iXStylesheet *stylesheet = [[UIApplication sharedApplication] stylesheet];

		if (stylesheet)
		{
			[self applyStyle:[stylesheet valueForKey:style]];
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
			else
			{
			}
		}
	}
}

@end
