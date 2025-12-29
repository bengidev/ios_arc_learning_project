//
//  User.h
//  MVVM-C-ARC
//
//  User Model
//  ARC Version
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

/// Unique identifier
@property(nonatomic, copy) NSString *userId;

/// User's full name
@property(nonatomic, copy) NSString *name;

/// User's email address
@property(nonatomic, copy) NSString *email;

/// User's phone number
@property(nonatomic, copy, nullable) NSString *phoneNumber;

/// Profile image URL
@property(nonatomic, copy, nullable) NSString *avatarURL;

/// Date the user joined
@property(nonatomic, strong, nullable) NSDate *joinDate;

/// Number of orders placed
@property(nonatomic, assign) NSInteger orderCount;

#pragma mark - Initialization

+ (instancetype)userWithId:(NSString *)userId
                      name:(NSString *)name
                     email:(NSString *)email;

+ (instancetype)currentUser;

#pragma mark - Helpers

- (NSString *)formattedJoinDate;
- (NSString *)initials;

@end

NS_ASSUME_NONNULL_END
