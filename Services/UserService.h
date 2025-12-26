//
//  UserService.h
//  MVVM-C-ARC
//
//  Concrete implementation of UserServiceProtocol
//  Uses sample data for demonstration purposes
//  ARC Version
//

#import "UserServiceProtocol.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Default implementation of UserServiceProtocol
/// Provides sample user data with simulated network delay
@interface UserService : NSObject <UserServiceProtocol>

/// Simulated network delay in seconds (default: 0.3)
@property(nonatomic, assign) NSTimeInterval simulatedDelay;

/// Creates a new UserService with default settings
+ (instancetype)defaultService;

/// Creates a new UserService with custom delay
/// @param delay Simulated network delay in seconds
- (instancetype)initWithSimulatedDelay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
