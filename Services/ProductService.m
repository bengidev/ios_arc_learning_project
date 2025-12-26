//
//  ProductService.m
//  MVVM-C-ARC
//
//  ProductService Implementation
//  ARC Version
//

#import "ProductService.h"
#import "Product.h"
#import <os/log.h>

static os_log_t ProductServiceLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "ProductService");
  });
  return log;
}

@implementation ProductService

#pragma mark - Initialization

+ (instancetype)defaultService {
  return [[self alloc] initWithSimulatedDelay:0.5];
}

- (instancetype)init {
  return [self initWithSimulatedDelay:0.5];
}

- (instancetype)initWithSimulatedDelay:(NSTimeInterval)delay {
  self = [super init];
  if (self) {
    _simulatedDelay = delay;
  }
  return self;
}

#pragma mark - ProductServiceProtocol

- (void)fetchProductsWithCompletion:(ProductListCompletionBlock)completion {
  os_log_info(ProductServiceLog(), "Fetching products...");

  // Simulate async network request
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                               (int64_t)(self.simulatedDelay * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
                   NSArray<Product *> *products = [self createSampleProducts];

                   os_log_info(ProductServiceLog(), "Fetched %lu products",
                               (unsigned long)products.count);

                   if (completion) {
                     completion(products, nil);
                   }
                 });
}

- (void)fetchProductWithId:(NSString *)productId
                completion:(ProductCompletionBlock)completion {
  os_log_info(ProductServiceLog(), "Fetching product with ID: %{public}@",
              productId);

  // Simulate async network request
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                               (int64_t)(self.simulatedDelay * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
                   Product *product = [self findProductWithId:productId];

                   if (product) {
                     os_log_info(ProductServiceLog(),
                                 "Found product: %{public}@", product.name);
                     if (completion) {
                       completion(product, nil);
                     }
                   } else {
                     os_log_error(ProductServiceLog(),
                                  "Product not found: %{public}@", productId);
                     NSError *error =
                         [NSError errorWithDomain:@"ProductServiceErrorDomain"
                                             code:404
                                         userInfo:@{
                                           NSLocalizedDescriptionKey :
                                               @"Product not found",
                                           @"productId" : productId
                                         }];
                     if (completion) {
                       completion(nil, error);
                     }
                   }
                 });
}

#pragma mark - Sample Data

- (NSArray<Product *> *)createSampleProducts {
  Product *p1 = [Product productWithId:@"101"
                                  name:@"iPhone 15 Pro"
                                 price:999.00];
  p1.productDescription = @"The most powerful iPhone ever with A17 Pro chip";
  p1.reviewCount = 1250;
  p1.rating = 4.8;

  Product *p2 = [Product productWithId:@"102"
                                  name:@"MacBook Pro 14\""
                                 price:1999.00];
  p2.productDescription = @"M3 Pro chip, stunning Liquid Retina XDR display";
  p2.reviewCount = 890;
  p2.rating = 4.9;

  Product *p3 = [Product productWithId:@"103" name:@"AirPods Pro" price:249.00];
  p3.productDescription = @"Active Noise Cancellation, Spatial Audio";
  p3.reviewCount = 3420;
  p3.rating = 4.7;

  Product *p4 = [Product productWithId:@"104"
                                  name:@"Apple Watch Ultra 2"
                                 price:799.00];
  p4.productDescription = @"The most rugged and capable Apple Watch";
  p4.reviewCount = 567;
  p4.rating = 4.6;

  Product *p5 = [Product productWithId:@"105"
                                  name:@"iPad Pro 12.9\""
                                 price:1099.00];
  p5.productDescription = @"M2 chip, Liquid Retina XDR display, Face ID";
  p5.reviewCount = 1890;
  p5.rating = 4.8;

  return @[ p1, p2, p3, p4, p5 ];
}

- (nullable Product *)findProductWithId:(NSString *)productId {
  NSArray<Product *> *products = [self createSampleProducts];
  for (Product *product in products) {
    if ([product.productId isEqualToString:productId]) {
      return product;
    }
  }
  return nil;
}

#pragma mark - Cleanup

- (void)cancelAllOperations {
  // No-op for sample implementation
  os_log_debug(ProductServiceLog(), "Cancel operations called");
}

- (void)clearCache {
  // No-op for sample implementation
  os_log_debug(ProductServiceLog(), "Clear cache called");
}

@end
