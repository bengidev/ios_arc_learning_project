//
//  ProductListViewModel.m
//  MVVM-C-ARC
//
//  ProductListViewModel Implementation
//  ARC Version
//

#import "ProductListViewModel.h"
#import "Product.h"
#import <os/log.h>

static os_log_t ProductListViewModelLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "ProductListViewModel");
  });
  return log;
}

@interface ProductListViewModel ()
@property(nonatomic, strong) id<ProductServiceProtocol> productService;
@property(nonatomic, strong, readwrite) NSArray<Product *> *products;
@property(nonatomic, assign, readwrite) BOOL isLoading;
@end

@implementation ProductListViewModel

#pragma mark - Initialization

- (instancetype)initWithProductService:
    (id<ProductServiceProtocol>)productService {
  NSParameterAssert(productService != nil);

  self = [super init];
  if (self) {
    _productService = productService;
    _products = @[];
    _isLoading = NO;
  }
  return self;
}

#pragma mark - Data Loading

- (void)loadProducts {
  if (self.isLoading) {
    os_log_debug(ProductListViewModelLog(),
                 "Already loading, ignoring request");
    return;
  }

  os_log_info(ProductListViewModelLog(), "Loading products");

  self.isLoading = YES;
  [self notifyLoadingStateChanged];

  __weak typeof(self) weakSelf = self;
  [self.productService fetchProductsWithCompletion:^(
                           NSArray<Product *> *products, NSError *error) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf)
      return;

    strongSelf.isLoading = NO;
    [strongSelf notifyLoadingStateChanged];

    if (error) {
      os_log_error(ProductListViewModelLog(),
                   "Failed to load products: %{public}@",
                   error.localizedDescription);
      if (strongSelf.onError) {
        strongSelf.onError(error);
      }
      return;
    }

    strongSelf.products = products ?: @[];
    os_log_info(ProductListViewModelLog(), "Loaded %lu products",
                (unsigned long)strongSelf.products.count);

    if ([strongSelf.delegate respondsToSelector:@selector(productsDidLoad:)]) {
      [strongSelf.delegate productsDidLoad:strongSelf.products];
    }
  }];
}

- (void)refresh {
  os_log_info(ProductListViewModelLog(), "Refreshing products");
  [self loadProducts];
}

#pragma mark - Selection

- (void)selectProductAtIndex:(NSInteger)index {
  Product *product = [self productAtIndex:index];
  if (product) {
    os_log_info(ProductListViewModelLog(), "Selected product: %{public}@",
                product.name);

    if ([self.delegate respondsToSelector:@selector(didSelectProduct:)]) {
      [self.delegate didSelectProduct:product];
    }
  }
}

#pragma mark - Accessors

- (NSInteger)numberOfProducts {
  return self.products.count;
}

- (nullable Product *)productAtIndex:(NSInteger)index {
  if (index >= 0 && index < self.products.count) {
    return self.products[index];
  }
  return nil;
}

#pragma mark - Private

- (void)notifyLoadingStateChanged {
  if ([self.delegate respondsToSelector:@selector(loadingStateDidChange:)]) {
    [self.delegate loadingStateDidChange:self.isLoading];
  }
}

#pragma mark - Debug

- (void)dealloc {
  os_log_debug(ProductListViewModelLog(), "dealloc");
}

@end
