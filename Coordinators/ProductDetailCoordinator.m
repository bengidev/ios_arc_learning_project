//
//  ProductDetailCoordinator.m
//  MVVM-C-ARC
//
//  ProductDetailCoordinator Implementation
//  ARC Version
//

#import "ProductDetailCoordinator.h"
#import "DeepLinkRoute.h"
#import "DesignConstants.h"
#import "Product.h"
#import "ProductDetailViewController.h"
#import "ProductDetailViewModel.h"
#import <os/log.h>

static os_log_t ProductDetailCoordinatorLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "ProductDetailCoordinator");
  });
  return log;
}

@interface ProductDetailCoordinator () <ProductDetailViewModelDelegate>
@property(nonatomic, strong) ProductDetailViewModel *viewModel;
@property(nonatomic, weak) ProductDetailViewController *detailViewController;
@end

@implementation ProductDetailCoordinator

#pragma mark - Initialization

- (instancetype)initWithNavigationController:
                    (UINavigationController *)navigationController
                                     product:(Product *)product {
  self = [super initWithNavigationController:navigationController];
  if (self) {
    _product = product;
  }
  return self;
}

#pragma mark - Lifecycle

- (void)start {
  if (!self.product) {
    os_log_error(ProductDetailCoordinatorLog(), "ERROR: No product set");
    return;
  }

  os_log_info(ProductDetailCoordinatorLog(),
              "Starting detail flow for: %{public}@", self.product.productId);

  // Create ViewModel
  self.viewModel =
      [[ProductDetailViewModel alloc] initWithProduct:self.product];
  self.viewModel.delegate =
      self; // Weak reference in ViewModel prevents retain cycle

  // Create ViewController
  ProductDetailViewController *detailVC =
      [[ProductDetailViewController alloc] initWithViewModel:self.viewModel];
  self.detailViewController = detailVC;

  // Push to navigation
  [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Navigation

- (void)showReviews {
  os_log_info(ProductDetailCoordinatorLog(),
              "Showing reviews for product: %{public}@",
              self.product.productId);

  // Create a simple reviews view controller
  UIViewController *reviewsVC = [[UIViewController alloc] init];
  reviewsVC.view.backgroundColor = [UIColor systemBackgroundColor];
  reviewsVC.title =
      [NSString stringWithFormat:@"Reviews for %@", self.product.name];

  // Add a label with review info
  UILabel *label = [[UILabel alloc] init];
  label.text = [NSString
      stringWithFormat:@"%ld reviews\n⭐️ %.1f average rating",
                       (long)self.product.reviewCount, self.product.rating];
  label.numberOfLines = 0;
  label.textAlignment = NSTextAlignmentCenter;
  label.font = [UIFont systemFontOfSize:kPaddingLarge];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  label.accessibilityIdentifier = @"reviewsInfoLabel";
  [reviewsVC.view addSubview:label];

  [NSLayoutConstraint activateConstraints:@[
    [label.centerXAnchor constraintEqualToAnchor:reviewsVC.view.centerXAnchor],
    [label.centerYAnchor constraintEqualToAnchor:reviewsVC.view.centerYAnchor]
  ]];

  [self.navigationController pushViewController:reviewsVC animated:YES];
}

- (void)showAddToCartConfirmation {
  UIAlertController *alert = [UIAlertController
      alertControllerWithTitle:@"Added to Cart"
                       message:[NSString stringWithFormat:
                                             @"%@ has been added to your cart.",
                                             self.product.name]
                preferredStyle:UIAlertControllerStyleAlert];

  [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                          handler:nil]];

  __weak typeof(self) weakSelf = self;
  [alert addAction:[UIAlertAction
                       actionWithTitle:@"View Cart"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                 __strong typeof(weakSelf) strongSelf =
                                     weakSelf;
                                 if (!strongSelf)
                                   return;
                                 os_log_info(ProductDetailCoordinatorLog(),
                                             "Navigate to cart requested");
                               }]];

  [self.navigationController presentViewController:alert
                                          animated:YES
                                        completion:nil];
}

#pragma mark - ProductDetailViewModelDelegate

- (void)viewModelDidRequestReviews:(ProductDetailViewModel *)viewModel {
  [self showReviews];
}

- (void)viewModelDidRequestAddToCart:(ProductDetailViewModel *)viewModel {
  [self showAddToCartConfirmation];
}

- (void)viewModelDidRequestDismiss:(ProductDetailViewModel *)viewModel {
  [self.navigationController popViewControllerAnimated:YES];
  [self finish];
}

#pragma mark - DeepLinkable

- (BOOL)canHandleRoute:(DeepLinkRoute *)route {
  switch (route.type) {
  case DeepLinkRouteTypeProductReviews:
    return YES;
  default:
    return NO;
  }
}

- (void)handleRoute:(DeepLinkRoute *)route {
  os_log_info(ProductDetailCoordinatorLog(), "Handling route: %{public}@",
              [route routeTypeString]);

  switch (route.type) {
  case DeepLinkRouteTypeProductReviews:
    [self showReviews];
    break;

  default:
    break;
  }
}

#pragma mark - Debug

- (void)dealloc {
  os_log_debug(ProductDetailCoordinatorLog(), "dealloc - product: %{public}@",
               self.product.productId);
}

@end
