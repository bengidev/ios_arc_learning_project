//
//  User.h
//  MVVM-C-ARC
//
//  User Model - Represents a user profile
//  ARC Version
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

/// Unique user identifier
@property(nonatomic, copy, readonly) NSString *userId;

/// User's display name
@property(nonatomic, copy) NSString *displayName;

/// User's email address
@property(nonatomic, copy, nullable) NSString *email;

/// User's avatar URL
@property(nonatomic, copy, nullable) NSString *avatarURL;

/// User's phone number
@property(nonatomic, copy, nullable) NSString *phoneNumber;

/// Account creation date
@property(nonatomic, strong, nullable) NSDate *createdAt;

/// Whether email is verified
@property(nonatomic, assign, getter=isEmailVerified) BOOL emailVerified;

/// User's membership level (e.g., "Standard", "Premium")
@property(nonatomic, copy) NSString *membershipLevel;

/// Total orders count
@property(nonatomic, assign) NSInteger ordersCount;

#pragma mark - Initialization

/// Creates a user with required fields
/// @param userId Unique identifier
/// @param displayName User's display name
+ (instancetype)userWithId:(NSString *)userId
               displayName:(NSString *)displayName;

/// Initializes a user with required fields
- (instancetype)initWithId:(NSString *)userId
               displayName:(NSString *)displayName;

/// Unavailable - use designated initializer
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
