#import "UIApplication+Styling.h"
#import "iXViewController.h"

@interface iXViewController () {
    NSDateFormatter *dateFormatter;
}

@end

@implementation iXViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.applicationTitle = @"iXAML";
    self.timestamp = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
}

- (IBAction)onLight:(id)sender {
    NSURL *url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"light-stylesheet" ofType:@"xaml"]];
    iXStylesheet *stylesheet = [[iXStylesheet alloc] initWithXAML:url];

    [[UIApplication sharedApplication] setStylesheet:stylesheet];
}

- (IBAction)onDark:(id)sender {
    NSURL *url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"dark-stylesheet" ofType:@"xaml"]];
    iXStylesheet *stylesheet = [[iXStylesheet alloc] initWithXAML:url];

    [[UIApplication sharedApplication] setStylesheet:stylesheet];
}

@end