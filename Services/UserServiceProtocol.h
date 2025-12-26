//
//  UserServiceProtocol.h
//  MVVM-C-ARC
//
//  Protocol defining user data fetching interface
//  Enables dependency injection and testability
//  ARC Version
//

#import <Foundation/Foundation.h>

@class User;

NS_ASSUME_NONNULL_BEGIN

/// Completion block for fetching a user
typedef void (^UserCompletionBlock)(User *_Nullable user,
                                    NSError *_Nullable error);

/// Completion block for update operations
typedef void (^UserUpdateCompletionBlock)(BOOL success,
                                          NSError *_Nullable error);

/// Protocol defining the interface for user data operations
/// Implementations can fetch from network, cache, or mock data
@protocol UserServiceProtocol <NSObject>

@required

/// Fetches the current logged-in user
/// @param completion Called on main thread with user or error
- (void)fetchCurrentUserWithCompletion:(UserCompletionBlock)completion;

/// Fetches a user by their ID
/// @param userId The unique identifier of the user
/// @param completion Called on main thread with user or error
- (void)fetchUserWithId:(NSString *)userId
             completion:(UserCompletionBlock)completion;

@optional

/// Updates the current user's profile
/// @param user The user with updated fields
/// @param completion Called on main thread with success status or error
- (void)updateUser:(User *)user
        completion:(UserUpdateCompletionBlock)completion;

/// Logs out the current user
/// @param completion Called on main thread with success status
- (void)logoutWithCompletion:(UserUpdateCompletionBlock)completion;

/// Clears any cached user data
- (void)clearCache;

@end

NS_ASSUME_NONNULL_END
