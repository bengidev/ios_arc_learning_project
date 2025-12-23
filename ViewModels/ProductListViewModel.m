//
//  ProductListViewModel.m
//  MVVM-C-ARC
//
//  ProductListViewModel Implementation
//  ARC Version
//

#import "ProductListViewModel.h"
#import "Product.h"

@interface ProductListViewModel ()
@property(nonatomic, copy, readwrite) NSArray<Product *> *products;
@property(nonatomic, assign, readwrite, getter=isLoading) BOOL loading;
@property(nonatomic, copy, readwrite, nullable) NSString *errorMessage;
@end

@implementation ProductListViewModel

#pragma mark - Initialization

- (instancetype)init {
  self = [super init];
  if (self) {
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
    return;
  }

  self.loading = YES;
  self.errorMessage = nil;

  // Simulate async loading
  dispatch_after(
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
      dispatch_get_main_queue(), ^{
        // Load sample products
        self.products = [Product sampleProducts];
        self.loading = NO;

        // Notify via delegate
        if ([self.delegate
                respondsToSelector:@selector(viewModelDidRefreshProducts:)]) {
          [self.delegate viewModelDidRefreshProducts:self];
        }

        // Notify via block
        if (self.onRefreshComplete) {
          self.onRefreshComplete(YES);
        }

        NSLog(@"[ProductListViewModel] Loaded %ld products",
              (long)self.products.count);
      });
}

- (void)selectProductAtIndex:(NSInteger)index {
  Product *product = [self productAtIndex:index];
  if (product) {
    [self notifyProductSelected:product];
  }
}

- (void)selectProductWithId:(NSString *)productId {
  for (Product *product in self.products) {
    if ([product.productId isEqualToString:productId]) {
      [self notifyProductSelected:product];
      return;
    }
  }

  // Product not in list, try to find from sample data
  Product *product = [Product sampleProductWithId:productId];
  if (product) {
    [self notifyProductSelected:product];
  }
}

- (void)notifyProductSelected:(Product *)product {
  NSLog(@"[ProductListViewModel] Selected product: %@", product);

  // Notify via delegate
  [self.delegate viewModel:self didSelectProduct:product];

  // Notify via block
  if (self.onProductSelected) {
    self.onProductSelected(product);
  }
}

#pragma mark - Debug

- (void)dealloc {
  NSLog(@"[ProductListViewModel] dealloc");
}

@end
