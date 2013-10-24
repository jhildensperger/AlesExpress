#import <QuartzCore/QuartzCore.h>
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "CollectionViewCell.h"

@interface MasterViewController ()

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
                                self.collectionView.alpha = 1;
                                self.pageLabel.alpha = 1;
                                self.orderButton.alpha = 1;
                            } completion:nil];
                        }
                    }];
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

- (NSString *)title {
    return @"Choose Beer";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    CGRect searchBarFrame = self.searchBar.frame;

    if (searchBarFrame.origin.y == 0.0) {

        searchBarFrame.origin.y = -44.0;
        [self.searchBar resignFirstResponder];

        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationCurveEaseInOut
                         animations:^{
                             self.searchBar.frame = searchBarFrame;
                         } completion:nil];
    }
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
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithBeer:[self.fetchedResultsController objectAtIndexPath:indexPath]];
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

#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *selectedKey;
    switch (buttonIndex) {
        case 0: selectedKey = @"name";
            break;
        case 1: selectedKey = @"price";
            break;
        case 2: selectedKey = @"abv";
            break;
        default: //Cancel Button click...Do Nothing
            break;
    }
    
    if (buttonIndex != 3) {
        if ([self.sortByKey isEqualToString:selectedKey]) {
            self.sortAscending = !self.sortAscending;
        }else {
            self.sortByKey = selectedKey;
            self.sortAscending = YES;
        }
        
        [self filter:self.searchBar.text];
        [self changeSortSheetWithIndex:buttonIndex];
    }
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
    
    
    // Looks bad, but the following handles the case when indexString is equal to totalString
    self.pageLabel.text = [NSString stringWithFormat:@"%@ of %@ by %@", indexString, totalString, self.sortByKey];
}

#pragma mark - UIControl setup methods

- (void)changeSortSheetWithIndex:(NSInteger)buttonIndex {
    NSString *nameTitle = [@"Name  " stringByAppendingString:(buttonIndex == 0 && self.sortAscending) ? @"▼" : @"▲"];
    NSString *priceTitle = [@"Price  " stringByAppendingString:(buttonIndex == 0 && self.sortAscending) ? @"▼" : @"▲"];
    NSString *abvTitle = [@"ABV  " stringByAppendingString:(buttonIndex == 0 && self.sortAscending) ? @"▼" : @"▲"];
   
    self.sortingTitles = @[nameTitle, priceTitle, abvTitle];
}

- (void)setupView {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(didTapSortButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(didTapSearchButton)];
    self.pageLabel.font = [UIFont normalFontOfSize:14];
    self.orderButton.titleLabel.font = [UIFont normalFontOfSize:20.0];
    self.orderButton.layer.borderColor = [UIColor colorWithWhite:.9 alpha:1].CGColor;
    self.orderButton.layer.borderWidth = 1;
    self.orderButton.layer.cornerRadius = 5;
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

- (IBAction)orderButtonTapped:(id)sender {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kTaskRabbitAccessTokenKey];;

    if (accessToken) {
        if ((self.selectedBeerIndex < self.filteredData.count) && (self.selectedBeerIndex > -1)) {
            [self presentOrderController];
        }
    } else {
        [self presentLoginController];
    }
}

- (void)didTapSearchButton {
    [self setSearchBarVisible:YES];
}

- (void)setSearchBarVisible:(BOOL)isVisible {
    CGRect searchBarFrame = self.searchBar.frame;
    
    if (searchBarFrame.origin.y < 0.0) {
        searchBarFrame.origin.y = 0.0;
        [self.searchBar becomeFirstResponder];
    }
    else {
        searchBarFrame.origin.y = -44.0;
        [self.searchBar resignFirstResponder];
    }
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.searchBar.frame = searchBarFrame;
                     } completion:nil];
}

- (void)didTapSortButton {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort Beers" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    [self.sortingTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        [actionSheet addButtonWithTitle:title];
    }];
    
    [actionSheet showInView:self.view];
}

@end
