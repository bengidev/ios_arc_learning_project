//
//  ProductTestFixtures.h
//  MVVM-C-ARC
//
//  Test fixtures for Products feature
//  ARC Version
//

#import <Foundation/Foundation.h>

@class Product;

NS_ASSUME_NONNULL_BEGIN

@interface ProductTestFixtures : NSObject

+ (Product *)sampleProduct;
+ (Product *)sampleProductWithId:(NSString *)productId;
+ (NSArray<Product *> *)sampleProductList;
+ (NSArray<Product *> *)emptyProductList;

@end

NS_ASSUME_NONNULL_END
