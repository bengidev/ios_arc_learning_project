//
//  ProductsCoordinator.h
//  MVVM-C-ARC
//
//  Coordinator for the Products tab flow
//  ARC Version
//

#import "BaseCoordinator.h"
#import "DeepLinkable.h"

@protocol ProductServiceProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface ProductsCoordinator : BaseCoordinator <DeepLinkable>

/// The product service used by this coordinator
@property(nonatomic, strong, readonly) id<ProductServiceProtocol>
    productService;

#pragma mark - Initialization

/// Initialize with navigation controller and product service
/// @param navigationController The navigation controller for this flow
/// @param productService The service for fetching products
- (instancetype)
    initWithNavigationController:(UINavigationController *)navigationController
                  productService:(id<ProductServiceProtocol>)productService;

#pragma mark - Navigation

/// Shows the product detail screen
/// @param productId The ID of the product to display
- (void)showProductDetailWithId:(NSString *)productId;

@end

NS_ASSUME_NONNULL_END
