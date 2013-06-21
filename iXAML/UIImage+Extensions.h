#import <UIKit/UIKit.h>

@interface UIImage (Extensions)

+ (UIImage *) imageWithColor:(UIColor *)color
                cornerRadius:(CGFloat)cornerRadius;

+ (UIImage *) buttonImageWithColor:(UIColor *)color
                      cornerRadius:(CGFloat)cornerRadius
                       shadowColor:(UIColor *)shadowColor
                      shadowInsets:(UIEdgeInsets)shadowInsets;

- (UIImage *) imageWithMinimumSize:(CGSize)size;

+ (UIImage *) backButtonImageWithColor:(UIColor *)color
                            barMetrics:(UIBarMetrics)metrics
                          cornerRadius:(CGFloat)cornerRadius;

@end
