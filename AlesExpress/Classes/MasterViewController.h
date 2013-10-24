#import <CoreData/CoreData.h>

#import "TTTAttributedLabel.h"

#import "LoginViewController.h"
#import "OrderViewController.h"

@interface MasterViewController : BaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UIActionSheetDelegate, LoginViewControllerDelegate, OrderViewControllerDelegate>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) UIImageView *bannerImageView;
@property (nonatomic) UIImageView *logoImageView;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) UILabel *pageLabel;
@property (nonatomic) UIButton *orderButton;
@property (nonatomic) UIActionSheet *sortActionSheet;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end
