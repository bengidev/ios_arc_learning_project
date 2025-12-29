//
//  DesignConstants.h
//  MVVM-C-ARC
//
//  Centralized design constants for consistent UI
//  ARC Version
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Layout Constants

/// Standard padding values
static const CGFloat kPaddingSmall = 8.0;
static const CGFloat kPaddingMedium = 16.0;
static const CGFloat kPaddingLarge = 24.0;
static const CGFloat kPaddingExtraLarge = 32.0;

/// Corner radius values
static const CGFloat kCornerRadiusSmall = 4.0;
static const CGFloat kCornerRadiusMedium = 8.0;
static const CGFloat kCornerRadiusLarge = 12.0;

/// Standard heights
static const CGFloat kButtonHeight = 44.0;
static const CGFloat kCellHeight = 60.0;
static const CGFloat kHeaderHeight = 44.0;

#pragma mark - Animation Constants

/// Animation durations
static const NSTimeInterval kAnimationDurationFast = 0.15;
static const NSTimeInterval kAnimationDurationNormal = 0.3;
static const NSTimeInterval kAnimationDurationSlow = 0.5;

#pragma mark - Accessibility Identifiers

/// Product List
static NSString *const kAccessibilityProductListTable = @"productListTable";
static NSString *const kAccessibilityProductCell = @"productCell";
static NSString *const kAccessibilityProductTitle = @"productTitle";
static NSString *const kAccessibilityProductPrice = @"productPrice";

/// Product Detail
static NSString *const kAccessibilityProductDetailView = @"productDetailView";
static NSString *const kAccessibilityAddToCartButton = @"addToCartButton";
static NSString *const kAccessibilityProductDescription = @"productDescription";

/// Profile
static NSString *const kAccessibilityProfileView = @"profileView";
static NSString *const kAccessibilityProfileName = @"profileName";
static NSString *const kAccessibilityProfileEmail = @"profileEmail";
static NSString *const kAccessibilityEditProfileButton = @"editProfileButton";

/// Cart
static NSString *const kAccessibilityCartView = @"cartView";
static NSString *const kAccessibilityCartTable = @"cartTable";
static NSString *const kAccessibilityCheckoutButton = @"checkoutButton";

/// Settings
static NSString *const kAccessibilitySettingsView = @"settingsView";
static NSString *const kAccessibilitySettingsTable = @"settingsTable";

/// Tab Bar
static NSString *const kAccessibilityTabProducts = @"tabProducts";
static NSString *const kAccessibilityTabProfile = @"tabProfile";
static NSString *const kAccessibilityTabCart = @"tabCart";
static NSString *const kAccessibilityTabSettings = @"tabSettings";

#pragma mark - Tab Bar Configuration

/// Tab bar indices
typedef NS_ENUM(NSInteger, TabIndex) {
  TabIndexProducts = 0,
  TabIndexProfile = 1,
  TabIndexCart = 2,
  TabIndexSettings = 3
};

NS_ASSUME_NONNULL_END
