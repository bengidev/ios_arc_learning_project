//
//  ProductDetailViewModel.h
//  MVVM-C-ARC
//
//  ProductDetailViewModel - ViewModel for product detail screen
//  ARC Version
//

#import <Foundation/Foundation.h>

@class Product;
@class ProductDetailViewModel;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Delegate Protocol

@protocol ProductDetailViewModelDelegate <NSObject>
@optional
/// Called when the user wants to see reviews
- (void)viewModelDidRequestReviews:(ProductDetailViewModel *)viewModel;

/// Called when the user wants to add to cart
- (void)viewModelDidRequestAddToCart:(ProductDetailViewModel *)viewModel;

/// Called when the user wants to go back
- (void)viewModelDidRequestDismiss:(ProductDetailViewModel *)viewModel;
@end

#pragma mark - ViewModel Interface

@interface ProductDetailViewModel : NSObject

/// Delegate for navigation events (WEAK to avoid retain cycle)
@property(nonatomic, weak, nullable) id<ProductDetailViewModelDelegate>
    delegate;

/// The product being displayed
@property(nonatomic, strong, readonly) Product *product;

#pragma mark - Display Properties

/// Product name
@property(nonatomic, copy, readonly) NSString *productName;

/// Formatted price string (e.g., "$999.00")
@property(nonatomic, copy, readonly) NSString *formattedPrice;

/// Product description
@property(nonatomic, copy, readonly, nullable) NSString *productDescription;

/// Review count string (e.g., "1,250 reviews")
@property(nonatomic, copy, readonly) NSString *reviewCountString;

/// Rating string (e.g., "4.8 ★")
@property(nonatomic, copy, readonly) NSString *ratingString;

#pragma mark - Block-based Callbacks

/// Called when reviews are requested
@property(nonatomic, copy, nullable) void (^onReviewsRequested)(void);

/// Called when add to cart is requested
@property(nonatomic, copy, nullable) void (^onAddToCartRequested)(void);

/// Called when dismiss is requested
@property(nonatomic, copy, nullable) void (^onDismissRequested)(void);

#pragma mark - Initialization

- (instancetype)initWithProduct:(Product *)product;
+ (instancetype)viewModelWithProduct:(Product *)product;

#pragma mark - Actions

/// Request to show reviews
- (void)showReviews;

/// Add product to cart
- (void)addToCart;

/// Dismiss this screen
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
