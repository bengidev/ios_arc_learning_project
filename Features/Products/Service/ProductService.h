//
//  ProductService.h
//  MVVM-C-ARC
//
//  Concrete implementation of ProductServiceProtocol
//  ARC Version
//

#import "ProductServiceProtocol.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductService : NSObject <ProductServiceProtocol>

/// Returns the default shared service instance
+ (instancetype)defaultService;

/// Initialize with custom configuration
- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
