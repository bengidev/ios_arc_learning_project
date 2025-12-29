//
//  ProfileCoordinator.m
//  MVVM-C-ARC
//
//  ProfileCoordinator Implementation
//  ARC Version
//

#import "ProfileCoordinator.h"
#import "DeepLinkRoute.h"
#import "ProfileViewController.h"
#import "ProfileViewModel.h"
#import <os/log.h>

static os_log_t ProfileCoordinatorLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "ProfileCoordinator");
  });
  return log;
}

@interface ProfileCoordinator ()
@property(nonatomic, strong) id<UserServiceProtocol> userService;
@property(nonatomic, copy, nullable) NSString *userId;
@end

@implementation ProfileCoordinator

- (instancetype)
    initWithNavigationController:(UINavigationController *)navigationController
                          userId:(nullable NSString *)userId
                     userService:(id<UserServiceProtocol>)userService {
  self = [super initWithNavigationController:navigationController];
  if (self) {
    _userId = [userId copy];
    _userService = userService;
  }
  return self;
}

- (void)start {
  os_log_info(ProfileCoordinatorLog(), "Starting profile flow");

  ProfileViewModel *viewModel =
      [[ProfileViewModel alloc] initWithUserService:self.userService
                                             userId:self.userId];
  ProfileViewController *profileVC =
      [[ProfileViewController alloc] initWithViewModel:viewModel];

  [self.navigationController setViewControllers:@[ profileVC ] animated:NO];
}

#pragma mark - DeepLinkable

- (BOOL)canHandleRoute:(DeepLinkRoute *)route {
  return route.type == DeepLinkRouteTypeUserProfile;
}

- (void)handleRoute:(DeepLinkRoute *)route {
  os_log_info(ProfileCoordinatorLog(), "Handling route for user: %{public}@",
              route.userId ?: @"current");

  if (route.userId) {
    ProfileViewModel *viewModel =
        [[ProfileViewModel alloc] initWithUserService:self.userService
                                               userId:route.userId];
    ProfileViewController *profileVC =
        [[ProfileViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:profileVC animated:YES];
  }
}

- (void)dealloc {
  os_log_debug(ProfileCoordinatorLog(), "dealloc");
}

@end
