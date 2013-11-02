#import "SideViewController.h"
#import "KGNoise.h"
#import "IIViewDeckController.h"

@interface SideViewController ()

@property (nonatomic) NSArray *menuOptionTitles;

@end

@implementation SideViewController

- (id)init {
    if (self = [super initWithNibName:nil bundle:nil]) {
        [(KGNoiseLinearGradientView *)self.view setBackgroundColor:[UIColor colorWithWhite:.2 alpha:1]];
        [(KGNoiseLinearGradientView *)self.view setNoiseOpacity:.015];
        [(KGNoiseLinearGradientView *)self.view setNoiseBlendMode:kCGBlendModeHardLight];
        self.menuOptionTitles = @[@"Featured", @"Stores", @"Favorites", @"Order History", @"Support"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuOptionTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"SideTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 60)];
    UIView *highlightView = [[UIView alloc] initWithFrame:CGRectInset(backgroundView.frame, 10, 10)];
    highlightView.backgroundColor = [[UIColor darkTextColor] colorWithAlphaComponent:.4];
    highlightView.layer.cornerRadius = 4;
    [backgroundView addSubview:highlightView];
    cell.selectedBackgroundView = backgroundView;
    
    cell.textLabel.textColor = [UIColor colorWithWhite:.8 alpha:1];
    cell.textLabel.font = [UIFont normalFontOfSize:18];
    cell.textLabel.text = self.menuOptionTitles[indexPath.row];

    return cell;
}

@end
