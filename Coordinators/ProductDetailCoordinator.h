//
//  ProductDetailCoordinator.h
//  MVVM-C-ARC
//
//  ProductDetailCoordinator - Manages the product detail flow
//  ARC Version
//

#import "BaseCoordinator.h"
#import "DeepLinkable.h"

@class Product;

NS_ASSUME_NONNULL_BEGIN

@interface ProductDetailCoordinator : BaseCoordinator <DeepLinkable>

/// The product to display
@property(nonatomic, strong) Product *product;

/// Initialize with a product
- (instancetype)initWithNavigationController:
                    (UINavigationController *)navigationController
                                     product:(Product *)product;

@end

NS_ASSUME_NONNULL_END
