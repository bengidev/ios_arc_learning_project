//
//  Coordinator.h
//  MVVM-C-ARC
//
//  Coordinator Protocol - Defines the interface for all coordinators
//  ARC Version
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Coordinator <NSObject>

@required
/// Array of child coordinators managed by this coordinator
@property (nonatomic, strong) NSMutableArray<id<Coordinator>> *childCoordinators;

/// The navigation controller used for pushing view controllers
@property (nonatomic, strong) UINavigationController *navigationController;

/// Starts the coordinator flow
- (void)start;

@optional
/// Reference to parent coordinator (should be weak to avoid retain cycles)
@property (nonatomic, weak, nullable) id<Coordinator> parentCoordinator;

/// Called when this coordinator's flow is complete
- (void)coordinatorDidFinish:(id<Coordinator>)coordinator;

@end

NS_ASSUME_NONNULL_END
