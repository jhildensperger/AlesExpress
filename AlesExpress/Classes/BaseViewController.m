#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    if (!self.navigationController || self.navigationController.viewControllers[0] != self) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 25, 25)];
        [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *backImage = [UIImage maskedImageNamed:@"back" color:[UIColor whiteColor]];
        [backButton setImage:backImage forState:UIControlStateNormal];
        [self.view addSubview:backButton];
    }
}

@end