//
//  AppDelegate.h
//  ARC Project
//
//  Created for ARC Learning
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

// ARC: Use 'strong' instead of 'retain'
@property(nonatomic, strong) UIWindow *window;
@property(nonatomic, strong) ViewController *viewController;

@end
