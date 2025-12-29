//
//  UserService.h
//  MVVM-C-ARC
//
//  Concrete implementation of UserServiceProtocol
//  ARC Version
//

#import "UserServiceProtocol.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserService : NSObject <UserServiceProtocol>

+ (instancetype)defaultService;

@end

NS_ASSUME_NONNULL_END
