#import "BaseViewController.h"

//Externals
#import "IIViewDeckController.h"

@interface BaseViewController ()

@property (nonatomic) UILabel *cartCountLabel;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    if (!self.navigationController || self.navigationController.viewControllers[0] != self) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
        [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        backButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        backButton.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *backImage = [UIImage maskedImageNamed:@"back" color:[UIColor whiteColor]];
        [backButton setImage:backImage forState:UIControlStateNormal];
        [self.view addSubview:backButton];
    }
    
    self.cartButton = [[UIButton alloc] initWithFrame:CGRectMake(261, 25, 44, 44)];
    [self.cartButton addTarget:self.viewDeckController action:@selector(toggleRightViewAnimated:) forControlEvents:UIControlEventTouchUpInside];
    self.cartButton.backgroundColor = [UIColor colorWithWhite:.5 alpha:.2];
    UIImage *cartImage = [UIImage maskedImageNamed:@"cart5" color:[UIColor whiteColor]];
    [self.cartButton setImage:cartImage forState:UIControlStateNormal];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setShowsCart:(BOOL)showsCart {
    if (showsCart) {
        [self.view addSubview:self.cartButton];
    } else {
        [self.cartButton removeFromSuperview];
    }
}

- (void)setCartCount:(NSInteger)cartCount {
    if (_cartCount != cartCount) {
        _cartCount = cartCount;
        if (cartCount) {
            self.cartCountLabel.hidden = NO;
            self.cartCountLabel.text = @(cartCount).stringValue;
        } else {
            self.cartCountLabel.hidden = YES;
        }
    }
}

- (UILabel *)cartCountLabel {
    if (!_cartCountLabel) {
        _cartCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 16, 16)];
        _cartCountLabel.backgroundColor = [UIColor colorWithRed:0.959 green:0.897 blue:0.490 alpha:1.000];
        _cartCountLabel.layer.cornerRadius = 8;
        _cartCountLabel.font = [UIFont normalFontOfSize:12];
        _cartCountLabel.textAlignment = NSTextAlignmentCenter;
        _cartCountLabel.textColor = [UIColor darkGrayColor];
        [self.cartButton addSubview:_cartCountLabel];
    }
    return _cartCountLabel;
}

- (void)didTapCartButton {
    [self.viewDeckController toggleRightViewAnimated:YES];
}

@end