#import "UILabel+Additions.h"

@implementation UILabel (Additions)
@dynamic fontName;
@dynamic fontSize;
@dynamic fontColorName;

- (void)setFontName:(NSString *)fontName {
    NSString *selectorString = [fontName stringByAppendingString:@"FontOfSize:"];
    self.font = [UIFont performSelector:NSSelectorFromString(selectorString) withObject:@(self.font.pointSize)];
}

- (void)setFontSize:(NSNumber *)fontSize {
    self.font = [self.font fontWithSize:fontSize.floatValue];
}

@end
