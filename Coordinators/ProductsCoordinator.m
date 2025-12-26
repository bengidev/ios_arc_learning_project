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
#import "ProductService.h"
#import "ProductServiceProtocol.h"
#import <os/log.h>

static os_log_t ProductsCoordinatorLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "ProductsCoordinator");
  });
  return log;
}

@interface ProductsCoordinator () <ProductListViewModelDelegate>
@property(nonatomic, strong) ProductListViewModel *viewModel;
@property(nonatomic, weak) ProductListViewController *listViewController;
@property(nonatomic, strong) id<ProductServiceProtocol> productService;
@end

@implementation ProductsCoordinator

#pragma mark - Initialization

- (instancetype)initWithNavigationController:
    (UINavigationController *)navigationController {
  // Use default service for backward compatibility
  return [self initWithNavigationController:navigationController
                             productService:[ProductService defaultService]];
}

- (instancetype)
    initWithNavigationController:(UINavigationController *)navigationController
                  productService:(id<ProductServiceProtocol>)productService {
  self = [super initWithNavigationController:navigationController];
  if (self) {
    _productService = productService;
  }
  return self;
}

#pragma mark - Lifecycle

- (void)start {
  os_log_info(ProductsCoordinatorLog(), "Starting products flow");

  // Create ViewModel with injected service
  self.viewModel =
      [[ProductListViewModel alloc] initWithProductService:self.productService];
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
  os_log_info(ProductsCoordinatorLog(),
              "Showing detail for product: %{public}@", product.productId);

  // Create child coordinator
  ProductDetailCoordinator *detailCoordinator =
      [[ProductDetailCoordinator alloc]
          initWithNavigationController:self.navigationController
                               product:product];

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

  // If not found, fetch from service
  if (!product) {
    os_log_info(ProductsCoordinatorLog(),
                "Product %{public}@ not in cache, fetching...", productId);

    __weak typeof(self) weakSelf = self;
    [self.productService
        fetchProductWithId:productId
                completion:^(Product *fetchedProduct, NSError *error) {
                  __strong typeof(weakSelf) strongSelf = weakSelf;
                  if (!strongSelf)
                    return;

                  if (fetchedProduct) {
                    [strongSelf showProductDetail:fetchedProduct];
                  } else {
                    os_log_error(ProductsCoordinatorLog(),
                                 "Product not found: %{public}@", productId);
                  }
                }];
    return;
  }

  [self showProductDetail:product];
}

#pragma mark - ProductListViewModelDelegate

- (void)viewModel:(ProductListViewModel *)viewModel
    didSelectProduct:(Product *)product {
  [self showProductDetail:product];
}

- (void)viewModelDidRefreshProducts:(ProductListViewModel *)viewModel {
  os_log_info(ProductsCoordinatorLog(), "Products refreshed, count: %lu",
              (unsigned long)viewModel.products.count);
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
  os_log_info(ProductsCoordinatorLog(), "Handling route: %{public}@",
              [route routeTypeString]);

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
  os_log_debug(ProductsCoordinatorLog(), "dealloc");
}

@end
