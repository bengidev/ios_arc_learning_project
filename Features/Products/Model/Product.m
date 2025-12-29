//
//  Product.m
//  MVVM-C-ARC
//
//  Product Implementation
//  ARC Version
//

#import "Product.h"

@implementation Product

#pragma mark - Initialization

+ (instancetype)productWithId:(NSString *)productId
                         name:(NSString *)name
                  description:(NSString *)description
                        price:(double)price
                     category:(NSString *)category {
  Product *product = [[Product alloc] init];
  product.productId = productId;
  product.name = name;
  product.productDescription = description;
  product.price = price;
  product.category = category;
  product.inStock = YES;
  product.rating = 0.0;
  product.reviewCount = 0;
  return product;
}

+ (nullable instancetype)productFromDictionary:(NSDictionary *)dictionary {
  if (!dictionary[@"id"] || !dictionary[@"name"]) {
    return nil;
  }

  Product *product = [[Product alloc] init];
  product.productId = dictionary[@"id"];
  product.name = dictionary[@"name"];
  product.productDescription = dictionary[@"description"] ?: @"";
  product.price = [dictionary[@"price"] doubleValue];
  product.category = dictionary[@"category"] ?: @"Uncategorized";
  product.imageURL = dictionary[@"imageURL"];
  product.inStock = [dictionary[@"inStock"] boolValue];
  product.rating = [dictionary[@"rating"] floatValue];
  product.reviewCount = [dictionary[@"reviewCount"] integerValue];

  return product;
}

#pragma mark - Helpers

- (NSString *)formattedPrice {
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  formatter.numberStyle = NSNumberFormatterCurrencyStyle;
  formatter.currencyCode = @"USD";
  return [formatter stringFromNumber:@(self.price)]
             ?: [NSString stringWithFormat:@"$%.2f", self.price];
}

- (NSString *)formattedRating {
  if (self.reviewCount == 0) {
    return @"No reviews";
  }
  return [NSString stringWithFormat:@"%.1f ★ (%ld reviews)", self.rating,
                                    (long)self.reviewCount];
}

#pragma mark - Sample Data

+ (NSArray<Product *> *)sampleProducts {
  return @[
    [Product productWithId:@"1"
                      name:@"MacBook Pro"
               description:@"Powerful laptop for professionals"
                     price:1999.99
                  category:@"Computers"],
    [Product productWithId:@"2"
                      name:@"iPhone 15 Pro"
               description:@"Latest iPhone with titanium design"
                     price:999.99
                  category:@"Phones"],
    [Product productWithId:@"3"
                      name:@"iPad Air"
               description:@"Versatile tablet for work and play"
                     price:599.99
                  category:@"Tablets"],
    [Product productWithId:@"4"
                      name:@"AirPods Pro"
               description:@"Wireless earbuds with noise cancellation"
                     price:249.99
                  category:@"Audio"],
    [Product productWithId:@"5"
                      name:@"Apple Watch Ultra"
               description:@"Advanced smartwatch for athletes"
                     price:799.99
                  category:@"Wearables"]
  ];
}

#pragma mark - Debug

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@: id=%@, name=%@, price=%@>",
                                    NSStringFromClass([self class]),
                                    self.productId, self.name,
                                    [self formattedPrice]];
}

@end
