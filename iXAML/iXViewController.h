#import <UIKit/UIKit.h>

@interface iXViewController : UIViewController

@property NSString *applicationTitle;

@property NSString *timestamp;

@property BOOL canUpdate;

- (IBAction)onUpdate:(id)sender;

- (IBAction)onReset:(id)sender;

- (IBAction)onLight:(id)sender;

- (IBAction)onDark:(id)sender;

@end
