//
//  ProductTestFixtures.m
//  MVVM-C-ARC
//
//  ProductTestFixtures Implementation
//  ARC Version
//

#import "ProductTestFixtures.h"
#import "Product.h"

@implementation ProductTestFixtures

#pragma mark - Sample Products

+ (NSArray<Product *> *)sampleProducts {
  return @[
    [self iPhonePro], [self macBookPro], [self airPodsPro],
    [self appleWatchUltra], [self iPadPro]
  ];
}

+ (nullable Product *)sampleProductWithId:(NSString *)productId {
  for (Product *product in [self sampleProducts]) {
    if ([product.productId isEqualToString:productId]) {
      return product;
    }
  }
  return nil;
}

#pragma mark - Individual Products

+ (Product *)iPhonePro {
  Product *product = [Product productWithId:@"101"
                                       name:@"iPhone 15 Pro"
                                      price:999.00];
  product.productDescription =
      @"The most powerful iPhone ever with A17 Pro chip";
  product.reviewCount = 1250;
  product.rating = 4.8;
  return product;
}

+ (Product *)macBookPro {
  Product *product = [Product productWithId:@"102"
                                       name:@"MacBook Pro 14\""
                                      price:1999.00];
  product.productDescription =
      @"M3 Pro chip, stunning Liquid Retina XDR display";
  product.reviewCount = 890;
  product.rating = 4.9;
  return product;
}

+ (Product *)airPodsPro {
  Product *product = [Product productWithId:@"103"
                                       name:@"AirPods Pro"
                                      price:249.00];
  product.productDescription = @"Active Noise Cancellation, Spatial Audio";
  product.reviewCount = 3420;
  product.rating = 4.7;
  return product;
}

+ (Product *)appleWatchUltra {
  Product *product = [Product productWithId:@"104"
                                       name:@"Apple Watch Ultra 2"
                                      price:799.00];
  product.productDescription = @"The most rugged and capable Apple Watch";
  product.reviewCount = 567;
  product.rating = 4.6;
  return product;
}

+ (Product *)iPadPro {
  Product *product = [Product productWithId:@"105"
                                       name:@"iPad Pro 12.9\""
                                      price:1099.00];
  product.productDescription = @"M2 chip, Liquid Retina XDR display, Face ID";
  product.reviewCount = 1890;
  product.rating = 4.8;
  return product;
}

@end
