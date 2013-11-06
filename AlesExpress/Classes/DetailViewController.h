#import "LoginViewController.h"
#import "OrderViewController.h"

@class V8HorizontalPickerView;

@interface DetailViewController : BaseViewController <LoginViewControllerDelegate, OrderViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *detailDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *detailServingLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailABVLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;
@property (weak, nonatomic) IBOutlet UIButton *quantityButton;
@property (weak, nonatomic) IBOutlet V8HorizontalPickerView *quantityPicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quantityPickerTopConstraint;

- (instancetype)initWithBeer:(Beer *)beer;

@end
