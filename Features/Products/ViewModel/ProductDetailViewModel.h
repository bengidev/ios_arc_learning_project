//
//  ProductDetailViewModel.h
//  MVVM-C-ARC
//
//  ViewModel for product detail screen
//  ARC Version
//

#import "ProductServiceProtocol.h"
#import <Foundation/Foundation.h>

@class Product;

NS_ASSUME_NONNULL_BEGIN

/// Delegate for ProductDetailViewModel events
@protocol ProductDetailViewModelDelegate <NSObject>

/// Called when product details are loaded
- (void)productDidLoad:(Product *)product;

@optional
/// Called when loading state changes
- (void)loadingStateDidChange:(BOOL)isLoading;

/// Called when add to cart succeeds
- (void)didAddToCart:(Product *)product;

@end

@interface ProductDetailViewModel : NSObject

/// Delegate for view updates
@property(nonatomic, weak, nullable) id<ProductDetailViewModelDelegate>
    delegate;

/// Error handler callback
@property(nonatomic, copy, nullable) void (^onError)(NSError *error);

/// The current product
@property(nonatomic, strong, readonly, nullable) Product *product;

/// Whether data is currently loading
@property(nonatomic, assign, readonly) BOOL isLoading;

#pragma mark - Initialization

/// Initialize with a product service and product ID
/// @param productService The service for fetching products
/// @param productId The ID of the product to display
- (instancetype)initWithProductService:
                    (id<ProductServiceProtocol>)productService
                             productId:(NSString *)productId;

/// Initialize with an existing product
/// @param product The product to display
- (instancetype)initWithProduct:(Product *)product;

#pragma mark - Data Loading

/// Loads product details from the service
- (void)loadProductDetails;

#pragma mark - Actions

/// Adds the current product to cart
- (void)addToCart;

#pragma mark - Display Helpers

/// Returns formatted price string
- (NSString *)formattedPrice;

/// Returns formatted rating string
- (NSString *)formattedRating;

/// Returns availability text
- (NSString *)availabilityText;

@end

NS_ASSUME_NONNULL_END
