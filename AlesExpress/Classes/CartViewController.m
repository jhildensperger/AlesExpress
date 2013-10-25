#import "CartViewController.h"

@interface CartViewController ()

@end

@implementation CartViewController

- (instancetype)init {
    if (self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString *)title {
    return @"Cart";
}

@end
