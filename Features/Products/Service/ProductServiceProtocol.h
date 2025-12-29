//
//  ProductServiceProtocol.h
//  MVVM-C-ARC
//
//  Protocol for product-related services
//  ARC Version
//

#import <Foundation/Foundation.h>

@class Product;

NS_ASSUME_NONNULL_BEGIN

/// Completion handler for fetching multiple products
typedef void (^ProductsFetchCompletion)(NSArray<Product *> *_Nullable products,
                                        NSError *_Nullable error);

/// Completion handler for fetching a single product
typedef void (^ProductFetchCompletion)(Product *_Nullable product,
                                       NSError *_Nullable error);

@protocol ProductServiceProtocol <NSObject>

@required

/// Fetches all products asynchronously
/// @param completion Called with products or error
- (void)fetchProductsWithCompletion:(ProductsFetchCompletion)completion;

/// Fetches a specific product by ID
/// @param productId The product ID to fetch
/// @param completion Called with product or error
- (void)fetchProductWithId:(NSString *)productId
                completion:(ProductFetchCompletion)completion;

@optional

/// Searches products by query
/// @param query The search query
/// @param completion Called with matching products or error
- (void)searchProductsWithQuery:(NSString *)query
                     completion:(ProductsFetchCompletion)completion;

/// Fetches products by category
/// @param category The category to filter by
/// @param completion Called with products or error
- (void)fetchProductsInCategory:(NSString *)category
                     completion:(ProductsFetchCompletion)completion;

@end

NS_ASSUME_NONNULL_END
