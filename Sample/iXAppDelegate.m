#import "iXAppDelegate.h"
#import "iXStyle.h"
#import "iXStylesheet.h"
#import "UIApplication+Styling.h"
#import "UIKit+Styling.h"

@implementation iXAppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[UIFont registerCustomFonts];

	NSURL *url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle]
							 pathForResource:@"light-stylesheet"
							 ofType:@"xaml"]];
	iXStylesheet *stylesheet = [[iXStylesheet alloc] initWithXAML:url];

	[[UIApplication sharedApplication] setStylesheet:stylesheet];

	iXStyle *navigationBarStyle = [[iXStyle alloc] init];
	[navigationBarStyle setValue:@"#000000" forKey:@"backgroundColor"];
	[navigationBarStyle setValue:@"#FFFFFF" forKey:@"textColor"];
	[navigationBarStyle setValue:@"SegoeUI-Bold 17" forKey:@"font"];

	[UINavigationBar applyStyle:navigationBarStyle];

	iXStyle *barButtonItemStyle = [[iXStyle alloc] init];
	[barButtonItemStyle setValue:@"#FFFFFF" forKey:@"backgroundColor"];
	[barButtonItemStyle setValue:@"#000000" forKey:@"textColor"];
	[barButtonItemStyle setValue:@"SegoeUI-Light 14" forKey:@"font"];

	[UIBarButtonItem applyStyle:barButtonItemStyle];

	return YES;
}

@end
