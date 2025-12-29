//
//  CartCoordinator.h
//  MVVM-C-ARC
//
//  Coordinator for the Cart tab flow
//  ARC Version
//

#import "BaseCoordinator.h"

NS_ASSUME_NONNULL_BEGIN

@interface CartCoordinator : BaseCoordinator

- (instancetype)initWithNavigationController:
    (UINavigationController *)navigationController;

@end

NS_ASSUME_NONNULL_END
