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
@property(nonatomic, strong, readwrite) id<ProductServiceProtocol>
    productService;
@property(nonatomic, strong) ProductListViewModel *viewModel;
@end

@implementation ProductsCoordinator

#pragma mark - Initialization

- (instancetype)
    initWithNavigationController:(UINavigationController *)navigationController
                  productService:(id<ProductServiceProtocol>)productService {
  NSParameterAssert(productService != nil);

  self = [super initWithNavigationController:navigationController];
  if (self) {
    _productService = productService;
  }
  return self;
}

#pragma mark - Lifecycle

- (void)start {
  os_log_info(ProductsCoordinatorLog(), "Starting products flow");

  // Create ViewModel
  self.viewModel =
      [[ProductListViewModel alloc] initWithProductService:self.productService];
  self.viewModel.delegate = self;

  // Create ViewController
  ProductListViewController *listVC =
      [[ProductListViewController alloc] initWithViewModel:self.viewModel];

  // Push to navigation
  [self.navigationController setViewControllers:@[ listVC ] animated:NO];
}

#pragma mark - Navigation

- (void)showProductDetailWithId:(NSString *)productId {
  os_log_info(ProductsCoordinatorLog(), "Showing product detail: %{public}@",
              productId);

  ProductDetailCoordinator *detailCoordinator =
      [[ProductDetailCoordinator alloc]
          initWithNavigationController:self.navigationController
                             productId:productId
                        productService:self.productService];

  [self addChildCoordinator:detailCoordinator];
  [detailCoordinator start];
}

- (void)showProductDetailWithProduct:(Product *)product {
  os_log_info(ProductsCoordinatorLog(),
              "Showing product detail for: %{public}@", product.name);

  ProductDetailCoordinator *detailCoordinator =
      [[ProductDetailCoordinator alloc]
          initWithNavigationController:self.navigationController
                               product:product
                        productService:self.productService];

  [self addChildCoordinator:detailCoordinator];
  [detailCoordinator start];
}

#pragma mark - ProductListViewModelDelegate

- (void)productsDidLoad:(NSArray<Product *> *)products {
  // No-op, handled by view controller
}

- (void)didSelectProduct:(Product *)product {
  [self showProductDetailWithProduct:product];
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

  // Pop to root first
  [self.navigationController popToRootViewControllerAnimated:NO];
  [self removeAllChildCoordinators];

  switch (route.type) {
  case DeepLinkRouteTypeProductList:
    // Already at product list
    break;

  case DeepLinkRouteTypeProductDetail:
  case DeepLinkRouteTypeProductReviews:
    if (route.productId) {
      [self showProductDetailWithId:route.productId];
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
