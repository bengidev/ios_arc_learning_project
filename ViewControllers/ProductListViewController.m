//
//  ProductListViewController.m
//  MVVM-C-ARC
//
//  ProductListViewController Implementation
//  ARC Version
//

#import "ProductListViewController.h"
#import "DesignConstants.h"
#import "Product.h"
#import "ProductListViewModel.h"
#import <os/log.h>

static NSString *const kProductCellIdentifier = @"ProductCell";

static os_log_t ProductListViewControllerLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "ProductListViewController");
  });
  return log;
}

@interface ProductListViewController () <UITableViewDataSource,
                                         UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIRefreshControl *refreshControl;
@property(nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@end

@implementation ProductListViewController

#pragma mark - Initialization

- (instancetype)initWithViewModel:(ProductListViewModel *)viewModel {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _viewModel = viewModel;
  }
  return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setupUI];
  [self setupAccessibility];
  [self setupBindings];
  [self.viewModel loadProducts];
}

- (void)setupUI {
  self.title = @"Products";
  self.view.backgroundColor = [UIColor systemBackgroundColor];

  // Setup TableView
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                style:UITableViewStylePlain];
  self.tableView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 80;
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kProductCellIdentifier];
  [self.view addSubview:self.tableView];

  // Setup RefreshControl
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self
                          action:@selector(handleRefresh)
                forControlEvents:UIControlEventValueChanged];
  self.tableView.refreshControl = self.refreshControl;

  // Setup Loading Indicator
  self.loadingIndicator = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
  self.loadingIndicator.center = self.view.center;
  self.loadingIndicator.hidesWhenStopped = YES;
  [self.view addSubview:self.loadingIndicator];
}

- (void)setupAccessibility {
  self.tableView.accessibilityIdentifier = kAccessibilityProductListTableView;
  self.refreshControl.accessibilityIdentifier = kAccessibilityRefreshControl;
  self.tableView.accessibilityLabel = @"Products list";
}

- (void)setupBindings {
  // Using weak self to avoid retain cycles in blocks
  __weak typeof(self) weakSelf = self;

  self.viewModel.onRefreshComplete = ^(BOOL success) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf)
      return;

    [strongSelf.refreshControl endRefreshing];
    [strongSelf.loadingIndicator stopAnimating];
    [strongSelf.tableView reloadData];

    os_log_info(ProductListViewControllerLog(), "Refresh complete, success: %d",
                success);
  };

  self.viewModel.onError = ^(NSError *error) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf)
      return;

    os_log_error(ProductListViewControllerLog(), "Error: %{public}@",
                 error.localizedDescription);

    // Show error alert
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"Error"
                         message:error.localizedDescription
                  preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    [strongSelf presentViewController:alert animated:YES completion:nil];
  };
}

#pragma mark - Actions

- (void)handleRefresh {
  [self.viewModel loadProducts];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [self.viewModel numberOfProducts];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:kProductCellIdentifier
                                      forIndexPath:indexPath];

  Product *product = [self.viewModel productAtIndex:indexPath.row];

  UIListContentConfiguration *config =
      [UIListContentConfiguration subtitleCellConfiguration];
  config.text = product.name;
  config.secondaryText = [NSString
      stringWithFormat:@"$%.2f • %.1f ★", product.price, product.rating];
  config.secondaryTextProperties.color = [UIColor secondaryLabelColor];

  cell.contentConfiguration = config;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  // Accessibility
  cell.accessibilityIdentifier = [NSString
      stringWithFormat:@"%@_%@", kAccessibilityProductCell, product.productId];
  cell.accessibilityLabel =
      [NSString stringWithFormat:@"%@, $%.2f, %.1f stars", product.name,
                                 product.price, product.rating];

  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self.viewModel selectProductAtIndex:indexPath.row];
}

#pragma mark - Debug

- (void)dealloc {
  os_log_debug(ProductListViewControllerLog(), "dealloc");
}

@end
