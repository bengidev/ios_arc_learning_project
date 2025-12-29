//
//  CartViewModel.m
//  MVVM-C-ARC
//
//  CartViewModel Implementation (Placeholder)
//  ARC Version
//

#import "CartViewModel.h"

@implementation CartViewModel

- (instancetype)init {
  self = [super init];
  if (self) {
    _itemCount = 0;
    _totalAmount = 0.0;
  }
  return self;
}

- (NSString *)formattedTotal {
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  formatter.numberStyle = NSNumberFormatterCurrencyStyle;
  return [formatter stringFromNumber:@(self.totalAmount)] ?: @"$0.00";
}

- (NSString *)itemCountText {
  if (self.itemCount == 0)
    return @"Your cart is empty";
  if (self.itemCount == 1)
    return @"1 item in cart";
  return [NSString stringWithFormat:@"%ld items in cart", (long)self.itemCount];
}

@end
