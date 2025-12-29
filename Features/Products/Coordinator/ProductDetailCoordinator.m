//
//  ProductDetailCoordinator.m
//  MVVM-C-ARC
//
//  ProductDetailCoordinator Implementation
//  ARC Version
//

#import "ProductDetailCoordinator.h"
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

@interface ProductDetailCoordinator ()
@property(nonatomic, strong) id<ProductServiceProtocol> productService;
@property(nonatomic, copy) NSString *productId;
@property(nonatomic, strong) Product *product;
@end

@implementation ProductDetailCoordinator

#pragma mark - Initialization

- (instancetype)
    initWithNavigationController:(UINavigationController *)navigationController
                       productId:(NSString *)productId
                  productService:(id<ProductServiceProtocol>)productService {
  NSParameterAssert(productId != nil);
  NSParameterAssert(productService != nil);

  self = [super initWithNavigationController:navigationController];
  if (self) {
    _productId = [productId copy];
    _productService = productService;
  }
  return self;
}

- (instancetype)
    initWithNavigationController:(UINavigationController *)navigationController
                         product:(Product *)product
                  productService:(id<ProductServiceProtocol>)productService {
  NSParameterAssert(product != nil);
  NSParameterAssert(productService != nil);

  self = [super initWithNavigationController:navigationController];
  if (self) {
    _product = product;
    _productId = [product.productId copy];
    _productService = productService;
  }
  return self;
}

#pragma mark - Lifecycle

- (void)start {
  os_log_info(ProductDetailCoordinatorLog(),
              "Starting product detail flow for: %{public}@", self.productId);

  ProductDetailViewModel *viewModel;

  if (self.product) {
    viewModel = [[ProductDetailViewModel alloc] initWithProduct:self.product];
  } else {
    viewModel = [[ProductDetailViewModel alloc]
        initWithProductService:self.productService
                     productId:self.productId];
  }

  ProductDetailViewController *detailVC =
      [[ProductDetailViewController alloc] initWithViewModel:viewModel];

  [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Debug

- (void)dealloc {
  os_log_debug(ProductDetailCoordinatorLog(), "dealloc");
}

@end
