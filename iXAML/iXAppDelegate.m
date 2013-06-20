#import "UIFont+Extensions.h"
#import "iXAppDelegate.h"
#import "iXStylesheet.h"
#import "UIApplication+Styling.h"
#import "iXAML.h"
#import "Glimpse.h"
#import "UIDevice+Glimpse.h"

@implementation iXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"Glimpse %@", [Glimpse version]);
    [UIDevice glimpse];

    NSLog(@"iXAML %@", [iXAML version]);

    [UIFont registerCustomFonts];

    // Loading stylesheet from XAML
    // NSURL *url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle]
    //                                 pathForResource:@"dark-stylesheet"
    //                                          ofType:@"xaml"]];
    // iXStylesheet *stylesheet = [[iXStylesheet alloc] initWithXAML:url];

    // Loading stylesheet from plist
    NSURL *url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle]
            pathForResource:@"dark-stylesheet"
                     ofType:@"plist"]];
    iXStylesheet *stylesheet = [[iXStylesheet alloc] initWithContentsOfURL:url];

    [[UIApplication sharedApplication] setStylesheet:stylesheet];

    // iXStyle *style = [[iXStyle alloc] init];
    // [style setValue:@"#000000" forKey:@"background-color"];
    // [style setValue:@"#FFFFFF" forKey:@"text-color"];
    // [style setValue:@"SegoeUI-Light 17" forKey:@"font"];

    // [UITextField applyStyle:style];
    // [UIButton applyStyle:style];
    // [UILabel applyStyle:style];


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
