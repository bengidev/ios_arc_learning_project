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

+ (Product *)sampleProduct {
  return [self sampleProductWithId:@"test-1"];
}

+ (Product *)sampleProductWithId:(NSString *)productId {
  Product *product =
      [Product productWithId:productId
                        name:@"Test Product"
                 description:@"This is a test product for unit testing."
                       price:99.99
                    category:@"Test"];
  product.rating = 4.5;
  product.reviewCount = 100;
  product.inStock = YES;
  return product;
}

+ (NSArray<Product *> *)sampleProductList {
  return @[
    [self sampleProductWithId:@"test-1"], [self sampleProductWithId:@"test-2"],
    [self sampleProductWithId:@"test-3"]
  ];
}

+ (NSArray<Product *> *)emptyProductList {
  return @[];
}

@end
