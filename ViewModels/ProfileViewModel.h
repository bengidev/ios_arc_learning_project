//
//  ProfileViewModel.h
//  MVVM-C-ARC
//
//  ProfileViewModel - ViewModel for user profile screen
//  ARC Version
//

#import <Foundation/Foundation.h>

@class User;
@class ProfileViewModel;
@protocol UserServiceProtocol;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Delegate Protocol

@protocol ProfileViewModelDelegate <NSObject>
@optional
/// Called when the user wants to edit their profile
- (void)viewModelDidRequestEditProfile:(ProfileViewModel *)viewModel;

/// Called when the user wants to view their orders
- (void)viewModelDidRequestViewOrders:(ProfileViewModel *)viewModel;

/// Called when the user wants to logout
- (void)viewModelDidRequestLogout:(ProfileViewModel *)viewModel;

/// Called when the user wants to go back
- (void)viewModelDidRequestDismiss:(ProfileViewModel *)viewModel;
@end

#pragma mark - ViewModel Interface

@interface ProfileViewModel : NSObject

/// Delegate for navigation events (WEAK to avoid retain cycle)
@property(nonatomic, weak, nullable) id<ProfileViewModelDelegate> delegate;

/// The user being displayed
@property(nonatomic, strong, readonly, nullable) User *user;

/// Whether the view model is currently loading
@property(nonatomic, assign, readonly, getter=isLoading) BOOL loading;

/// Error message if loading failed
@property(nonatomic, copy, readonly, nullable) NSString *errorMessage;

#pragma mark - Display Properties

/// User's display name
@property(nonatomic, copy, readonly) NSString *displayName;

/// User's email with verification status
@property(nonatomic, copy, readonly, nullable) NSString *emailDisplay;

/// User's phone number
@property(nonatomic, copy, readonly, nullable) NSString *phoneNumber;

/// Membership level badge text
@property(nonatomic, copy, readonly) NSString *membershipBadge;

/// Order count string (e.g., "42 orders")
@property(nonatomic, copy, readonly) NSString *ordersCountString;

/// Member since string (e.g., "Member since Jan 2023")
@property(nonatomic, copy, readonly, nullable) NSString *memberSinceString;

/// Avatar URL if available
@property(nonatomic, copy, readonly, nullable) NSString *avatarURL;

#pragma mark - Block-based Callbacks

/// Called when profile data is loaded/refreshed
@property(nonatomic, copy, nullable) void (^onProfileLoaded)(BOOL success);

/// Called when an error occurs
@property(nonatomic, copy, nullable) void (^onError)(NSError *error);

/// Called when logout is complete
@property(nonatomic, copy, nullable) void (^onLogoutComplete)(BOOL success);

#pragma mark - Initialization

/// Initializes with a user service (preferred for testability)
/// @param userService The service to fetch user data from
- (instancetype)initWithUserService:(id<UserServiceProtocol>)userService;

/// Initializes with a specific user ID
/// @param userId The ID of the user to display
/// @param userService The service to fetch user data from
- (instancetype)initWithUserId:(nullable NSString *)userId
                   userService:(id<UserServiceProtocol>)userService;

/// Unavailable - use designated initializer
- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Actions

/// Loads or refreshes the user profile
- (void)loadProfile;

/// Request to edit profile
- (void)editProfile;

/// Request to view orders
- (void)viewOrders;

/// Request to logout
- (void)logout;

/// Dismiss this screen
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
