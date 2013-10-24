#import "LoginViewController.h"
#import "OrderViewController.h"

@interface DetailViewController : BaseViewController <LoginViewControllerDelegate, OrderViewControllerDelegate>

@property (nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *detailServingLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailABVLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;

- (IBAction)orderButtonTapped:(id)sender;

@end
