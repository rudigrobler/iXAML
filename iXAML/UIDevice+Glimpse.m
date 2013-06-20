#import "UIDevice+Extensions.h"
#import "UIDevice+Glimpse.h"

@implementation UIDevice (Glimpse)

+ (void)glimpse {
    NSLog(@"platform: %@", [[UIDevice currentDevice] platform]);
    NSLog(@"hwmodel: %@", [[UIDevice currentDevice] hwmodel]);
    NSLog(@"platformType: %lu", (unsigned long) [[UIDevice currentDevice] platformType]);
    NSLog(@"platformString: %@", [[UIDevice currentDevice] platformString]);
    NSLog(@"cpuFrequency: %lu", (unsigned long) [[UIDevice currentDevice] cpuFrequency]);
    NSLog(@"busFrequency: %lu", (unsigned long) [[UIDevice currentDevice] busFrequency]);
    NSLog(@"cpuCount: %lu", (unsigned long) [[UIDevice currentDevice] cpuCount]);
    NSLog(@"totalMemory: %lu", (unsigned long) [[UIDevice currentDevice] totalMemory]);
    NSLog(@"userMemory: %lu", (unsigned long) [[UIDevice currentDevice] userMemory]);
    NSLog(@"totalDiskSpace: %@", [[UIDevice currentDevice] totalDiskSpace]);
    NSLog(@"freeDiskSpace: %@", [[UIDevice currentDevice] freeDiskSpace]);
    NSLog(@"macaddress: %@", [[UIDevice currentDevice] macaddress]);
    NSLog(@"hasRetinaDisplay: %c", [[UIDevice currentDevice] hasRetinaDisplay]);
    NSLog(@"deviceFamily: %u", [[UIDevice currentDevice] deviceFamily]);
}

@end