//
//  ProfileCoordinator.h
//  MVVM-C-ARC
//
//  Coordinator for the Profile tab flow
//  ARC Version
//

#import "BaseCoordinator.h"
#import "DeepLinkable.h"

@protocol UserServiceProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface ProfileCoordinator : BaseCoordinator <DeepLinkable>

- (instancetype)
    initWithNavigationController:(UINavigationController *)navigationController
                          userId:(nullable NSString *)userId
                     userService:(id<UserServiceProtocol>)userService;

@end

NS_ASSUME_NONNULL_END
