#import "UIApplication+Styling.h"
#import "UIBarButtonItem+Styling.h"
#import "UIFont+Extensions.h"
#import "UINavigationBar+Styling.h"
#import "iXAppDelegate.h"

@implementation iXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIFont registerCustomFonts];

    // Loading stylesheet from XAML
    NSURL *url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle]
            pathForResource:@"light-stylesheet"
                     ofType:@"xaml"]];
    iXStylesheet *stylesheet = [[iXStylesheet alloc] initWithXAML:url];

    // Loading stylesheet from plist
    // NSURL *url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle]
    //         pathForResource:@"dark-stylesheet"
    //                  ofType:@"plist"]];
    // iXStylesheet *stylesheet = [[iXStylesheet alloc] initWithContentsOfURL:url];

    [[UIApplication sharedApplication] setStylesheet:stylesheet];

    iXStyle *navigationBarStyle = [[iXStyle alloc] init];
    [navigationBarStyle setValue:@"#000000" forKey:@"background-color"];
    [navigationBarStyle setValue:@"#FFFFFF" forKey:@"text-color"];
    [navigationBarStyle setValue:@"SegoeUI-Bold 17" forKey:@"font"];

    [UINavigationBar applyStyle:navigationBarStyle];

    iXStyle *barButtonItemStyle = [[iXStyle alloc] init];
    [barButtonItemStyle setValue:@"#FFFFFF" forKey:@"background-color"];
    [barButtonItemStyle setValue:@"#000000" forKey:@"text-color"];
    [barButtonItemStyle setValue:@"SegoeUI-Light 14" forKey:@"font"];

    [UIBarButtonItem applyStyle:barButtonItemStyle];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end