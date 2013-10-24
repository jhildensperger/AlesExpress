
#import <UIKit/UIKit.h>
#import "Beer.h"

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)setBeerInfo:(Beer *)beer;

@end
