#import "iXAppDelegate.h"

int main(int argc, char *argv[]) {
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([iXAppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
        @finally {
            
        }
    }
}
