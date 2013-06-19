#import "iXStylesheet.h"
#import "iXViewController.h"
#import "UIApplication+Styling.h"

@interface iXViewController () {
    NSDateFormatter *dateFormatter;
    int clickCount;
}

@end

@implementation iXViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
        //_canUpdate = YES;
    }
    return self;
}

- (void)viewDidLoad {
    self.applicationTitle = @"iXAML";
    self.timestamp = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
}

- (IBAction)onUpdate:(id)sender {
    if (clickCount < 3) {
        self.timestamp = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        clickCount++;
    }
    else {
        self.timestamp = @"DONE";
        //self.canUpdate = NO;
    }
}

- (IBAction)onReset:(id)sender {
    self.timestamp = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    clickCount = 0;
    //self.canUpdate = YES;
}

- (IBAction)onLight:(id)sender {
    NSURL *url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"light-stylesheet" ofType:@"xaml"]];
    iXStylesheet *stylesheet = [[iXStylesheet alloc] initWithContentsOfURL:url];
    [UIApplication sharedApplication].stylesheet = stylesheet;
}

- (IBAction)onDark:(id)sender {
    NSURL *url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"dark-stylesheet" ofType:@"xaml"]];
    iXStylesheet *stylesheet = [[iXStylesheet alloc] initWithContentsOfURL:url];
    [UIApplication sharedApplication].stylesheet = stylesheet;
}

@end
