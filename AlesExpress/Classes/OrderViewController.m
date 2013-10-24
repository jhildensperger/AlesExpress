#import "OrderViewController.h"
#import "TRAPI.h"
#import "SVProgressHUD.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.allowsSelection = NO;

    self.beerPriceLabel.text = [NSString stringWithFormat:@"$%.2f", [self.beerToOrder.price floatValue]];

    [self stepperTapped:nil];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.delegate = nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self.view viewWithTag:indexPath.row] becomeFirstResponder];
}

#pragma mark - textField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.addressTextField) {
        [self.descriptionTextView becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ((self.addressTextField.text.length > 0)) {
        self.orderButton.enabled = YES;
    } else {
        self.orderButton.enabled = NO;
    }
    return YES;
}

#pragma mark - button methods

- (IBAction)cancelButtonTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(orderViewControllerDidCancel:)]) {
        [self.delegate orderViewControllerDidCancel:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)orderButtonTapped:(id)sender {
    [SVProgressHUD showWithStatus:@"posting task" maskType:SVProgressHUDMaskTypeGradient];
//
//    NSDictionary *pickup = @{
//    @"label"        : @"Beer Store",
//    @"address"      : @"2398 Webster Street",
//    @"city"         : @"San Francisco",
//    @"zipCode"      : @"94115",
//    @"state"        : @"CA",
//    @"latitude"     : [NSNumber numberWithDouble:37.792499],
//    @"longitude"    : [NSNumber numberWithDouble:-122.433058]
//    };
//
//    NSDictionary *dropoff = @{
//    @"label"        : @"TaskRabbit",
//    @"address"      : @"425 2nd St",
//    @"city"         : @"San Francisco",
//    @"zipCode"      : @"94107",
//    @"state"        : @"CA",
//    @"latitude"     : [NSNumber numberWithDouble:37.784168],
//    @"longitude"    : [NSNumber numberWithDouble:-122.394605]
//    };
//
//    NSNumber *totalCosts = [NSNumber numberWithFloat:(self.quantityStepper.value * [self.beerToOrder.price floatValue] + 10.0)*100];
//
//    [TRAPI postTaskWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:kTaskRabbitAccessTokenKey]
//                              Name:@"Deliver Now - Beer Me Now"
//                       description:self.descriptionTextView.text
//                    estimatedCosts:totalCosts
//                    pickUpLocation:pickup
//                   dropOffLocation:dropoff
//                           success:^() {
                               NSLog(@"Post success!");

                               if ([self.delegate respondsToSelector:@selector(orderViewControllerDidPostTask::)]) {
                                   [self.delegate orderViewControllerDidPostTask:self];
                               }

                               [SVProgressHUD showSuccessWithStatus:@"task posted!"];
                               [self dismissViewControllerAnimated:YES completion:nil];
//
//                           } failure:^(NSError *error) {
//                               NSLog(@"Post error:%@", error);
//                               [SVProgressHUD showErrorWithStatus:@"error posting task"];
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.localizedDescription
//                                                                               message:error.localizedRecoverySuggestion
//                                                                              delegate:self
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil];
//                               [alert show];
//                           }];
}

- (IBAction)stepperTapped:(id)sender {
    self.quantityLabel.text = [NSString stringWithFormat:@"%.0f", self.quantityStepper.value];
    self.subTototalLabel.text = [NSString stringWithFormat:@"$%.2f", (self.quantityStepper.value * [self.beerToOrder.price floatValue])];
    self.tototalLabel.text = [NSString stringWithFormat:@"$%.2f", (self.quantityStepper.value * [self.beerToOrder.price floatValue] + 10.0)];

    self.descriptionTextView.text = [NSString stringWithFormat:@"Beer me now with %.0f bottles of %@ beer.", self.quantityStepper.value, self.beerToOrder.name];
}

@end
