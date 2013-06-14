@interface UIColor (Extensions)

+ (UIColor *)colorFromString:(NSString *)str;

// TODO:
// Currently expect #XXXXXX
// Add alpha support
// Short-hand ie. #fff = white?
// Possible support for color names? ie. red, blue, etc?
// Gradients?
// Image as brush?

@end
