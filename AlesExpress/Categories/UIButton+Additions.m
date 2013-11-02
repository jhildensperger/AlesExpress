#import <QuartzCore/QuartzCore.h>
#import "UIButton+Additions.h"

@implementation UIButton (Additions)
@dynamic imageMask;

- (void)setImageMask:(UIColor *)imageMask {
    UIImage *normalImage = [self imageForState:UIControlStateNormal];
    [self setImage:[normalImage maskWithColor:imageMask] forState:UIControlStateNormal];
}

@end
