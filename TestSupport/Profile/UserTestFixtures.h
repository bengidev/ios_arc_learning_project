//
//  UserTestFixtures.h
//  MVVM-C-ARC
//
//  Test fixtures for Profile feature
//  ARC Version
//

#import <Foundation/Foundation.h>

@class User;

NS_ASSUME_NONNULL_BEGIN

@interface UserTestFixtures : NSObject

+ (User *)sampleUser;
+ (User *)sampleUserWithId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
