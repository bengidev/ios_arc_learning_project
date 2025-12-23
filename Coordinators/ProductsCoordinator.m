//
//  ProductsCoordinator.m
//  MVVM-C-ARC
//
//  ProductsCoordinator Implementation
//  ARC Version
//

#import "ProductsCoordinator.h"
#import "DeepLinkRoute.h"
#import "Product.h"
#import "ProductDetailCoordinator.h"
#import "ProductListViewController.h"
#import "ProductListViewModel.h"

@interface ProductsCoordinator () <ProductListViewModelDelegate>
@property(nonatomic, strong) ProductListViewModel *viewModel;
@property(nonatomic, weak) ProductListViewController *listViewController;
@end

@implementation ProductsCoordinator

#pragma mark - Lifecycle

- (void)start {
  NSLog(@"[ProductsCoordinator] Starting products flow");

  // Create ViewModel
  self.viewModel = [[ProductListViewModel alloc] init];
  self.viewModel.delegate =
      self; // Weak reference in ViewModel prevents retain cycle

  // Create ViewController
  ProductListViewController *listVC =
      [[ProductListViewController alloc] initWithViewModel:self.viewModel];
  self.listViewController = listVC;

  // Push to navigation
  [self.navigationController pushViewController:listVC animated:YES];

  // Load products
  [self.viewModel loadProducts];
}

#pragma mark - Navigation

- (void)showProductDetail:(Product *)product {
  NSLog(@"[ProductsCoordinator] Showing detail for product: %@",
        product.productId);

  // Create child coordinator
  ProductDetailCoordinator *detailCoordinator =
      [[ProductDetailCoordinator alloc]
          initWithNavigationController:self.navigationController];
  detailCoordinator.product = product;

  // Add and start child
  [self addChildCoordinator:detailCoordinator];
  [detailCoordinator start];
}

- (void)showProductDetailWithId:(NSString *)productId {
  // Try to find product in current list
  Product *product = nil;
  for (Product *p in self.viewModel.products) {
    if ([p.productId isEqualToString:productId]) {
      product = p;
      break;
    }
  }

  // If not found, try sample data
  if (!product) {
    product = [Product sampleProductWithId:productId];
  }

  if (product) {
    [self showProductDetail:product];
  } else {
    NSLog(@"[ProductsCoordinator] Product not found: %@", productId);
  }
}

#pragma mark - ProductListViewModelDelegate

- (void)viewModel:(ProductListViewModel *)viewModel
    didSelectProduct:(Product *)product {
  [self showProductDetail:product];
}

- (void)viewModelDidRefreshProducts:(ProductListViewModel *)viewModel {
  NSLog(@"[ProductsCoordinator] Products refreshed, count: %ld",
        (long)viewModel.products.count);
}

#pragma mark - DeepLinkable

- (BOOL)canHandleRoute:(DeepLinkRoute *)route {
  switch (route.type) {
  case DeepLinkRouteTypeProductList:
  case DeepLinkRouteTypeProductDetail:
  case DeepLinkRouteTypeProductReviews:
    return YES;
  default:
    return NO;
  }
}

- (void)handleRoute:(DeepLinkRoute *)route {
  NSLog(@"[ProductsCoordinator] Handling route: %@", route);

  switch (route.type) {
  case DeepLinkRouteTypeProductList:
    // Already showing list, check for child routes
    if (route.childRoute) {
      [self handleRoute:route.childRoute];
    }
    break;

  case DeepLinkRouteTypeProductDetail:
    if (route.productId) {
      [self showProductDetailWithId:route.productId];

      // Forward child routes to detail coordinator
      if (route.childRoute && self.childCoordinators.lastObject) {
        id<Coordinator> child = self.childCoordinators.lastObject;
        if ([child conformsToProtocol:@protocol(DeepLinkable)]) {
          [(id<DeepLinkable>)child handleRoute:route.childRoute];
        }
      }
    }
    break;

  case DeepLinkRouteTypeProductReviews:
    // First show product detail, then reviews
    if (route.productId) {
      [self showProductDetailWithId:route.productId];

      // Forward reviews route to detail coordinator
      if (self.childCoordinators.lastObject) {
        id<Coordinator> child = self.childCoordinators.lastObject;
        if ([child conformsToProtocol:@protocol(DeepLinkable)]) {
          [(id<DeepLinkable>)child handleRoute:route];
        }
      }
    }
    break;

  default:
    break;
  }
}

#pragma mark - Debug

- (void)dealloc {
  NSLog(@"[ProductsCoordinator] dealloc");
}

@end
