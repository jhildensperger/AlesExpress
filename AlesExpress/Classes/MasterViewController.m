#import <QuartzCore/QuartzCore.h>
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "CollectionViewCell.h"

//Externals
#import "IIViewDeckController.h"
#import "RNGridMenu.h"

@interface MasterViewController () <RNGridMenuDelegate>

@property (nonatomic) NSMutableArray *filteredData;
@property (nonatomic) NSString *sortByKey;
@property (nonatomic, assign) BOOL sortAscending;
@property (nonatomic, assign) BOOL loggingInToOrder;
@property (nonatomic, assign) int selectedBeerIndex;
@property (nonatomic) NSArray *sortingTitles;

- (void)configureCell:(CollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation MasterViewController

- (instancetype)init {
    if (self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil]) {
        self.sortByKey = @"name";
        self.sortAscending = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.sortByKey = @"name";
        self.sortAscending = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass(CollectionViewCell.class) bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"BeerCell"];
    [self filter:@""];
    
    [self changeSortSheetWithIndex:0];
    
    [self setupView];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.searchBar.text.length) {
        [self setSearchBarVisible:YES];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.loggingInToOrder) {
        [self presentOrderController];
    }
    
    [UIView transitionWithView:self.backgroundImageView
                      duration:.25
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                    self.backgroundImageView.image = [[UIImage imageNamed:@"beer_glass"] applyDarkEffect];
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                [UIApplication sharedApplication].statusBarHidden = NO;
                                self.logoImageView.alpha = 1;
                                self.collectionView.alpha = 1;
                                self.pageLabel.alpha = 1;
                                self.refineButton.alpha = 1;
                                self.cartButton.alpha = 1;
                                self.menuButton.alpha = 1;
                                self.searchButton.alpha = 1;
                            } completion:nil];
                        }
                    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setSearchBarVisible:NO];
}

- (NSString *)title {
    return @"Ales Unlimited";
}

- (void)viewDeckController:(IIViewDeckController *)viewDeckController applyShadow:(CALayer *)shadowLayer withBounds:(CGRect)rect {
    shadowLayer.shadowOpacity = 0;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int rowCount = self.filteredData.count;
    if (rowCount == 0) self.pageLabel.text = @"No Results";
    return rowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setPageLabelForCollectionView:collectionView indexPath:indexPath];
    
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"BeerCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithBeer:self.filteredData[indexPath.row]];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Beer" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)configureCell:(CollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Beer *beer = [self.filteredData objectAtIndex:indexPath.row];
    [cell setBeerInfo:beer];
}

#pragma mark UISearchBarDelegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filter:searchBar.text];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self setSearchBarVisible:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self setSearchBarVisible:NO];
}

#pragma mark - RNGridMenuDelegate

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    NSString *selectedKey = [[item.title lowercaseString] stringByReplacingOccurrencesOfString:@"  ▼" withString:@""];
    selectedKey = [selectedKey stringByReplacingOccurrencesOfString:@"  ▲" withString:@""];
    
    if ([item.title isEqualToString:@"Cancel"]) {
        return;
    }
    
    if ([self.sortByKey isEqualToString:selectedKey]) {
        self.sortAscending = !self.sortAscending;
    } else {
        self.sortByKey = selectedKey;
        self.sortAscending = YES;
    }
    
    [self filter:self.searchBar.text];
    [self changeSortSheetWithIndex:itemIndex];
}

#pragma mark Filter

- (void)filter:(NSString *)text {
    self.filteredData = [[NSMutableArray alloc] init];
    
    // Create our fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Define the entity we are looking for
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Beer" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Define how we want our entities to be sorted
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:self.sortByKey ascending:self.sortAscending];

    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // If we are searching for anything...
    if(text.length > 0)
    {
        // Define how we want our entities to be filtered
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", text];
        [fetchRequest setPredicate:predicate];
    }
    
    NSError *error;
    
    // Finally, perform the load
    NSArray* loadedEntities = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    self.filteredData = [[NSMutableArray alloc] initWithArray:loadedEntities];
    
    [self.collectionView reloadData];
}

#pragma mark - loginViewControllerDelegate methods

- (void)loginViewControllerDidCancel:(LoginViewController *)loginViewController {
    self.loggingInToOrder = NO;
}

- (void)loginViewControllerDidLogin:(LoginViewController *)loginViewController {

}

#pragma mark - orderViewControllerDelegate methods

- (void)orderViewControllerDidCancel:(OrderViewController *)loginViewController {
    self.loggingInToOrder = NO;
}

- (void)orderViewControllerDidPostTask:(OrderViewController *)loginViewController {

}

#pragma mark - set page label

- (void)setPageLabelForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    NSString *indexString;
    NSString *totalString = [NSString stringWithFormat:@"%d",[collectionView numberOfItemsInSection:0]];
    
    if (self.sortAscending) {
        indexString = [NSString stringWithFormat:@"%d",indexPath.row+1];
        self.selectedBeerIndex = indexPath.row;
    } else {
        indexString = [NSString stringWithFormat:@"%d",[collectionView numberOfItemsInSection:0] - indexPath.row];
        self.selectedBeerIndex = [collectionView numberOfItemsInSection:0] - indexPath.row - 1;
    }

    self.pageLabel.text = [NSString stringWithFormat:@"%@ of %@ by %@", indexString, totalString, self.sortByKey];
}

#pragma mark - UIControl setup methods

- (void)changeSortSheetWithIndex:(NSInteger)buttonIndex {
    NSString *nameTitle = [@"Name  " stringByAppendingString:(buttonIndex == 0 && self.sortAscending) ? @"▲" : @"▼"];
    NSString *priceTitle = [@"Price  " stringByAppendingString:(buttonIndex == 1 && self.sortAscending) ? @"▲" : @"▼"];
    NSString *abvTitle = [@"ABV  " stringByAppendingString:(buttonIndex == 2 && self.sortAscending) ? @"▲" : @"▼"];
   
    self.sortingTitles = @[nameTitle, priceTitle, abvTitle, @"Cancel"];
}

- (void)setupView {
    self.pageLabel.font = [UIFont normalFontOfSize:14];
    self.showsCart = YES;
    self.cartButton.alpha = 0;
}

#pragma mark - button methods

- (void)presentOrderController {
    UINavigationController *navController = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"orderVC"];
    OrderViewController *orderController = (OrderViewController *)navController.topViewController;
    
    NSManagedObject *object = [self.filteredData objectAtIndex:self.selectedBeerIndex];
    orderController.beerToOrder = (Beer *)object;
    orderController.delegate = self;

    [self presentViewController:navController
                       animated:YES
                     completion:^{
        self.loggingInToOrder = NO;
    }];
}

- (void)presentLoginController {
    LoginViewController *loginController = [[LoginViewController alloc] init];
    loginController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginController];
    [self presentViewController:navController
                       animated:YES
                     completion:^{
                         self.loggingInToOrder = YES;
                     }];
}

- (IBAction)didTapRefineButton:(id)sender {
    NSArray *options = self.sortingTitles;
    RNGridMenu *av = [[RNGridMenu alloc] initWithTitles:options];
    av.delegate = self;
    av.itemFont = [UIFont normalFontOfSize:22];
    av.itemSize = CGSizeMake(150, 55);
    av.highlightColor = [UIColor colorWithWhite:.6 alpha:1];
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (IBAction)didTapMenuButton:(id)sender {
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (IBAction)didTapSearchButton:(id)sender {
    [self setSearchBarVisible:YES];
}

- (void)setSearchBarVisible:(BOOL)isVisible {
    if (isVisible) {
        [self.searchBar becomeFirstResponder];
    } else {
        [self.searchBar resignFirstResponder];
    }
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.menuButton.alpha = !isVisible;
                         self.cartButton.alpha = !isVisible;
                         self.searchBarContainerView.alpha = isVisible;
                         self.searchBar.alpha = isVisible;
                     } completion:nil];
}

@end
