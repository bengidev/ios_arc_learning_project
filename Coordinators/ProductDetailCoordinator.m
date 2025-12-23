//
//  ProductDetailCoordinator.m
//  MVVM-C-ARC
//
//  ProductDetailCoordinator Implementation
//  ARC Version
//

#import "ProductDetailCoordinator.h"
#import "DeepLinkRoute.h"
#import "Product.h"
#import "ProductDetailViewController.h"
#import "ProductDetailViewModel.h"

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
    NSLog(@"[ProductDetailCoordinator] ERROR: No product set");
    return;
  }

  NSLog(@"[ProductDetailCoordinator] Starting detail flow for: %@",
        self.product.productId);

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
  NSLog(@"[ProductDetailCoordinator] Showing reviews for product: %@",
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
  label.font = [UIFont systemFontOfSize:20];
  label.translatesAutoresizingMaskIntoConstraints = NO;
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
  [alert
      addAction:
          [UIAlertAction
              actionWithTitle:@"View Cart"
                        style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction *action) {
                        // Would navigate to cart here
                        NSLog(@"[ProductDetailCoordinator] Navigate to cart");
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
  NSLog(@"[ProductDetailCoordinator] Handling route: %@", route);

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
  NSLog(@"[ProductDetailCoordinator] dealloc - product: %@",
        self.product.productId);
}

@end
