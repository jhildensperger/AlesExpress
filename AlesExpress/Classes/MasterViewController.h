#import <CoreData/CoreData.h>

#import "TTTAttributedLabel.h"

#import "LoginViewController.h"
#import "OrderViewController.h"

@interface MasterViewController : BaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UIActionSheetDelegate, LoginViewControllerDelegate, OrderViewControllerDelegate>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UILabel *pageLabel;
@property (nonatomic, weak) IBOutlet UIButton *orderButton;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end
