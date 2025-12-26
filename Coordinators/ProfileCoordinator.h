//
//  ProfileCoordinator.h
//  MVVM-C-ARC
//
//  ProfileCoordinator - Manages the user profile flow
//  ARC Version
//

#import "BaseCoordinator.h"
#import "DeepLinkable.h"

@protocol UserServiceProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface ProfileCoordinator : BaseCoordinator <DeepLinkable>

/// The user ID to display (nil for current user)
@property(nonatomic, copy, nullable) NSString *userId;

/// Initialize with navigation controller and user service (preferred)
/// @param navigationController The navigation controller to use
/// @param userService The service for fetching user data
- (instancetype)
    initWithNavigationController:(UINavigationController *)navigationController
                     userService:(id<UserServiceProtocol>)userService;

/// Initialize for a specific user
/// @param navigationController The navigation controller to use
/// @param userId The user ID to display
/// @param userService The service for fetching user data
- (instancetype)
    initWithNavigationController:(UINavigationController *)navigationController
                          userId:(nullable NSString *)userId
                     userService:(id<UserServiceProtocol>)userService;

@end

NS_ASSUME_NONNULL_END
