#import "iXAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        int returnCode = -1;
        @try
        {
            returnCode = UIApplicationMain( argc, argv, nil, NSStringFromClass([iXAppDelegate class]) );
        }
        @catch (NSException *exception)
        {
            NSLog(@"%@", exception);
        }

        @finally
        {
            return returnCode;
        }
    }
}
