//
//  ProductTestFixtures.h
//  MVVM-C-ARC
//
//  Test fixtures for Product data
//  Use for unit tests and development
//  ARC Version
//

#import <Foundation/Foundation.h>

@class Product;

NS_ASSUME_NONNULL_BEGIN

/// Provides sample Product data for testing and development
/// This separates test data from production Model code
@interface ProductTestFixtures : NSObject

#pragma mark - Sample Products

/// Returns an array of sample products for testing
+ (NSArray<Product *> *)sampleProducts;

/// Returns a sample product with the given ID
/// @param productId The product ID to search for
/// @return The product if found, nil otherwise
+ (nullable Product *)sampleProductWithId:(NSString *)productId;

#pragma mark - Individual Products

/// iPhone 15 Pro sample product (ID: 101)
+ (Product *)iPhonePro;

/// MacBook Pro sample product (ID: 102)
+ (Product *)macBookPro;

/// AirPods Pro sample product (ID: 103)
+ (Product *)airPodsPro;

/// Apple Watch Ultra sample product (ID: 104)
+ (Product *)appleWatchUltra;

/// iPad Pro sample product (ID: 105)
+ (Product *)iPadPro;

@end

NS_ASSUME_NONNULL_END
