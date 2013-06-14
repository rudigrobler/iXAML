@interface NSObject (JRSwizzle)

+ (BOOL)swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError **)error_;

@end
