#import "V8HorizontalPickerView.h"
#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController () <V8HorizontalPickerViewDataSource, V8HorizontalPickerViewDelegate>

@property (nonatomic, assign) BOOL loggingInToOrder;
@property (nonatomic) Beer *beer;
@property (nonatomic) NSArray *quantityTitles;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (instancetype)initWithBeer:(Beer *)beer {
    if (self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil]) {
        self.beer = beer;
        self.quantityTitles = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"More"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
    
    self.backgroundImageView.image = [[UIImage imageNamed:@"beer_glass"] applyDarkEffect];
    self.titleLabel.text = self.beer.name;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.loggingInToOrder) {
        [self presentOrderController];
    }
}

#pragma mark - loginViewControllerDelegate methods

- (void)loginViewControllerDidCancel:(LoginViewController *)loginViewController {
    self.loggingInToOrder = NO;
}

- (void)loginViewControllerDidLogin:(LoginViewController *)loginViewController {

}

#pragma mark - orderViewControllerDelegate methods

- (void)orderViewControllerDidCancel:(OrderViewController *)loginViewController {
    self.loggingInToOrder = NO;
}

- (void)orderViewControllerDidPostTask:(OrderViewController *)loginViewController {
    
}

#pragma mark - button methods

- (void)presentOrderController {
    UINavigationController *navController = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"orderVC"];
    OrderViewController *orderController = (OrderViewController *)navController.topViewController;

    orderController.beerToOrder = self.beer;
    orderController.delegate = self;

    [self presentViewController:navController
                       animated:YES
                     completion:^{
                         self.loggingInToOrder = NO;
                     }];
}

- (void)presentLoginController {
    UINavigationController *navController = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    LoginViewController *loginController = (LoginViewController *)navController.topViewController;

    loginController.delegate = self;

    [self presentViewController:navController animated:YES completion:^{
                         self.loggingInToOrder = YES;
                     }];
}

- (IBAction)didTapAddToCartButton:(id)sender {

}

- (IBAction)didTapQuantityButton:(id)sender {
    [self setQuantityPickerVisible:YES];
}

- (void)setQuantityPickerVisible:(BOOL)isVisible {
    if (isVisible) {
        self.quantityPickerTopConstraint.constant = -44;
    } else {
        self.quantityPickerTopConstraint.constant = 0;
    }
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:nil];
}



- (void)configureView {
    self.detailDescriptionTextView.font = [UIFont normalFontOfSize:14];
    self.detailABVLabel.font = [UIFont normalFontOfSize:18];
    self.detailPriceLabel.font = [UIFont normalFontOfSize:30];
    self.detailServingLabel.font = [UIFont normalFontOfSize:18];
    
    self.addToCartButton.titleLabel.font = [UIFont normalFontOfSize:20.0];
    self.quantityButton.titleLabel.font = [UIFont normalFontOfSize:18];
    
    self.detailDescriptionTextView.text = self.beer.descriptionText;
    self.detailServingLabel.text = self.beer.serving;
    
    self.detailABVLabel.text = self.beer.abv ? [self.beer.abv.stringValue stringByAppendingString:@"ABV"] : @"ABV Not Available";
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    self.detailPriceLabel.text = [formatter stringFromNumber:self.beer.price];
    
    if (self.beer.imageUrl) {
        NSURL *url = [NSURL URLWithString:self.beer.imageUrl];
        [self.detailImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ales_logo2"]];
    }
    
	self.quantityPicker.selectedTextColor = [UIColor whiteColor];
	self.quantityPicker.textColor   = [UIColor grayColor];
	self.quantityPicker.delegate    = self;
	self.quantityPicker.dataSource  = self;
	self.quantityPicker.elementFont = [UIFont normalFontOfSize:17.0f];
	self.quantityPicker.selectionPoint = CGPointMake(160, 0);
    [self.quantityPicker scrollToElement:0 animated:NO];
    
    self.showsCart = YES;
}

#pragma mark - V8HorizontalPickerViewDataSource

- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
    return self.quantityTitles.count;
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
	CGSize constrainedSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
	NSString *text = self.quantityTitles[index];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont normalFontOfSize:15.0f], NSParagraphStyleAttributeName: style};
    
    CGRect bounds = [text boundingRectWithSize:constrainedSize
                                       options:NSStringDrawingTruncatesLastVisibleLine
                                    attributes:attributes
                                       context:nil];
    
	return bounds.size.width + 40.0f; // 20px padding on each side
}

#pragma mark - V8HorizontalPickerViewDelegate

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)idx {
    [self setQuantityPickerVisible:NO];
    if ([self.quantityTitles[idx] integerValue]) {
        self.cartCount = [self.quantityTitles[idx] integerValue];
        [self.quantityButton setTitle:self.quantityTitles[idx] forState:UIControlStateNormal];
    }
}

- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
    return self.quantityTitles[index];
}

@end
