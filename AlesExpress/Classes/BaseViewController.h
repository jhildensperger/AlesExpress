#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (assign, nonatomic) BOOL showsCart;
@property (assign, nonatomic) NSInteger cartCount;
@property (nonatomic) UIButton *cartButton;

@end
