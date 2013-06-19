#import "UIFont+Extensions.h"
#import "iXAppDelegate.h"
#import "UIApplication+Styling.h"

@implementation iXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIFont registerCustomFonts];

    NSURL *url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"dark-stylesheet" ofType:@"xaml"]];
    iXStylesheet *stylesheet = [[iXStylesheet alloc] initWithContentsOfURL:url];
    [UIApplication sharedApplication].stylesheet = stylesheet;

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
