//
//  AppDelegate.h
//  MVVM-C-ARC
//
//  Application Delegate
//  ARC Version
//

#import <UIKit/UIKit.h>

@class AppCoordinator;

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate : UIResponder <UIApplicationDelegate>

/// The app's main window
@property(nonatomic, strong) UIWindow *window;

/// The root coordinator managing the app flow
@property(nonatomic, strong) AppCoordinator *appCoordinator;

@end

NS_ASSUME_NONNULL_END
