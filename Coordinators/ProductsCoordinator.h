//
//  ProductsCoordinator.h
//  MVVM-C-ARC
//
//  ProductsCoordinator - Manages the product list flow
//  ARC Version
//

#import "BaseCoordinator.h"
#import "DeepLinkable.h"

@protocol ProductServiceProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface ProductsCoordinator : BaseCoordinator <DeepLinkable>

/// Initialize with navigation controller and product service (preferred)
/// @param navigationController The navigation controller to use
/// @param productService The service for fetching products
- (instancetype)
    initWithNavigationController:(UINavigationController *)navigationController
                  productService:(id<ProductServiceProtocol>)productService;

@end

NS_ASSUME_NONNULL_END
