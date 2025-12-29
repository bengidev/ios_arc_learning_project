//
//  ProductDetailViewController.m
//  MVVM-C-ARC
//
//  ProductDetailViewController Implementation
//  ARC Version
//

#import "ProductDetailViewController.h"
#import "DesignConstants.h"
#import "Product.h"
#import "ProductDetailViewModel.h"
#import <os/log.h>

static os_log_t ProductDetailVCLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "ProductDetailVC");
  });
  return log;
}

@interface ProductDetailViewController () <ProductDetailViewModelDelegate>
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIStackView *contentStack;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) UILabel *ratingLabel;
@property(nonatomic, strong) UILabel *availabilityLabel;
@property(nonatomic, strong) UILabel *descriptionLabel;
@property(nonatomic, strong) UIButton *addToCartButton;
@property(nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@end

@implementation ProductDetailViewController

#pragma mark - Initialization

- (instancetype)initWithViewModel:(ProductDetailViewModel *)viewModel {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _viewModel = viewModel;
  }
  return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setupUI];
  [self setupBindings];

  [self.viewModel loadProductDetails];
}

#pragma mark - UI Setup

- (void)setupUI {
  self.title = @"Product Details";
  self.view.backgroundColor = [UIColor systemBackgroundColor];
  self.view.accessibilityIdentifier = kAccessibilityProductDetailView;

  // Scroll View
  self.scrollView = [[UIScrollView alloc] init];
  self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.scrollView];

  // Content Stack
  self.contentStack = [[UIStackView alloc] init];
  self.contentStack.translatesAutoresizingMaskIntoConstraints = NO;
  self.contentStack.axis = UILayoutConstraintAxisVertical;
  self.contentStack.spacing = kPaddingMedium;
  self.contentStack.alignment = UIStackViewAlignmentFill;
  [self.scrollView addSubview:self.contentStack];

  // Product Image Placeholder
  UIImageView *imageView = [[UIImageView alloc] init];
  imageView.translatesAutoresizingMaskIntoConstraints = NO;
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  imageView.backgroundColor = [UIColor systemGray5Color];
  imageView.image = [UIImage systemImageNamed:@"cube.box"];
  imageView.tintColor = [UIColor systemGray2Color];
  imageView.layer.cornerRadius = kCornerRadiusLarge;
  imageView.clipsToBounds = YES;
  [self.contentStack addArrangedSubview:imageView];
  [imageView.heightAnchor constraintEqualToConstant:200].active = YES;

  // Name Label
  self.nameLabel = [[UILabel alloc] init];
  self.nameLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
  self.nameLabel.numberOfLines = 0;
  self.nameLabel.accessibilityIdentifier = kAccessibilityProductTitle;
  [self.contentStack addArrangedSubview:self.nameLabel];

  // Price Label
  self.priceLabel = [[UILabel alloc] init];
  self.priceLabel.font = [UIFont systemFontOfSize:22
                                           weight:UIFontWeightSemibold];
  self.priceLabel.textColor = [UIColor systemGreenColor];
  self.priceLabel.accessibilityIdentifier = kAccessibilityProductPrice;
  [self.contentStack addArrangedSubview:self.priceLabel];

  // Rating Label
  self.ratingLabel = [[UILabel alloc] init];
  self.ratingLabel.font = [UIFont systemFontOfSize:16];
  self.ratingLabel.textColor = [UIColor systemOrangeColor];
  [self.contentStack addArrangedSubview:self.ratingLabel];

  // Availability Label
  self.availabilityLabel = [[UILabel alloc] init];
  self.availabilityLabel.font = [UIFont systemFontOfSize:16
                                                  weight:UIFontWeightMedium];
  [self.contentStack addArrangedSubview:self.availabilityLabel];

  // Description Label
  self.descriptionLabel = [[UILabel alloc] init];
  self.descriptionLabel.font = [UIFont systemFontOfSize:16];
  self.descriptionLabel.textColor = [UIColor secondaryLabelColor];
  self.descriptionLabel.numberOfLines = 0;
  self.descriptionLabel.accessibilityIdentifier =
      kAccessibilityProductDescription;
  [self.contentStack addArrangedSubview:self.descriptionLabel];

  // Spacer
  UIView *spacer = [[UIView alloc] init];
  [self.contentStack addArrangedSubview:spacer];

  // Add to Cart Button
  self.addToCartButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.addToCartButton setTitle:@"Add to Cart" forState:UIControlStateNormal];
  self.addToCartButton.titleLabel.font =
      [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
  self.addToCartButton.backgroundColor = [UIColor systemBlueColor];
  [self.addToCartButton setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];
  self.addToCartButton.layer.cornerRadius = kCornerRadiusMedium;
  self.addToCartButton.accessibilityIdentifier = kAccessibilityAddToCartButton;
  [self.addToCartButton addTarget:self
                           action:@selector(addToCartTapped)
                 forControlEvents:UIControlEventTouchUpInside];
  [self.contentStack addArrangedSubview:self.addToCartButton];
  [self.addToCartButton.heightAnchor constraintEqualToConstant:kButtonHeight]
      .active = YES;

  // Loading Indicator
  self.loadingIndicator = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
  self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = NO;
  self.loadingIndicator.hidesWhenStopped = YES;
  [self.view addSubview:self.loadingIndicator];

  // Constraints
  [NSLayoutConstraint activateConstraints:@[
    [self.scrollView.topAnchor
        constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
    [self.scrollView.leadingAnchor
        constraintEqualToAnchor:self.view.leadingAnchor],
    [self.scrollView.trailingAnchor
        constraintEqualToAnchor:self.view.trailingAnchor],
    [self.scrollView.bottomAnchor
        constraintEqualToAnchor:self.view.bottomAnchor],

    [self.contentStack.topAnchor
        constraintEqualToAnchor:self.scrollView.topAnchor
                       constant:kPaddingMedium],
    [self.contentStack.leadingAnchor
        constraintEqualToAnchor:self.scrollView.leadingAnchor
                       constant:kPaddingMedium],
    [self.contentStack.trailingAnchor
        constraintEqualToAnchor:self.scrollView.trailingAnchor
                       constant:-kPaddingMedium],
    [self.contentStack.bottomAnchor
        constraintEqualToAnchor:self.scrollView.bottomAnchor
                       constant:-kPaddingMedium],
    [self.contentStack.widthAnchor
        constraintEqualToAnchor:self.scrollView.widthAnchor
                       constant:-2 * kPaddingMedium],

    [self.loadingIndicator.centerXAnchor
        constraintEqualToAnchor:self.view.centerXAnchor],
    [self.loadingIndicator.centerYAnchor
        constraintEqualToAnchor:self.view.centerYAnchor]
  ]];
}

- (void)setupBindings {
  self.viewModel.delegate = self;

  __weak typeof(self) weakSelf = self;
  self.viewModel.onError = ^(NSError *error) {
    [weakSelf showError:error];
  };
}

#pragma mark - Actions

- (void)addToCartTapped {
  [self.viewModel addToCart];
}

- (void)showError:(NSError *)error {
  UIAlertController *alert =
      [UIAlertController alertControllerWithTitle:@"Error"
                                          message:error.localizedDescription
                                   preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                          handler:nil]];
  [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ProductDetailViewModelDelegate

- (void)productDidLoad:(Product *)product {
  os_log_info(ProductDetailVCLog(), "Displaying product: %{public}@",
              product.name);

  self.title = product.name;
  self.nameLabel.text = product.name;
  self.priceLabel.text = [self.viewModel formattedPrice];
  self.ratingLabel.text = [self.viewModel formattedRating];
  self.descriptionLabel.text = product.productDescription;

  NSString *availability = [self.viewModel availabilityText];
  self.availabilityLabel.text = availability;
  self.availabilityLabel.textColor =
      product.inStock ? [UIColor systemGreenColor] : [UIColor systemRedColor];

  self.addToCartButton.enabled = product.inStock;
  self.addToCartButton.alpha = product.inStock ? 1.0 : 0.5;
}

- (void)loadingStateDidChange:(BOOL)isLoading {
  if (isLoading) {
    [self.loadingIndicator startAnimating];
    self.scrollView.hidden = YES;
  } else {
    [self.loadingIndicator stopAnimating];
    self.scrollView.hidden = NO;
  }
}

- (void)didAddToCart:(Product *)product {
  UIAlertController *alert = [UIAlertController
      alertControllerWithTitle:@"Added to Cart"
                       message:[NSString stringWithFormat:
                                             @"%@ has been added to your cart.",
                                             product.name]
                preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                          handler:nil]];
  [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Debug

- (void)dealloc {
  os_log_debug(ProductDetailVCLog(), "dealloc");
}

@end
