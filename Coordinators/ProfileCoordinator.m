//
//  ProfileCoordinator.m
//  MVVM-C-ARC
//
//  ProfileCoordinator Implementation
//  ARC Version
//

#import "ProfileCoordinator.h"
#import "DeepLinkRoute.h"
#import "DesignConstants.h"
#import "ProfileViewController.h"
#import "ProfileViewModel.h"
#import "User.h"
#import "UserService.h"
#import "UserServiceProtocol.h"
#import <os/log.h>

static os_log_t ProfileCoordinatorLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "ProfileCoordinator");
  });
  return log;
}

@interface ProfileCoordinator () <ProfileViewModelDelegate>
@property(nonatomic, strong) ProfileViewModel *viewModel;
@property(nonatomic, weak) ProfileViewController *profileViewController;
@property(nonatomic, strong) id<UserServiceProtocol> userService;
@end

@implementation ProfileCoordinator

#pragma mark - Initialization

- (instancetype)initWithNavigationController:
    (UINavigationController *)navigationController {
  // Use default service for backward compatibility
  return [self initWithNavigationController:navigationController
                                     userId:nil
                                userService:[UserService defaultService]];
}

- (instancetype)
    initWithNavigationController:(UINavigationController *)navigationController
                     userService:(id<UserServiceProtocol>)userService {
  return [self initWithNavigationController:navigationController
                                     userId:nil
                                userService:userService];
}

- (instancetype)
    initWithNavigationController:(UINavigationController *)navigationController
                          userId:(nullable NSString *)userId
                     userService:(id<UserServiceProtocol>)userService {
  NSParameterAssert(userService != nil);

  self = [super initWithNavigationController:navigationController];
  if (self) {
    _userId = [userId copy];
    _userService = userService;
  }
  return self;
}

#pragma mark - Lifecycle

- (void)start {
  os_log_info(ProfileCoordinatorLog(),
              "Starting profile flow for user: %{public}@",
              self.userId ?: @"current");

  // Create ViewModel with injected service
  self.viewModel = [[ProfileViewModel alloc] initWithUserId:self.userId
                                                userService:self.userService];
  self.viewModel.delegate = self;

  // Create ViewController
  ProfileViewController *profileVC =
      [[ProfileViewController alloc] initWithViewModel:self.viewModel];
  self.profileViewController = profileVC;

  // Push to navigation
  [self.navigationController pushViewController:profileVC animated:YES];
}

#pragma mark - Navigation

- (void)showEditProfile {
  os_log_info(ProfileCoordinatorLog(), "Showing edit profile");

  // Placeholder - would create EditProfileCoordinator
  UIViewController *editVC = [[UIViewController alloc] init];
  editVC.view.backgroundColor = [UIColor systemBackgroundColor];
  editVC.title = @"Edit Profile";

  UILabel *label = [[UILabel alloc] init];
  label.text = @"Edit Profile\n(Coming Soon)";
  label.numberOfLines = 0;
  label.textAlignment = NSTextAlignmentCenter;
  label.font = [UIFont systemFontOfSize:20];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  [editVC.view addSubview:label];

  [NSLayoutConstraint activateConstraints:@[
    [label.centerXAnchor constraintEqualToAnchor:editVC.view.centerXAnchor],
    [label.centerYAnchor constraintEqualToAnchor:editVC.view.centerYAnchor]
  ]];

  [self.navigationController pushViewController:editVC animated:YES];
}

- (void)showOrders {
  os_log_info(ProfileCoordinatorLog(), "Showing orders");

  // Placeholder - would create OrdersCoordinator
  UIViewController *ordersVC = [[UIViewController alloc] init];
  ordersVC.view.backgroundColor = [UIColor systemBackgroundColor];
  ordersVC.title = @"My Orders";

  UILabel *label = [[UILabel alloc] init];
  label.text = @"Order History\n(Coming Soon)";
  label.numberOfLines = 0;
  label.textAlignment = NSTextAlignmentCenter;
  label.font = [UIFont systemFontOfSize:20];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  [ordersVC.view addSubview:label];

  [NSLayoutConstraint activateConstraints:@[
    [label.centerXAnchor constraintEqualToAnchor:ordersVC.view.centerXAnchor],
    [label.centerYAnchor constraintEqualToAnchor:ordersVC.view.centerYAnchor]
  ]];

  [self.navigationController pushViewController:ordersVC animated:YES];
}

- (void)handleLogout {
  os_log_info(ProfileCoordinatorLog(), "Handling logout - returning to root");

  // Pop to root and finish
  [self.navigationController popToRootViewControllerAnimated:YES];
  [self finish];
}

#pragma mark - ProfileViewModelDelegate

- (void)viewModelDidRequestEditProfile:(ProfileViewModel *)viewModel {
  [self showEditProfile];
}

- (void)viewModelDidRequestViewOrders:(ProfileViewModel *)viewModel {
  [self showOrders];
}

- (void)viewModelDidRequestLogout:(ProfileViewModel *)viewModel {
  [self handleLogout];
}

- (void)viewModelDidRequestDismiss:(ProfileViewModel *)viewModel {
  [self.navigationController popViewControllerAnimated:YES];
  [self finish];
}

#pragma mark - DeepLinkable

- (BOOL)canHandleRoute:(DeepLinkRoute *)route {
  switch (route.type) {
  case DeepLinkRouteTypeUserProfile:
    return YES;
  default:
    return NO;
  }
}

- (void)handleRoute:(DeepLinkRoute *)route {
  os_log_info(ProfileCoordinatorLog(), "Handling route: %{public}@",
              [route routeTypeString]);

  switch (route.type) {
  case DeepLinkRouteTypeUserProfile:
    // Already showing profile, nothing to do
    break;
  default:
    break;
  }
}

#pragma mark - Debug

- (void)dealloc {
  os_log_debug(ProfileCoordinatorLog(), "dealloc - userId: %{public}@",
               self.userId ?: @"current");
}

@end
