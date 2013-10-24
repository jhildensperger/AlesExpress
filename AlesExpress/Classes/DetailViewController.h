#import "LoginViewController.h"
#import "OrderViewController.h"

@interface DetailViewController : BaseViewController <LoginViewControllerDelegate, OrderViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *detailDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *detailServingLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailABVLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;

- (instancetype)initWithBeer:(Beer *)beer;
- (IBAction)orderButtonTapped:(id)sender;

@end
