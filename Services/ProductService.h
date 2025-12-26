//
//  ProductService.h
//  MVVM-C-ARC
//
//  Concrete implementation of ProductServiceProtocol
//  Uses sample data for demonstration purposes
//  ARC Version
//

#import "ProductServiceProtocol.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Default implementation of ProductServiceProtocol
/// Provides sample product data with simulated network delay
@interface ProductService : NSObject <ProductServiceProtocol>

/// Simulated network delay in seconds (default: 0.5)
@property(nonatomic, assign) NSTimeInterval simulatedDelay;

/// Creates a new ProductService with default settings
+ (instancetype)defaultService;

/// Creates a new ProductService with custom delay
/// @param delay Simulated network delay in seconds
- (instancetype)initWithSimulatedDelay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
