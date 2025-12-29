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

/// Unique identifier for the product
@property(nonatomic, copy) NSString *productId;

/// Product name
@property(nonatomic, copy) NSString *name;

/// Product description
@property(nonatomic, copy) NSString *productDescription;

/// Price in dollars
@property(nonatomic, assign) double price;

/// Category of the product
@property(nonatomic, copy) NSString *category;

/// Image URL (if available)
@property(nonatomic, copy, nullable) NSString *imageURL;

/// Whether the product is in stock
@property(nonatomic, assign) BOOL inStock;

/// Average rating (0-5)
@property(nonatomic, assign) float rating;

/// Number of reviews
@property(nonatomic, assign) NSInteger reviewCount;

#pragma mark - Initialization

/// Creates a product with the given details
+ (instancetype)productWithId:(NSString *)productId
                         name:(NSString *)name
                  description:(NSString *)description
                        price:(double)price
                     category:(NSString *)category;

/// Creates a product from a dictionary (e.g., from JSON)
+ (nullable instancetype)productFromDictionary:(NSDictionary *)dictionary;

#pragma mark - Helpers

/// Returns a formatted price string
- (NSString *)formattedPrice;

/// Returns a formatted rating string
- (NSString *)formattedRating;

@end

NS_ASSUME_NONNULL_END
