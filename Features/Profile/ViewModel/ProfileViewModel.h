//
//  ProfileViewModel.h
//  MVVM-C-ARC
//
//  ViewModel for profile screen
//  ARC Version
//

#import "UserServiceProtocol.h"
#import <Foundation/Foundation.h>

@class User;

NS_ASSUME_NONNULL_BEGIN

@protocol ProfileViewModelDelegate <NSObject>
- (void)userDidLoad:(User *)user;
@optional
- (void)loadingStateDidChange:(BOOL)isLoading;
@end

@interface ProfileViewModel : NSObject

@property(nonatomic, weak, nullable) id<ProfileViewModelDelegate> delegate;
@property(nonatomic, copy, nullable) void (^onError)(NSError *error);
@property(nonatomic, strong, readonly, nullable) User *user;
@property(nonatomic, assign, readonly) BOOL isLoading;

- (instancetype)initWithUserService:(id<UserServiceProtocol>)userService
                             userId:(nullable NSString *)userId;

- (void)loadProfile;

- (NSString *)displayName;
- (NSString *)displayEmail;
- (NSString *)memberSince;

@end

NS_ASSUME_NONNULL_END
