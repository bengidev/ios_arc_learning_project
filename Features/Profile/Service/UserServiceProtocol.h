//
//  UserServiceProtocol.h
//  MVVM-C-ARC
//
//  Protocol for user-related services
//  ARC Version
//

#import <Foundation/Foundation.h>

@class User;

NS_ASSUME_NONNULL_BEGIN

typedef void (^UserFetchCompletion)(User *_Nullable user,
                                    NSError *_Nullable error);

@protocol UserServiceProtocol <NSObject>

@required
- (void)fetchCurrentUserWithCompletion:(UserFetchCompletion)completion;
- (void)fetchUserWithId:(NSString *)userId
             completion:(UserFetchCompletion)completion;

@optional
- (void)updateUser:(User *)user
        completion:(void (^)(BOOL success, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
