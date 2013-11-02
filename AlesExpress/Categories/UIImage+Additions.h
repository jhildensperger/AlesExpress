@interface UIImage (Additions)

+ (UIImage *)maskedImageNamed:(NSString *)name color:(UIColor *)color;
- (UIImage *)maskWithColor:(UIColor *)color;

@end