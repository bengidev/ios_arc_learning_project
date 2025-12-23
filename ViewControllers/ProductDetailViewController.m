//
//  ProductDetailViewController.m
//  MVVM-C-ARC
//
//  ProductDetailViewController Implementation
//  ARC Version
//

#import "ProductDetailViewController.h"
#import "ProductDetailViewModel.h"

@interface ProductDetailViewController ()
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIStackView *stackView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) UILabel *ratingLabel;
@property(nonatomic, strong) UILabel *descriptionLabel;
@property(nonatomic, strong) UIButton *reviewsButton;
@property(nonatomic, strong) UIButton *addToCartButton;
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

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setupUI];
  [self bindViewModel];
}

- (void)setupUI {
  self.view.backgroundColor = [UIColor systemBackgroundColor];
  self.title = @"Product Details";

  // ScrollView for content
  self.scrollView = [[UIScrollView alloc] init];
  self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.scrollView];

  // StackView for layout
  self.stackView = [[UIStackView alloc] init];
  self.stackView.axis = UILayoutConstraintAxisVertical;
  self.stackView.spacing = 16;
  self.stackView.alignment = UIStackViewAlignmentFill;
  self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.scrollView addSubview:self.stackView];

  // Name Label
  self.nameLabel = [[UILabel alloc] init];
  self.nameLabel.font = [UIFont boldSystemFontOfSize:24];
  self.nameLabel.numberOfLines = 0;
  [self.stackView addArrangedSubview:self.nameLabel];

  // Price Label
  self.priceLabel = [[UILabel alloc] init];
  self.priceLabel.font = [UIFont systemFontOfSize:20
                                           weight:UIFontWeightSemibold];
  self.priceLabel.textColor = [UIColor systemGreenColor];
  [self.stackView addArrangedSubview:self.priceLabel];

  // Rating Label
  self.ratingLabel = [[UILabel alloc] init];
  self.ratingLabel.font = [UIFont systemFontOfSize:16];
  self.ratingLabel.textColor = [UIColor systemOrangeColor];
  [self.stackView addArrangedSubview:self.ratingLabel];

  // Description Label
  self.descriptionLabel = [[UILabel alloc] init];
  self.descriptionLabel.font = [UIFont systemFontOfSize:16];
  self.descriptionLabel.textColor = [UIColor secondaryLabelColor];
  self.descriptionLabel.numberOfLines = 0;
  [self.stackView addArrangedSubview:self.descriptionLabel];

  // Spacer
  UIView *spacer = [[UIView alloc] init];
  [spacer setContentHuggingPriority:UILayoutPriorityDefaultLow
                            forAxis:UILayoutConstraintAxisVertical];
  [self.stackView addArrangedSubview:spacer];

  // Reviews Button
  self.reviewsButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.reviewsButton setTitle:@"See Reviews" forState:UIControlStateNormal];
  self.reviewsButton.titleLabel.font =
      [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
  [self.reviewsButton addTarget:self
                         action:@selector(reviewsButtonTapped)
               forControlEvents:UIControlEventTouchUpInside];
  [self.stackView addArrangedSubview:self.reviewsButton];

  // Add to Cart Button
  self.addToCartButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.addToCartButton setTitle:@"Add to Cart" forState:UIControlStateNormal];
  self.addToCartButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
  self.addToCartButton.backgroundColor = [UIColor systemBlueColor];
  [self.addToCartButton setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];
  self.addToCartButton.layer.cornerRadius = 10;
  self.addToCartButton.contentEdgeInsets = UIEdgeInsetsMake(12, 24, 12, 24);
  [self.addToCartButton addTarget:self
                           action:@selector(addToCartButtonTapped)
                 forControlEvents:UIControlEventTouchUpInside];
  [self.stackView addArrangedSubview:self.addToCartButton];

  // Layout constraints
  UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
  [NSLayoutConstraint activateConstraints:@[
    [self.scrollView.topAnchor constraintEqualToAnchor:safeArea.topAnchor],
    [self.scrollView.leadingAnchor
        constraintEqualToAnchor:safeArea.leadingAnchor],
    [self.scrollView.trailingAnchor
        constraintEqualToAnchor:safeArea.trailingAnchor],
    [self.scrollView.bottomAnchor
        constraintEqualToAnchor:safeArea.bottomAnchor],

    [self.stackView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor
                                             constant:20],
    [self.stackView.leadingAnchor
        constraintEqualToAnchor:self.scrollView.leadingAnchor
                       constant:20],
    [self.stackView.trailingAnchor
        constraintEqualToAnchor:self.scrollView.trailingAnchor
                       constant:-20],
    [self.stackView.bottomAnchor
        constraintEqualToAnchor:self.scrollView.bottomAnchor
                       constant:-20],
    [self.stackView.widthAnchor
        constraintEqualToAnchor:self.scrollView.widthAnchor
                       constant:-40],

    [self.addToCartButton.heightAnchor constraintEqualToConstant:50]
  ]];
}

- (void)bindViewModel {
  self.nameLabel.text = self.viewModel.productName;
  self.priceLabel.text = self.viewModel.formattedPrice;
  self.ratingLabel.text =
      [NSString stringWithFormat:@"%@ • %@", self.viewModel.ratingString,
                                 self.viewModel.reviewCountString];
  self.descriptionLabel.text = self.viewModel.productDescription;
}

#pragma mark - Actions

- (void)reviewsButtonTapped {
  [self.viewModel showReviews];
}

- (void)addToCartButtonTapped {
  [self.viewModel addToCart];
}

#pragma mark - Debug

- (void)dealloc {
  NSLog(@"[ProductDetailViewController] dealloc");
}

@end
