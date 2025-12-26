//
//  ProductListViewModel.m
//  MVVM-C-ARC
//
//  ProductListViewModel Implementation
//  ARC Version
//

#import "ProductListViewModel.h"
#import "Product.h"
#import "ProductService.h"
#import "ProductServiceProtocol.h"
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
@property(nonatomic, copy, readwrite) NSArray<Product *> *products;
@property(nonatomic, assign, readwrite, getter=isLoading) BOOL loading;
@property(nonatomic, copy, readwrite, nullable) NSString *errorMessage;
@property(nonatomic, strong) id<ProductServiceProtocol> productService;
@end

@implementation ProductListViewModel

#pragma mark - Initialization

- (instancetype)init {
  // Use default service for backward compatibility
  return [self initWithProductService:[ProductService defaultService]];
}

- (instancetype)initWithProductService:
    (id<ProductServiceProtocol>)productService {
  self = [super init];
  if (self) {
    _productService = productService;
    _products = @[];
    _loading = NO;
  }
  return self;
}

#pragma mark - Data Access

- (NSInteger)numberOfProducts {
  return self.products.count;
}

- (nullable Product *)productAtIndex:(NSInteger)index {
  if (index >= 0 && index < self.products.count) {
    return self.products[index];
  }
  return nil;
}

#pragma mark - Actions

- (void)loadProducts {
  if (self.isLoading) {
    os_log_debug(ProductListViewModelLog(),
                 "Already loading, ignoring request");
    return;
  }

  self.loading = YES;
  self.errorMessage = nil;

  os_log_info(ProductListViewModelLog(), "Loading products...");

  __weak typeof(self) weakSelf = self;
  [self.productService fetchProductsWithCompletion:^(
                           NSArray<Product *> *products, NSError *error) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf)
      return;

    strongSelf.loading = NO;

    if (error) {
      os_log_error(ProductListViewModelLog(),
                   "Failed to load products: %{public}@",
                   error.localizedDescription);
      strongSelf.errorMessage = error.localizedDescription;

      // Notify via block
      if (strongSelf.onError) {
        strongSelf.onError(error);
      }

      // Notify refresh complete with failure
      if (strongSelf.onRefreshComplete) {
        strongSelf.onRefreshComplete(NO);
      }
      return;
    }

    strongSelf.products = products ?: @[];

    os_log_info(ProductListViewModelLog(), "Loaded %lu products",
                (unsigned long)strongSelf.products.count);

    // Notify via delegate
    if ([strongSelf.delegate
            respondsToSelector:@selector(viewModelDidRefreshProducts:)]) {
      [strongSelf.delegate viewModelDidRefreshProducts:strongSelf];
    }

    // Notify via block
    if (strongSelf.onRefreshComplete) {
      strongSelf.onRefreshComplete(YES);
    }
  }];
}

- (void)selectProductAtIndex:(NSInteger)index {
  Product *product = [self productAtIndex:index];
  if (product) {
    [self notifyProductSelected:product];
  }
}

- (void)selectProductWithId:(NSString *)productId {
  // First check local cache
  for (Product *product in self.products) {
    if ([product.productId isEqualToString:productId]) {
      [self notifyProductSelected:product];
      return;
    }
  }

  // Fetch from service if not in cache
  os_log_info(ProductListViewModelLog(),
              "Product %{public}@ not in cache, fetching...", productId);

  __weak typeof(self) weakSelf = self;
  [self.productService
      fetchProductWithId:productId
              completion:^(Product *product, NSError *error) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf)
                  return;

                if (error) {
                  os_log_error(ProductListViewModelLog(),
                               "Failed to fetch product: %{public}@",
                               error.localizedDescription);
                  if (strongSelf.onError) {
                    strongSelf.onError(error);
                  }
                  return;
                }

                if (product) {
                  [strongSelf notifyProductSelected:product];
                }
              }];
}

- (void)notifyProductSelected:(Product *)product {
  os_log_info(ProductListViewModelLog(), "Selected product: %{public}@",
              product.productId);

  // Notify via delegate
  [self.delegate viewModel:self didSelectProduct:product];

  // Notify via block
  if (self.onProductSelected) {
    self.onProductSelected(product);
  }
}

#pragma mark - Debug

- (void)dealloc {
  os_log_debug(ProductListViewModelLog(), "dealloc");
}

@end
