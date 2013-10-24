
#import "LoginViewController.h"
#import "TRAPI.h"
#import "SVProgressHUD.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (instancetype)init {
    if (self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(didTapCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(didTapLoginButton)];
    
    [self.emailTextField becomeFirstResponder];
    
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
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self didTapLoginButton];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ((self.emailTextField.text.length > 0) && (self.passwordTextField.text.length > 0)) {
        self.loginButton.enabled = YES;
    } else {
        self.loginButton.enabled = NO;
    }
    return YES;
}

#pragma mark - button methods

- (void)didTapCancelButton {
    if ([self.delegate respondsToSelector:@selector(loginViewControllerDidCancel:)]) {
        [self.delegate loginViewControllerDidCancel:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTapLoginButton {
    [SVProgressHUD showWithStatus:@"logging in" maskType:SVProgressHUDMaskTypeGradient];
    
//    [TRAPI loginWithEmail:self.emailTextField.text
//                  password:self.passwordTextField.text
//                   success:^(NSString *accessToken){
                       NSLog(@"login success!");

                       if ([self.delegate respondsToSelector:@selector(loginViewControllerDidCancel:)]) {
                           [self.delegate loginViewControllerDidLogin:self];
                       }

                       [SVProgressHUD showSuccessWithStatus:@"logged in!"];

//                       [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kTaskRabbitAccessTokenKey];

                       self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                       [self dismissViewControllerAnimated:YES completion:nil];

//                   } failure:^(NSError *error) {
//                       NSLog(@"login error:%@", error);
//                       [SVProgressHUD showErrorWithStatus:@"error logging in"];
//                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.localizedDescription
//                                                                       message:error.localizedRecoverySuggestion
//                                                                      delegate:self
//                                                             cancelButtonTitle:@"OK"
//                                                             otherButtonTitles:nil];
//                       [alert show];
//                   }];
}

@end
