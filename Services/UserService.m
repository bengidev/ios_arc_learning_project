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

@interface UserService ()
@property(nonatomic, strong, nullable) User *cachedCurrentUser;
@end

@implementation UserService

#pragma mark - Initialization

+ (instancetype)defaultService {
  return [[self alloc] initWithSimulatedDelay:0.3];
}

- (instancetype)init {
  return [self initWithSimulatedDelay:0.3];
}

- (instancetype)initWithSimulatedDelay:(NSTimeInterval)delay {
  self = [super init];
  if (self) {
    _simulatedDelay = delay;
  }
  return self;
}

#pragma mark - UserServiceProtocol

- (void)fetchCurrentUserWithCompletion:(UserCompletionBlock)completion {
  os_log_info(UserServiceLog(), "Fetching current user...");

  // Return cached user if available
  if (self.cachedCurrentUser) {
    os_log_debug(UserServiceLog(), "Returning cached user: %{public}@",
                 self.cachedCurrentUser.displayName);
    if (completion) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(self.cachedCurrentUser, nil);
      });
    }
    return;
  }

  // Simulate async network request
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                               (int64_t)(self.simulatedDelay * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
                   User *user = [self createSampleCurrentUser];
                   self.cachedCurrentUser = user;

                   os_log_info(UserServiceLog(),
                               "Fetched current user: %{public}@",
                               user.displayName);

                   if (completion) {
                     completion(user, nil);
                   }
                 });
}

- (void)fetchUserWithId:(NSString *)userId
             completion:(UserCompletionBlock)completion {
  os_log_info(UserServiceLog(), "Fetching user with ID: %{public}@", userId);

  // Simulate async network request
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                               (int64_t)(self.simulatedDelay * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
                   User *user = [self createSampleUserWithId:userId];

                   if (user) {
                     os_log_info(UserServiceLog(), "Found user: %{public}@",
                                 user.displayName);
                     if (completion) {
                       completion(user, nil);
                     }
                   } else {
                     os_log_error(UserServiceLog(),
                                  "User not found: %{public}@", userId);
                     NSError *error = [NSError
                         errorWithDomain:@"UserServiceErrorDomain"
                                    code:404
                                userInfo:@{
                                  NSLocalizedDescriptionKey : @"User not found",
                                  @"userId" : userId
                                }];
                     if (completion) {
                       completion(nil, error);
                     }
                   }
                 });
}

- (void)updateUser:(User *)user
        completion:(UserUpdateCompletionBlock)completion {
  os_log_info(UserServiceLog(), "Updating user: %{public}@", user.userId);

  // Simulate async network request
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                               (int64_t)(self.simulatedDelay * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
                   // In real app, would send to server
                   self.cachedCurrentUser = user;

                   os_log_info(UserServiceLog(), "User updated successfully");

                   if (completion) {
                     completion(YES, nil);
                   }
                 });
}

- (void)logoutWithCompletion:(UserUpdateCompletionBlock)completion {
  os_log_info(UserServiceLog(), "Logging out user");

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                               (int64_t)(self.simulatedDelay * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
                   [self clearCache];

                   os_log_info(UserServiceLog(),
                               "User logged out successfully");

                   if (completion) {
                     completion(YES, nil);
                   }
                 });
}

- (void)clearCache {
  self.cachedCurrentUser = nil;
  os_log_debug(UserServiceLog(), "Cache cleared");
}

#pragma mark - Sample Data

- (User *)createSampleCurrentUser {
  User *user = [User userWithId:@"user_001" displayName:@"John Appleseed"];
  user.email = @"john.appleseed@example.com";
  user.phoneNumber = @"+1 (555) 123-4567";
  user.avatarURL = @"https://example.com/avatars/john.jpg";
  user.createdAt =
      [NSDate dateWithTimeIntervalSinceNow:-86400 * 365]; // 1 year ago
  user.emailVerified = YES;
  user.membershipLevel = @"Premium";
  user.ordersCount = 42;
  return user;
}

- (nullable User *)createSampleUserWithId:(NSString *)userId {
  // Sample users database
  NSDictionary<NSString *, NSDictionary *> *users = @{
    @"user_001" : @{
      @"displayName" : @"John Appleseed",
      @"email" : @"john.appleseed@example.com",
      @"membershipLevel" : @"Premium"
    },
    @"user_002" : @{
      @"displayName" : @"Jane Smith",
      @"email" : @"jane.smith@example.com",
      @"membershipLevel" : @"Standard"
    },
    @"user_003" : @{
      @"displayName" : @"Bob Wilson",
      @"email" : @"bob.wilson@example.com",
      @"membershipLevel" : @"Premium"
    }
  };

  NSDictionary *userData = users[userId];
  if (!userData) {
    return nil;
  }

  User *user = [User userWithId:userId displayName:userData[@"displayName"]];
  user.email = userData[@"email"];
  user.membershipLevel = userData[@"membershipLevel"];
  user.emailVerified = YES;
  user.ordersCount = arc4random_uniform(100);
  return user;
}

@end
