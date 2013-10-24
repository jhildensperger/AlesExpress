#import "UIFont+Additions.h"

@implementation UIFont (Additions)

+ (UIFont *)normalFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Hero" size:fontSize];
}

+ (UIFont *)lightFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Hero-Light" size:fontSize];
}

@end
