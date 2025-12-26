//
//  DesignConstants.h
//  MVVM-C-ARC
//
//  Design system constants for consistent UI
//  ARC Version
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Layout Constants

/// Standard padding used throughout the app
extern CGFloat const kPaddingSmall;      // 8.0
extern CGFloat const kPaddingMedium;     // 16.0
extern CGFloat const kPaddingLarge;      // 20.0
extern CGFloat const kPaddingExtraLarge; // 24.0

/// Corner radius values
extern CGFloat const kCornerRadiusSmall;  // 4.0
extern CGFloat const kCornerRadiusMedium; // 8.0
extern CGFloat const kCornerRadiusLarge;  // 10.0

/// Button heights
extern CGFloat const kButtonHeightSmall;  // 36.0
extern CGFloat const kButtonHeightMedium; // 44.0
extern CGFloat const kButtonHeightLarge;  // 50.0

#pragma mark - Animation Constants

/// Standard animation duration
extern NSTimeInterval const kAnimationDurationFast;   // 0.2
extern NSTimeInterval const kAnimationDurationNormal; // 0.3
extern NSTimeInterval const kAnimationDurationSlow;   // 0.5

#pragma mark - Accessibility Identifiers

/// Product List Screen
extern NSString *const kAccessibilityProductListTableView;
extern NSString *const kAccessibilityProductCell;
extern NSString *const kAccessibilityRefreshControl;

/// Product Detail Screen
extern NSString *const kAccessibilityProductNameLabel;
extern NSString *const kAccessibilityProductPriceLabel;
extern NSString *const kAccessibilityProductRatingLabel;
extern NSString *const kAccessibilityProductDescriptionLabel;
extern NSString *const kAccessibilityReviewsButton;
extern NSString *const kAccessibilityAddToCartButton;

#pragma mark - Logging Subsystems

/// Returns the app's main log subsystem identifier
extern NSString *const kLogSubsystem;

NS_ASSUME_NONNULL_END

#pragma mark - Implementation

// Layout
CGFloat const kPaddingSmall = 8.0;
CGFloat const kPaddingMedium = 16.0;
CGFloat const kPaddingLarge = 20.0;
CGFloat const kPaddingExtraLarge = 24.0;

CGFloat const kCornerRadiusSmall = 4.0;
CGFloat const kCornerRadiusMedium = 8.0;
CGFloat const kCornerRadiusLarge = 10.0;

CGFloat const kButtonHeightSmall = 36.0;
CGFloat const kButtonHeightMedium = 44.0;
CGFloat const kButtonHeightLarge = 50.0;

// Animation
NSTimeInterval const kAnimationDurationFast = 0.2;
NSTimeInterval const kAnimationDurationNormal = 0.3;
NSTimeInterval const kAnimationDurationSlow = 0.5;

// Accessibility - Product List
NSString *const kAccessibilityProductListTableView = @"productListTableView";
NSString *const kAccessibilityProductCell = @"productCell";
NSString *const kAccessibilityRefreshControl = @"refreshControl";

// Accessibility - Product Detail
NSString *const kAccessibilityProductNameLabel = @"productNameLabel";
NSString *const kAccessibilityProductPriceLabel = @"productPriceLabel";
NSString *const kAccessibilityProductRatingLabel = @"productRatingLabel";
NSString *const kAccessibilityProductDescriptionLabel =
    @"productDescriptionLabel";
NSString *const kAccessibilityReviewsButton = @"reviewsButton";
NSString *const kAccessibilityAddToCartButton = @"addToCartButton";

// Logging
NSString *const kLogSubsystem = @"com.bengidev.mvvmc";
