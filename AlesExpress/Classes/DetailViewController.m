
#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()

@property (nonatomic, assign) BOOL loggingInToOrder;

- (void)configureView;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    self.detailDescriptionTextView.font = [UIFont lightFontOfSize:16];
    self.detailABVLabel.font = [UIFont normalFontOfSize:18];
    self.detailNameLabel.font = [UIFont normalFontOfSize:18];
    self.detailPriceLabel.font = [UIFont normalFontOfSize:18];
    self.detailServingLabel.font = [UIFont normalFontOfSize:18];
    
    if (self.detailItem) {
        self.orderButton.layer.cornerRadius = 3;
        self.orderButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.orderButton.layer.borderWidth = 1;
        
        self.detailNameLabel.text = [[self.detailItem valueForKey:@"name"] description];
        self.detailDescriptionTextView.text = [[self.detailItem valueForKey:@"descriptionText"] description];
        self.detailServingLabel.text = [[self.detailItem valueForKey:@"serving"] description];
        
        if (![self.detailItem valueForKey:@"abv"]) self.detailABVLabel.text = @"Unknown ABV";
        else self.detailABVLabel.text = [NSString stringWithFormat:@"%@ %@",[[self.detailItem valueForKey:@"abv"] description], @"ABV"];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        self.detailPriceLabel.text = [formatter stringFromNumber:[self.detailItem valueForKey:@"price"]];
        
        if ([[self.detailItem valueForKey:@"imageUrl"] description])
        {
            NSURL *url = [NSURL URLWithString:[[self.detailItem valueForKey:@"imageUrl"] description]];
            [self.detailImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ales_logo2"]];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.loggingInToOrder) {
        [self presentOrderController];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
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

    orderController.beerToOrder = (Beer *)self.detailItem;
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

    [self presentViewController:navController
                       animated:YES
                     completion:^{
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

@end
