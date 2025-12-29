//
//  User.m
//  MVVM-C-ARC
//
//  User Implementation
//  ARC Version
//

#import "User.h"

@implementation User

#pragma mark - Initialization

+ (instancetype)userWithId:(NSString *)userId
                      name:(NSString *)name
                     email:(NSString *)email {
  User *user = [[User alloc] init];
  user.userId = userId;
  user.name = name;
  user.email = email;
  user.joinDate = [NSDate date];
  user.orderCount = 0;
  return user;
}

+ (instancetype)currentUser {
  User *user = [User userWithId:@"current"
                           name:@"John Appleseed"
                          email:@"john@example.com"];
  user.phoneNumber = @"+1 (555) 123-4567";
  user.orderCount = 12;

  // Set join date to 6 months ago
  NSCalendar *calendar = [NSCalendar currentCalendar];
  user.joinDate = [calendar dateByAddingUnit:NSCalendarUnitMonth
                                       value:-6
                                      toDate:[NSDate date]
                                     options:0];

  return user;
}

#pragma mark - Helpers

- (NSString *)formattedJoinDate {
  if (!self.joinDate) {
    return @"Unknown";
  }

  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateStyle = NSDateFormatterMediumStyle;
  formatter.timeStyle = NSDateFormatterNoStyle;
  return [formatter stringFromDate:self.joinDate];
}

- (NSString *)initials {
  NSArray *components = [self.name componentsSeparatedByString:@" "];
  NSMutableString *initials = [NSMutableString string];

  for (NSString *component in components) {
    if (component.length > 0) {
      [initials appendString:[[component substringToIndex:1] uppercaseString]];
      if (initials.length >= 2)
        break;
    }
  }

  return initials.length > 0 ? initials : @"?";
}

#pragma mark - Debug

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@: id=%@, name=%@, email=%@>",
                                    NSStringFromClass([self class]),
                                    self.userId, self.name, self.email];
}

@end
