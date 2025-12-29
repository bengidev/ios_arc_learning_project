//
//  ProductListViewModel.h
//  MVVM-C-ARC
//
//  ViewModel for product list screen
//  ARC Version
//

#import "ProductServiceProtocol.h"
#import <Foundation/Foundation.h>

@class Product;

NS_ASSUME_NONNULL_BEGIN

/// Delegate for ProductListViewModel events
@protocol ProductListViewModelDelegate <NSObject>

/// Called when products are loaded
- (void)productsDidLoad:(NSArray<Product *> *)products;

/// Called when a product is selected
- (void)didSelectProduct:(Product *)product;

@optional
/// Called when loading state changes
- (void)loadingStateDidChange:(BOOL)isLoading;

@end

@interface ProductListViewModel : NSObject

/// Delegate for view updates
@property(nonatomic, weak, nullable) id<ProductListViewModelDelegate> delegate;

/// Error handler callback
@property(nonatomic, copy, nullable) void (^onError)(NSError *error);

/// The current list of products
@property(nonatomic, strong, readonly) NSArray<Product *> *products;

/// Whether data is currently loading
@property(nonatomic, assign, readonly) BOOL isLoading;

#pragma mark - Initialization

/// Initialize with a product service
/// @param productService The service for fetching products
- (instancetype)initWithProductService:
    (id<ProductServiceProtocol>)productService;

#pragma mark - Data Loading

/// Loads products from the service
- (void)loadProducts;

/// Refreshes the product list
- (void)refresh;

#pragma mark - Selection

/// Called when a product at index is selected
/// @param index Index of the selected product
- (void)selectProductAtIndex:(NSInteger)index;

#pragma mark - Accessors

/// Returns the number of products
- (NSInteger)numberOfProducts;

/// Returns the product at the given index
/// @param index The index
- (nullable Product *)productAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
