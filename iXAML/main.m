#import "iXAppDelegate.h"

void main(int argc, char *argv[]) {
    @autoreleasepool {
        @try {
            UIApplicationMain(argc, argv, nil, NSStringFromClass([iXAppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
        @finally {

        }
    }
}
