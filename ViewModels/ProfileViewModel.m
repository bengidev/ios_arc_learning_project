//
//  ProfileViewModel.m
//  MVVM-C-ARC
//
//  ProfileViewModel Implementation
//  ARC Version
//

#import "ProfileViewModel.h"
#import "User.h"
#import "UserService.h"
#import "UserServiceProtocol.h"
#import <os/log.h>

static os_log_t ProfileViewModelLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "ProfileViewModel");
  });
  return log;
}

@interface ProfileViewModel ()
@property(nonatomic, strong, readwrite, nullable) User *user;
@property(nonatomic, assign, readwrite, getter=isLoading) BOOL loading;
@property(nonatomic, copy, readwrite, nullable) NSString *errorMessage;
@property(nonatomic, strong) id<UserServiceProtocol> userService;
@property(nonatomic, copy, nullable) NSString *userId;
@end

@implementation ProfileViewModel

#pragma mark - Initialization

- (instancetype)initWithUserService:(id<UserServiceProtocol>)userService {
  return [self initWithUserId:nil userService:userService];
}

- (instancetype)initWithUserId:(nullable NSString *)userId
                   userService:(id<UserServiceProtocol>)userService {
  NSParameterAssert(userService != nil);

  self = [super init];
  if (self) {
    _userService = userService;
    _userId = [userId copy];
    _loading = NO;
  }
  return self;
}

#pragma mark - Display Properties

- (NSString *)displayName {
  return self.user.displayName ?: @"Guest User";
}

- (nullable NSString *)emailDisplay {
  if (!self.user.email)
    return nil;

  NSString *verificationStatus =
      self.user.isEmailVerified ? @"✓" : @"(unverified)";
  return
      [NSString stringWithFormat:@"%@ %@", self.user.email, verificationStatus];
}

- (nullable NSString *)phoneNumber {
  return self.user.phoneNumber;
}

- (NSString *)membershipBadge {
  return self.user.membershipLevel ?: @"Standard";
}

- (NSString *)ordersCountString {
  NSInteger count = self.user.ordersCount;
  if (count == 0) {
    return @"No orders yet";
  } else if (count == 1) {
    return @"1 order";
  } else {
    return [NSString stringWithFormat:@"%ld orders", (long)count];
  }
}

- (nullable NSString *)memberSinceString {
  if (!self.user.createdAt)
    return nil;

  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"MMM yyyy";
  return [NSString
      stringWithFormat:@"Member since %@",
                       [formatter stringFromDate:self.user.createdAt]];
}

- (nullable NSString *)avatarURL {
  return self.user.avatarURL;
}

#pragma mark - Actions

- (void)loadProfile {
  if (self.isLoading) {
    os_log_debug(ProfileViewModelLog(), "Already loading, ignoring request");
    return;
  }

  self.loading = YES;
  self.errorMessage = nil;

  os_log_info(ProfileViewModelLog(), "Loading profile...");

  __weak typeof(self) weakSelf = self;

  if (self.userId) {
    // Load specific user
    [self.userService fetchUserWithId:self.userId
                           completion:^(User *user, NSError *error) {
                             [weakSelf handleUserFetchResult:user error:error];
                           }];
  } else {
    // Load current user
    [self.userService
        fetchCurrentUserWithCompletion:^(User *user, NSError *error) {
          [weakSelf handleUserFetchResult:user error:error];
        }];
  }
}

- (void)handleUserFetchResult:(nullable User *)user
                        error:(nullable NSError *)error {
  self.loading = NO;

  if (error) {
    os_log_error(ProfileViewModelLog(), "Failed to load profile: %{public}@",
                 error.localizedDescription);
    self.errorMessage = error.localizedDescription;

    if (self.onError) {
      self.onError(error);
    }

    if (self.onProfileLoaded) {
      self.onProfileLoaded(NO);
    }
    return;
  }

  self.user = user;

  os_log_info(ProfileViewModelLog(), "Loaded profile for: %{public}@",
              user.displayName);

  if (self.onProfileLoaded) {
    self.onProfileLoaded(YES);
  }
}

- (void)editProfile {
  os_log_info(ProfileViewModelLog(), "Edit profile requested");

  if ([self.delegate
          respondsToSelector:@selector(viewModelDidRequestEditProfile:)]) {
    [self.delegate viewModelDidRequestEditProfile:self];
  }
}

- (void)viewOrders {
  os_log_info(ProfileViewModelLog(), "View orders requested");

  if ([self.delegate
          respondsToSelector:@selector(viewModelDidRequestViewOrders:)]) {
    [self.delegate viewModelDidRequestViewOrders:self];
  }
}

- (void)logout {
  os_log_info(ProfileViewModelLog(), "Logout requested");

  self.loading = YES;

  __weak typeof(self) weakSelf = self;
  [self.userService logoutWithCompletion:^(BOOL success, NSError *error) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf)
      return;

    strongSelf.loading = NO;

    if (error) {
      os_log_error(ProfileViewModelLog(), "Logout failed: %{public}@",
                   error.localizedDescription);
      if (strongSelf.onError) {
        strongSelf.onError(error);
      }
      if (strongSelf.onLogoutComplete) {
        strongSelf.onLogoutComplete(NO);
      }
      return;
    }

    os_log_info(ProfileViewModelLog(), "Logout successful");

    strongSelf.user = nil;

    if (strongSelf.onLogoutComplete) {
      strongSelf.onLogoutComplete(YES);
    }

    if ([strongSelf.delegate
            respondsToSelector:@selector(viewModelDidRequestLogout:)]) {
      [strongSelf.delegate viewModelDidRequestLogout:strongSelf];
    }
  }];
}

- (void)dismiss {
  os_log_info(ProfileViewModelLog(), "Dismiss requested");

  if ([self.delegate
          respondsToSelector:@selector(viewModelDidRequestDismiss:)]) {
    [self.delegate viewModelDidRequestDismiss:self];
  }
}

#pragma mark - Debug

- (void)dealloc {
  os_log_debug(ProfileViewModelLog(), "dealloc - user: %{public}@",
               self.user.userId ?: @"nil");
}

@end
