
#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()

@property (nonatomic, assign) BOOL loggingInToOrder;
@property (nonatomic) Beer *beer;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (instancetype)initWithBeer:(Beer *)beer {
    if (self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil]) {
        self.beer = beer;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.loggingInToOrder) {
        [self presentOrderController];
    }
}

- (NSString *)title {
    return self.beer.name;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
    
    self.backgroundImageView.image = [[UIImage imageNamed:@"beer_glass"] applyDarkEffect];
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

- (void)orderButtonTapped:(id)sender {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kTaskRabbitAccessTokenKey];;

    if (accessToken) {

        [self presentOrderController];
    } else {
        [self presentLoginController];
    }
}

- (void)configureView {
    self.detailDescriptionTextView.font = [UIFont normalFontOfSize:14];
    self.detailABVLabel.font = [UIFont normalFontOfSize:18];
    self.detailPriceLabel.font = [UIFont normalFontOfSize:30];
    self.detailServingLabel.font = [UIFont normalFontOfSize:18];
    
    self.orderButton.titleLabel.font = [UIFont normalFontOfSize:20.0];
    self.orderButton.layer.cornerRadius = 3;
    self.orderButton.layer.borderColor = [UIColor colorWithWhite:.9 alpha:1].CGColor;
    self.orderButton.layer.borderWidth = 1;
    
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
}

@end
