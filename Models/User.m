//
//  User.m
//  MVVM-C-ARC
//
//  User Model Implementation
//  ARC Version
//

#import "User.h"

@interface User ()
@property(nonatomic, copy, readwrite) NSString *userId;
@end

@implementation User

#pragma mark - Initialization

+ (instancetype)userWithId:(NSString *)userId
               displayName:(NSString *)displayName {
  return [[self alloc] initWithId:userId displayName:displayName];
}

- (instancetype)initWithId:(NSString *)userId
               displayName:(NSString *)displayName {
  NSParameterAssert(userId != nil);
  NSParameterAssert(displayName != nil);

  self = [super init];
  if (self) {
    _userId = [userId copy];
    _displayName = [displayName copy];
    _membershipLevel = @"Standard";
    _ordersCount = 0;
    _emailVerified = NO;
  }
  return self;
}

#pragma mark - NSObject

- (NSString *)description {
  return [NSString stringWithFormat:@"<User: %@ - %@ (%@)>", self.userId,
                                    self.displayName, self.membershipLevel];
}

- (BOOL)isEqual:(id)object {
  if (self == object)
    return YES;
  if (![object isKindOfClass:[User class]])
    return NO;

  User *other = (User *)object;
  return [self.userId isEqualToString:other.userId];
}

- (NSUInteger)hash {
  return self.userId.hash;
}

@end
