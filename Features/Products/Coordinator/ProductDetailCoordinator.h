//
//  ProductDetailCoordinator.h
//  MVVM-C-ARC
//
//  Coordinator for product detail flow
//  ARC Version
//

#import "BaseCoordinator.h"

@class Product;
@protocol ProductServiceProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface ProductDetailCoordinator : BaseCoordinator

#pragma mark - Initialization

/// Initialize with a product ID
- (instancetype)
    initWithNavigationController:(UINavigationController *)navigationController
                       productId:(NSString *)productId
                  productService:(id<ProductServiceProtocol>)productService;

/// Initialize with an existing product
- (instancetype)
    initWithNavigationController:(UINavigationController *)navigationController
                         product:(Product *)product
                  productService:(id<ProductServiceProtocol>)productService;

@end

NS_ASSUME_NONNULL_END
