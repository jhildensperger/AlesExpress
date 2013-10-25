#import <CoreData/CoreData.h>
#import "LoginViewController.h"
#import "OrderViewController.h"

@interface MasterViewController : BaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UIActionSheetDelegate, LoginViewControllerDelegate, OrderViewControllerDelegate>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UILabel *pageLabel;
@property (nonatomic, weak) IBOutlet UIButton *refineButton;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, weak) IBOutlet UIView *searchBarContainerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *searchBarBottomContraint;

@end
