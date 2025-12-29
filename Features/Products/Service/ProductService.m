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

@interface ProductService ()
@property(nonatomic, strong) NSArray<Product *> *cachedProducts;
@end

@implementation ProductService

#pragma mark - Singleton

+ (instancetype)defaultService {
  static ProductService *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[ProductService alloc] init];
  });
  return sharedInstance;
}

#pragma mark - Initialization

- (instancetype)init {
  self = [super init];
  if (self) {
    // Initialize with sample data
    _cachedProducts = [self createSampleProducts];
  }
  return self;
}

#pragma mark - ProductServiceProtocol

- (void)fetchProductsWithCompletion:(ProductsFetchCompletion)completion {
  os_log_info(ProductServiceLog(), "Fetching all products");

  // Simulate network delay
  dispatch_after(
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
      dispatch_get_main_queue(), ^{
        os_log_info(ProductServiceLog(), "Returning %lu products",
                    (unsigned long)self.cachedProducts.count);
        completion(self.cachedProducts, nil);
      });
}

- (void)fetchProductWithId:(NSString *)productId
                completion:(ProductFetchCompletion)completion {
  os_log_info(ProductServiceLog(), "Fetching product with ID: %{public}@",
              productId);

  // Simulate network delay
  dispatch_after(
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
      dispatch_get_main_queue(), ^{
        Product *foundProduct = nil;

        for (Product *product in self.cachedProducts) {
          if ([product.productId isEqualToString:productId]) {
            foundProduct = product;
            break;
          }
        }

        if (foundProduct) {
          os_log_info(ProductServiceLog(), "Found product: %{public}@",
                      foundProduct.name);
          completion(foundProduct, nil);
        } else {
          os_log_error(ProductServiceLog(), "Product not found: %{public}@",
                       productId);
          NSError *error =
              [NSError errorWithDomain:@"ProductService"
                                  code:404
                              userInfo:@{
                                NSLocalizedDescriptionKey : @"Product not found"
                              }];
          completion(nil, error);
        }
      });
}

- (void)searchProductsWithQuery:(NSString *)query
                     completion:(ProductsFetchCompletion)completion {
  os_log_info(ProductServiceLog(), "Searching products with query: %{public}@",
              query);

  dispatch_after(
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
      dispatch_get_main_queue(), ^{
        NSString *lowercaseQuery = query.lowercaseString;
        NSMutableArray<Product *> *results = [NSMutableArray array];

        for (Product *product in self.cachedProducts) {
          if ([product.name.lowercaseString containsString:lowercaseQuery] ||
              [product.productDescription.lowercaseString
                  containsString:lowercaseQuery]) {
            [results addObject:product];
          }
        }

        os_log_info(ProductServiceLog(), "Found %lu matching products",
                    (unsigned long)results.count);
        completion(results, nil);
      });
}

- (void)fetchProductsInCategory:(NSString *)category
                     completion:(ProductsFetchCompletion)completion {
  os_log_info(ProductServiceLog(), "Fetching products in category: %{public}@",
              category);

  dispatch_after(
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
      dispatch_get_main_queue(), ^{
        NSMutableArray<Product *> *results = [NSMutableArray array];

        for (Product *product in self.cachedProducts) {
          if ([product.category.lowercaseString
                  isEqualToString:category.lowercaseString]) {
            [results addObject:product];
          }
        }

        completion(results, nil);
      });
}

#pragma mark - Sample Data

- (NSArray<Product *> *)createSampleProducts {
  NSMutableArray<Product *> *products = [NSMutableArray array];

  Product *p1 = [Product
      productWithId:@"1"
               name:@"MacBook Pro 16\""
        description:@"Powerful laptop with M3 Pro chip for professionals. "
                    @"Features stunning Liquid Retina XDR display."
              price:2499.99
           category:@"Computers"];
  p1.rating = 4.8;
  p1.reviewCount = 1250;
  p1.inStock = YES;
  [products addObject:p1];

  Product *p2 =
      [Product productWithId:@"2"
                        name:@"iPhone 15 Pro Max"
                 description:@"Latest iPhone with titanium design, A17 Pro "
                             @"chip, and advanced camera system."
                       price:1199.99
                    category:@"Phones"];
  p2.rating = 4.9;
  p2.reviewCount = 3420;
  p2.inStock = YES;
  [products addObject:p2];

  Product *p3 =
      [Product productWithId:@"3"
                        name:@"iPad Pro 12.9\""
                 description:@"Ultimate iPad with M2 chip, Liquid Retina XDR "
                             @"display, and Apple Pencil support."
                       price:1099.99
                    category:@"Tablets"];
  p3.rating = 4.7;
  p3.reviewCount = 890;
  p3.inStock = YES;
  [products addObject:p3];

  Product *p4 =
      [Product productWithId:@"4"
                        name:@"AirPods Pro 2"
                 description:@"Wireless earbuds with active noise "
                             @"cancellation, spatial audio, and USB-C charging."
                       price:249.99
                    category:@"Audio"];
  p4.rating = 4.6;
  p4.reviewCount = 5670;
  p4.inStock = YES;
  [products addObject:p4];

  Product *p5 =
      [Product productWithId:@"5"
                        name:@"Apple Watch Ultra 2"
                 description:@"Most rugged Apple Watch with precision GPS, "
                             @"100m water resistance, and action button."
                       price:799.99
                    category:@"Wearables"];
  p5.rating = 4.8;
  p5.reviewCount = 1120;
  p5.inStock = YES;
  [products addObject:p5];

  Product *p6 = [Product productWithId:@"6"
                                  name:@"Studio Display"
                           description:@"27-inch 5K Retina display with A13 "
                                       @"Bionic chip and Center Stage camera."
                                 price:1599.99
                              category:@"Displays"];
  p6.rating = 4.4;
  p6.reviewCount = 340;
  p6.inStock = NO;
  [products addObject:p6];

  return [products copy];
}

@end
