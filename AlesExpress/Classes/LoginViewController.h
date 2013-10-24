@protocol LoginViewControllerDelegate;

@interface LoginViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField        *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField        *passwordTextField;
@property (nonatomic, weak) IBOutlet UIBarButtonItem    *loginButton;
@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;

@end

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidLogin:(LoginViewController *)loginViewController;
- (void)loginViewControllerDidCancel:(LoginViewController *)loginViewController;

@end