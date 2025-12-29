//
//  CartViewModel.h
//  MVVM-C-ARC
//
//  ViewModel for cart screen
//  ARC Version
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CartViewModel : NSObject

@property(nonatomic, assign, readonly) NSInteger itemCount;
@property(nonatomic, assign, readonly) double totalAmount;

- (NSString *)formattedTotal;
- (NSString *)itemCountText;

@end

NS_ASSUME_NONNULL_END
