#import "Beer.h"

@protocol OrderViewControllerDelegate;

@interface OrderViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField        *addressTextField;
@property (nonatomic, weak) IBOutlet UITextView         *descriptionTextView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem    *orderButton;
@property (nonatomic, weak) IBOutlet UILabel            *quantityLabel;
@property (nonatomic, weak) IBOutlet UILabel            *beerPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel            *subTototalLabel;
@property (nonatomic, weak) IBOutlet UILabel            *tototalLabel;
@property (nonatomic, weak) IBOutlet UIStepper          *quantityStepper;

@property (nonatomic, weak) id<OrderViewControllerDelegate> delegate;

@property (nonatomic) Beer *beerToOrder;

- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)orderButtonTapped:(id)sender;
- (IBAction)stepperTapped:(id)sender;

@end

@protocol OrderViewControllerDelegate <NSObject>

- (void)orderViewControllerDidPostTask:(OrderViewController *)loginViewController;
- (void)orderViewControllerDidCancel:(OrderViewController *)loginViewController;

@end