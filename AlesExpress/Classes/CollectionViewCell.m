#import "CollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
@import QuartzCore;

@implementation CollectionViewCell

- (void)awakeFromNib {
//    self.layer.cornerRadius = 25;
}

- (void)setBeerInfo:(Beer *)beer {
    self.nameLabel.text = beer.name;
    self.nameLabel.font = [UIFont normalFontOfSize:20];

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    self.priceLabel.text = [formatter stringFromNumber:beer.price];
    self.priceLabel.font = [UIFont normalFontOfSize:20];
    
    if (beer.imageUrl.length > 0) {
        NSURL *url = [NSURL URLWithString:beer.imageUrl];
        [self.beerImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ales_logo2"]];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    int pixelsHigh = 44;
//    int pixelsWide = 46;
//    UIImage *bottomImage;
//    
//    //    if([UIScreen respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0) {
//    //        pixelsHigh *= 2;
//    //        pixelsWide *= 2;
//    //        bottomImage = [UIImage imageNamed:@"tileBevel@2x.png"];
//    //    }
//    //    else {
//    bottomImage = [UIImage imageNamed:@"paper_overlay"];
//    //    }
//    
//    CGImageRef theCGImage = NULL;
//    CGContextRef tileBitmapContext = NULL;
//    
//    CGRect rectangle = CGRectMake(0,0,pixelsWide,pixelsHigh);
//    
//    UIGraphicsBeginImageContext(rectangle.size);
//    
//    [bottomImage drawInRect:rectangle];
//    
//    tileBitmapContext = UIGraphicsGetCurrentContext();
//    
//    CGContextSetBlendMode(tileBitmapContext, kCGBlendModeOverlay);
//    
//    //    CGContextSetFillColorWithColor(tileBitmapContext, tileColor.CGColor);
//    CGContextFillRect(tileBitmapContext, rectangle);
//    
//    theCGImage=CGBitmapContextCreateImage(tileBitmapContext);
//    
//    UIGraphicsEndImageContext();
//    
//    UIImageView *newView = [[UIImageView alloc] initWithFrame:self.frame];
//    [newView setImage:[UIImage imageWithCGImage:theCGImage]];
//    CGImageRelease(theCGImage);
//}

@end
