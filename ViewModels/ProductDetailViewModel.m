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
@property(nonatomic, strong, readwrite) Product *product;
@end

@implementation ProductDetailViewModel

#pragma mark - Initialization

- (instancetype)initWithProduct:(Product *)product {
  self = [super init];
  if (self) {
    _product = product;
  }
  return self;
}

+ (instancetype)viewModelWithProduct:(Product *)product {
  return [[self alloc] initWithProduct:product];
}

#pragma mark - Display Properties

- (NSString *)productName {
  return self.product.name ?: @"Unknown Product";
}

- (NSString *)formattedPrice {
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  formatter.numberStyle = NSNumberFormatterCurrencyStyle;
  formatter.currencyCode = @"USD";
  return [formatter stringFromNumber:@(self.product.price)] ?: @"$0.00";
}

- (nullable NSString *)productDescription {
  return self.product.productDescription;
}

- (NSString *)reviewCountString {
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  formatter.numberStyle = NSNumberFormatterDecimalStyle;
  NSString *countString =
      [formatter stringFromNumber:@(self.product.reviewCount)] ?: @"0";
  return [NSString stringWithFormat:@"%@ reviews", countString];
}

- (NSString *)ratingString {
  return [NSString stringWithFormat:@"%.1f ★", self.product.rating];
}

#pragma mark - Actions

- (void)showReviews {
  os_log_info(ProductDetailViewModelLog(),
              "Show reviews requested for: %{public}@", self.product.productId);

  // Notify via delegate
  if ([self.delegate
          respondsToSelector:@selector(viewModelDidRequestReviews:)]) {
    [self.delegate viewModelDidRequestReviews:self];
  }

  // Notify via block
  if (self.onReviewsRequested) {
    self.onReviewsRequested();
  }
}

- (void)addToCart {
  os_log_info(ProductDetailViewModelLog(),
              "Add to cart requested for: %{public}@", self.product.productId);

  // Notify via delegate
  if ([self.delegate
          respondsToSelector:@selector(viewModelDidRequestAddToCart:)]) {
    [self.delegate viewModelDidRequestAddToCart:self];
  }

  // Notify via block
  if (self.onAddToCartRequested) {
    self.onAddToCartRequested();
  }
}

- (void)dismiss {
  os_log_info(ProductDetailViewModelLog(), "Dismiss requested");

  // Notify via delegate
  if ([self.delegate
          respondsToSelector:@selector(viewModelDidRequestDismiss:)]) {
    [self.delegate viewModelDidRequestDismiss:self];
  }

  // Notify via block
  if (self.onDismissRequested) {
    self.onDismissRequested();
  }
}

#pragma mark - Debug

- (void)dealloc {
  os_log_debug(ProductDetailViewModelLog(), "dealloc - product: %{public}@",
               self.product.productId);
}

@end
