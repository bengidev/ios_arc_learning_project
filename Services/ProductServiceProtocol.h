//
//  ProductServiceProtocol.h
//  MVVM-C-ARC
//
//  Protocol defining product data fetching interface
//  Enables dependency injection and testability
//  ARC Version
//

#import <Foundation/Foundation.h>

@class Product;

NS_ASSUME_NONNULL_BEGIN

/// Completion block for fetching multiple products
typedef void (^ProductListCompletionBlock)(NSArray<Product *> * _Nullable products,
                                           NSError * _Nullable error);

/// Completion block for fetching a single product
typedef void (^ProductCompletionBlock)(Product * _Nullable product,
                                       NSError * _Nullable error);

/// Protocol defining the interface for product data operations
/// Implementations can fetch from network, cache, or mock data
@protocol ProductServiceProtocol <NSObject>

@required

/// Fetches all available products asynchronously
/// @param completion Called on main thread with products array or error
- (void)fetchProductsWithCompletion:(ProductListCompletionBlock)completion;

/// Fetches a single product by its ID
/// @param productId The unique identifier of the product
/// @param completion Called on main thread with product or error
- (void)fetchProductWithId:(NSString *)productId
                completion:(ProductCompletionBlock)completion;

@optional

/// Cancels all pending fetch operations
- (void)cancelAllOperations;

/// Clears any cached product data
- (void)clearCache;

@end

NS_ASSUME_NONNULL_END
