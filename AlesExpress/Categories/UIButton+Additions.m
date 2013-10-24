#import <QuartzCore/QuartzCore.h>
#import "UIButton+Additions.h"

@implementation UIButton (Additions)

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        [self addHighlights];
//    }
//    return self;
//}
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    [self addHighlights];
//}
//
- (void)addHighlights {
    [self addTarget:self action:@selector(highlightBorder) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(unhighlightBorder) forControlEvents:UIControlEventTouchUpInside];
}

- (void)unhighlightBorder {
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
}

- (void)highlightBorder {
    self.layer.borderColor = [[UIColor darkGrayColor] colorWithAlphaComponent:.5].CGColor;
}

@end
