//
//  SettingsCoordinator.h
//  MVVM-C-ARC
//
//  Coordinator for the Settings tab flow
//  ARC Version
//

#import "BaseCoordinator.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingsCoordinator : BaseCoordinator

- (instancetype)initWithNavigationController:
    (UINavigationController *)navigationController;

@end

NS_ASSUME_NONNULL_END
