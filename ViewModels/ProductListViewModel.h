//
//  ProductListViewModel.h
//  MVVM-C-ARC
//
//  ProductListViewModel - ViewModel for product list screen
//  ARC Version
//

#import <Foundation/Foundation.h>

@class Product;
@class ProductListViewModel;
@protocol ProductServiceProtocol;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Delegate Protocol

@protocol ProductListViewModelDelegate <NSObject>
@required
/// Called when a product is selected
- (void)viewModel:(ProductListViewModel *)viewModel
    didSelectProduct:(Product *)product;

@optional
/// Called when the product list is refreshed
- (void)viewModelDidRefreshProducts:(ProductListViewModel *)viewModel;
@end

#pragma mark - ViewModel Interface

@interface ProductListViewModel : NSObject

/// Delegate for navigation events (WEAK to avoid retain cycle with Coordinator)
@property(nonatomic, weak, nullable) id<ProductListViewModelDelegate> delegate;

/// The list of products to display
@property(nonatomic, copy, readonly) NSArray<Product *> *products;

/// Whether the view model is currently loading
@property(nonatomic, assign, readonly, getter=isLoading) BOOL loading;

/// Error message if loading failed
@property(nonatomic, copy, readonly, nullable) NSString *errorMessage;

#pragma mark - Block-based Callbacks (Alternative to Delegate)

/// Called when a product is selected (use weak self in coordinator!)
@property(nonatomic, copy, nullable) void (^onProductSelected)(Product *product)
    ;

/// Called when refresh completes
@property(nonatomic, copy, nullable) void (^onRefreshComplete)(BOOL success);

/// Called when an error occurs
@property(nonatomic, copy, nullable) void (^onError)(NSError *error);

#pragma mark - Initialization

/// Initializes with a product service (preferred for testability)
/// @param productService The service to fetch products from
- (instancetype)initWithProductService:
    (id<ProductServiceProtocol>)productService;

/// Initializes with default product service
/// Provided for backward compatibility
- (instancetype)init;

#pragma mark - Data Access

/// Number of products
- (NSInteger)numberOfProducts;

/// Product at index
- (nullable Product *)productAtIndex:(NSInteger)index;

#pragma mark - Actions

/// Loads/refreshes the product list
- (void)loadProducts;

/// Selects a product at the given index
- (void)selectProductAtIndex:(NSInteger)index;

/// Selects a product by ID
- (void)selectProductWithId:(NSString *)productId;

@end

NS_ASSUME_NONNULL_END
