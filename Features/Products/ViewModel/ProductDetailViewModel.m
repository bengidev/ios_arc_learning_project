//
//  ProductDetailViewModel.m
//  MVVM-C-ARC
//
//  ProductDetailViewModel Implementation
//  ARC Version
//

#import "ProductDetailViewModel.h"
#import "Product.h"
#import <os/log.h>

static os_log_t ProductDetailViewModelLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "ProductDetailViewModel");
  });
  return log;
}

@interface ProductDetailViewModel ()
@property(nonatomic, strong) id<ProductServiceProtocol> productService;
@property(nonatomic, copy) NSString *productId;
@property(nonatomic, strong, readwrite) Product *product;
@property(nonatomic, assign, readwrite) BOOL isLoading;
@end

@implementation ProductDetailViewModel

#pragma mark - Initialization

- (instancetype)initWithProductService:
                    (id<ProductServiceProtocol>)productService
                             productId:(NSString *)productId {
  NSParameterAssert(productService != nil);
  NSParameterAssert(productId != nil);

  self = [super init];
  if (self) {
    _productService = productService;
    _productId = [productId copy];
    _isLoading = NO;
  }
  return self;
}

- (instancetype)initWithProduct:(Product *)product {
  NSParameterAssert(product != nil);

  self = [super init];
  if (self) {
    _product = product;
    _productId = [product.productId copy];
    _isLoading = NO;
  }
  return self;
}

#pragma mark - Data Loading

- (void)loadProductDetails {
  // If we already have the product, just notify delegate
  if (self.product) {
    os_log_info(ProductDetailViewModelLog(),
                "Using existing product: %{public}@", self.product.name);
    if ([self.delegate respondsToSelector:@selector(productDidLoad:)]) {
      [self.delegate productDidLoad:self.product];
    }
    return;
  }

  if (self.isLoading) {
    return;
  }

  os_log_info(ProductDetailViewModelLog(), "Loading product: %{public}@",
              self.productId);

  self.isLoading = YES;
  [self notifyLoadingStateChanged];

  __weak typeof(self) weakSelf = self;
  [self.productService
      fetchProductWithId:self.productId
              completion:^(Product *product, NSError *error) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf)
                  return;

                strongSelf.isLoading = NO;
                [strongSelf notifyLoadingStateChanged];

                if (error) {
                  os_log_error(ProductDetailViewModelLog(),
                               "Failed to load product: %{public}@",
                               error.localizedDescription);
                  if (strongSelf.onError) {
                    strongSelf.onError(error);
                  }
                  return;
                }

                strongSelf.product = product;
                os_log_info(ProductDetailViewModelLog(),
                            "Loaded product: %{public}@", product.name);

                if ([strongSelf.delegate
                        respondsToSelector:@selector(productDidLoad:)]) {
                  [strongSelf.delegate productDidLoad:product];
                }
              }];
}

#pragma mark - Actions

- (void)addToCart {
  if (!self.product) {
    return;
  }

  os_log_info(ProductDetailViewModelLog(), "Adding to cart: %{public}@",
              self.product.name);

  // Simulate adding to cart
  dispatch_after(
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
      dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(didAddToCart:)]) {
          [self.delegate didAddToCart:self.product];
        }
      });
}

#pragma mark - Display Helpers

- (NSString *)formattedPrice {
  return self.product ? [self.product formattedPrice] : @"--";
}

- (NSString *)formattedRating {
  return self.product ? [self.product formattedRating] : @"No reviews";
}

- (NSString *)availabilityText {
  if (!self.product) {
    return @"--";
  }
  return self.product.inStock ? @"In Stock" : @"Out of Stock";
}

#pragma mark - Private

- (void)notifyLoadingStateChanged {
  if ([self.delegate respondsToSelector:@selector(loadingStateDidChange:)]) {
    [self.delegate loadingStateDidChange:self.isLoading];
  }
}

#pragma mark - Debug

- (void)dealloc {
  os_log_debug(ProductDetailViewModelLog(), "dealloc");
}

@end
