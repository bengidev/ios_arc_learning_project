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

static os_log_t ProductListVCLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "ProductListVC");
  });
  return log;
}

@interface ProductListViewController () <
    UITableViewDataSource, UITableViewDelegate, ProductListViewModelDelegate>
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

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setupUI];
  [self setupBindings];

  // Load initial data
  [self.viewModel loadProducts];
}

#pragma mark - UI Setup

- (void)setupUI {
  self.title = @"Products";
  self.view.backgroundColor = [UIColor systemBackgroundColor];
  self.view.accessibilityIdentifier = kAccessibilityProductListTable;

  // Table View
  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                style:UITableViewStylePlain];
  self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = kCellHeight;
  self.tableView.accessibilityIdentifier = kAccessibilityProductListTable;
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kProductCellIdentifier];
  [self.view addSubview:self.tableView];

  // Refresh Control
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self
                          action:@selector(handleRefresh)
                forControlEvents:UIControlEventValueChanged];
  self.tableView.refreshControl = self.refreshControl;

  // Loading Indicator
  self.loadingIndicator = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
  self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = NO;
  self.loadingIndicator.hidesWhenStopped = YES;
  [self.view addSubview:self.loadingIndicator];

  // Constraints
  [NSLayoutConstraint activateConstraints:@[
    [self.tableView.topAnchor
        constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
    [self.tableView.leadingAnchor
        constraintEqualToAnchor:self.view.leadingAnchor],
    [self.tableView.trailingAnchor
        constraintEqualToAnchor:self.view.trailingAnchor],
    [self.tableView.bottomAnchor
        constraintEqualToAnchor:self.view.bottomAnchor],

    [self.loadingIndicator.centerXAnchor
        constraintEqualToAnchor:self.view.centerXAnchor],
    [self.loadingIndicator.centerYAnchor
        constraintEqualToAnchor:self.view.centerYAnchor]
  ]];
}

- (void)setupBindings {
  self.viewModel.delegate = self;

  __weak typeof(self) weakSelf = self;
  self.viewModel.onError = ^(NSError *error) {
    [weakSelf showError:error];
  };
}

#pragma mark - Actions

- (void)handleRefresh {
  [self.viewModel refresh];
}

- (void)showError:(NSError *)error {
  UIAlertController *alert =
      [UIAlertController alertControllerWithTitle:@"Error"
                                          message:error.localizedDescription
                                   preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                          handler:nil]];
  [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ProductListViewModelDelegate

- (void)productsDidLoad:(NSArray<Product *> *)products {
  os_log_info(ProductListVCLog(), "Received %lu products",
              (unsigned long)products.count);
  [self.refreshControl endRefreshing];
  [self.tableView reloadData];
}

- (void)didSelectProduct:(Product *)product {
  // Handled by coordinator via delegation
}

- (void)loadingStateDidChange:(BOOL)isLoading {
  if (isLoading && !self.refreshControl.isRefreshing) {
    [self.loadingIndicator startAnimating];
  } else {
    [self.loadingIndicator stopAnimating];
  }
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

  // Configure cell
  UIListContentConfiguration *config =
      [UIListContentConfiguration subtitleCellConfiguration];
  config.text = product.name;
  config.secondaryText = [NSString
      stringWithFormat:@"%@ • %@", [product formattedPrice], product.category];
  config.image = [UIImage systemImageNamed:@"cube.box"];

  cell.contentConfiguration = config;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.accessibilityIdentifier = [NSString
      stringWithFormat:@"%@_%@", kAccessibilityProductCell, product.productId];

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
  os_log_debug(ProductListVCLog(), "dealloc");
}

@end
