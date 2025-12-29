//
//  UserService.m
//  MVVM-C-ARC
//
//  UserService Implementation
//  ARC Version
//

#import "UserService.h"
#import "User.h"
#import <os/log.h>

static os_log_t UserServiceLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "UserService");
  });
  return log;
}

@implementation UserService

+ (instancetype)defaultService {
  static UserService *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[UserService alloc] init];
  });
  return sharedInstance;
}

- (void)fetchCurrentUserWithCompletion:(UserFetchCompletion)completion {
  os_log_info(UserServiceLog(), "Fetching current user");

  dispatch_after(
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
      dispatch_get_main_queue(), ^{
        User *user = [User currentUser];
        os_log_info(UserServiceLog(), "Returning current user: %{public}@",
                    user.name);
        completion(user, nil);
      });
}

- (void)fetchUserWithId:(NSString *)userId
             completion:(UserFetchCompletion)completion {
  os_log_info(UserServiceLog(), "Fetching user: %{public}@", userId);

  dispatch_after(
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
      dispatch_get_main_queue(), ^{
        if ([userId isEqualToString:@"current"]) {
          completion([User currentUser], nil);
        } else {
          User *user = [User userWithId:userId
                                   name:@"Sample User"
                                  email:@"sample@example.com"];
          completion(user, nil);
        }
      });
}

@end
