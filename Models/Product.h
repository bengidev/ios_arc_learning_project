//
//  Product.h
//  MVVM-C-ARC
//
//  Product Model
//  ARC Version
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Product : NSObject

@property(nonatomic, copy) NSString *productId;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy, nullable) NSString *productDescription;
@property(nonatomic, assign) double price;
@property(nonatomic, copy, nullable) NSString *imageURL;
@property(nonatomic, assign) NSInteger reviewCount;
@property(nonatomic, assign) double rating;

#pragma mark - Initialization

+ (instancetype)productWithId:(NSString *)productId
                         name:(NSString *)name
                        price:(double)price;

- (instancetype)initWithId:(NSString *)productId
                      name:(NSString *)name
                     price:(double)price;

#pragma mark - Sample Data

/// Returns an array of sample products for testing
+ (NSArray<Product *> *)sampleProducts;

/// Returns a sample product with the given ID
+ (nullable Product *)sampleProductWithId:(NSString *)productId;

@end

NS_ASSUME_NONNULL_END
