//
//  ProfileViewModel.m
//  MVVM-C-ARC
//
//  ProfileViewModel Implementation
//  ARC Version
//

#import "ProfileViewModel.h"
#import "User.h"
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
@property(nonatomic, strong) id<UserServiceProtocol> userService;
@property(nonatomic, copy, nullable) NSString *userId;
@property(nonatomic, strong, readwrite) User *user;
@property(nonatomic, assign, readwrite) BOOL isLoading;
@end

@implementation ProfileViewModel

- (instancetype)initWithUserService:(id<UserServiceProtocol>)userService
                             userId:(nullable NSString *)userId {
  self = [super init];
  if (self) {
    _userService = userService;
    _userId = [userId copy];
  }
  return self;
}

- (void)loadProfile {
  if (self.isLoading)
    return;

  os_log_info(ProfileViewModelLog(), "Loading profile for: %{public}@",
              self.userId ?: @"current");

  self.isLoading = YES;
  if ([self.delegate respondsToSelector:@selector(loadingStateDidChange:)]) {
    [self.delegate loadingStateDidChange:YES];
  }

  __weak typeof(self) weakSelf = self;

  void (^completion)(User *, NSError *) = ^(User *user, NSError *error) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf)
      return;

    strongSelf.isLoading = NO;
    if ([strongSelf.delegate
            respondsToSelector:@selector(loadingStateDidChange:)]) {
      [strongSelf.delegate loadingStateDidChange:NO];
    }

    if (error) {
      if (strongSelf.onError)
        strongSelf.onError(error);
      return;
    }

    strongSelf.user = user;
    [strongSelf.delegate userDidLoad:user];
  };

  if (self.userId) {
    [self.userService fetchUserWithId:self.userId completion:completion];
  } else {
    [self.userService fetchCurrentUserWithCompletion:completion];
  }
}

- (NSString *)displayName {
  return self.user.name ?: @"--";
}

- (NSString *)displayEmail {
  return self.user.email ?: @"--";
}

- (NSString *)memberSince {
  return self.user ? [NSString stringWithFormat:@"Member since %@",
                                                [self.user formattedJoinDate]]
                   : @"--";
}

- (void)dealloc {
  os_log_debug(ProfileViewModelLog(), "dealloc");
}

@end
