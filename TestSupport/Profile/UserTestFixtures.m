//
//  UserTestFixtures.m
//  MVVM-C-ARC
//
//  UserTestFixtures Implementation
//  ARC Version
//

#import "UserTestFixtures.h"
#import "User.h"

@implementation UserTestFixtures

+ (User *)sampleUser {
  return [self sampleUserWithId:@"test-user"];
}

+ (User *)sampleUserWithId:(NSString *)userId {
  User *user = [User userWithId:userId
                           name:@"Test User"
                          email:@"test@example.com"];
  user.phoneNumber = @"+1 (555) 000-0000";
  user.orderCount = 5;
  return user;
}

@end
