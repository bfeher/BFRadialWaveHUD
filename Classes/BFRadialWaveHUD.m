//
//  BFRadialWaveHUD.m
//  BFRadialWaveHUD
//
//  Created by Bence Feher on 2/10/15.
//  Copyright (c) 2015 Bence Feher. All rights reserved.
//

#import "BFRadialWaveHUD.h"
// Categories:
#import "UIImage+KVNImageEffects.h"
#import "UIImage+KVNEmpty.h"
// Pods:
#import "BFRadialWaveView.h"
#import "UIColor+BFPaperColors.h"


#define BFIpad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define BFSystemVersionGreaterOrEqual_iOS_8 ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending)



@interface BFRadialWaveHUD () <BFRadialWaveViewDelegate>
// XIB Outlets:
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

// Content View:
@property (weak, nonatomic) IBOutlet UIImageView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthConstraint;

// Radial View
@property (strong, nonatomic) IBOutlet BFRadialWaveView *radialWaveView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *radialViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *radialViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *radialViewToContentViewTopVerticalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *radialViewToMessageLabelVerticalConstraint;
@property UIColor *circleColor;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) NSInteger circleCount;
@property BFRadialWaveHUDMode mode;

// Message Label
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelToContentViewBottomVerticalConstraint;

@property (nonatomic) NSArray *constraintsToSuperview;

@property UIView *container;
@property NSString *message;
@property BOOL isFullScreen;
@property (nonatomic) CGFloat progress;
@property (nonatomic, copy) void (^completionBlock)(BOOL finished);
@property CGFloat animationDuration;
@property CGFloat messageAnimationDuration;
@property BOOL atTheDisco;
@end



@implementation BFRadialWaveHUD
#pragma mark - Constants
// Public:
NSInteger const BFRadialWaveHUD_DefaultNumberOfCircles = 20;
CGFloat const BFRadialWaveHUD_DefaultCircleStrokeWidth = 2.f;
CGFloat const BFRadialWaveHUD_CircleProgressViewToStatusLabelVerticalSpaceConstraintConstant = 10.0f;
// Private:
static CGFloat const BFRadialWaveHUD_MotionEffectRelativeValue = 10.f;
static CGFloat const BFRadialWaveHUD_ContentViewWithStatusInset = 10.0f;
static CGFloat const BFRadialWaveHUD_ContentViewWithoutStatusInset = 20.0f;
static CGFloat const BFRadialWaveHUD_AlertViewWidth = 270.0f;
static CGFloat const BFRadialWaveHUD_ContentViewFullScreenModeLeadingAndTrailingSpaceConstraintConstant = 0.0f;
static CGFloat const BFRadialWaveHUD_ContentViewNotFullScreenModeLeadingAndTrailingSpaceConstraintConstant = 25.0f;
static CGFloat const BFRadialWaveHUD_TextUpdateAnimationDuration = 0.5f;
static CGFloat const BFRadialWaveHUD_LayoutAnimationDuration = 0.3f;
static CGFloat const BFRadialWaveHUD_ContentViewCornerRadius = 8.0f;
static CGFloat const BFRadialWaveHUD_ContentViewWithoutStatusCornerRadius = 15.0f;



#pragma mark - Custom Initializers
- (instancetype)initWithView:(UIView *)containerView
                  fullScreen:(BOOL)fullscreen
                     circles:(NSInteger)numberOfCircles
                 circleColor:(UIColor *)circleColor
                        mode:(BFRadialWaveHUDMode)mode
                 strokeWidth:(CGFloat)strokeWidth
{
    UINib *nib = [UINib nibWithNibName:@"BFRadialWaveHUD"
                                bundle:[NSBundle bundleForClass:[self class]]];
    NSArray *nibViews = [nib instantiateWithOwner:self
                                          options:0];
    self = nibViews[0];
    if (self) {
        [self setUpWithContainer:containerView
                      fullScreen:fullscreen
                 numberOfCircles:numberOfCircles
                           color:circleColor
                            mode:mode
                     strokeWidth:strokeWidth];
    }
    return self;
}


#pragma mark - Life cycle
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self registerForNotifications];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Notifications
- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)orientationDidChange:(NSNotification *)notification
{
    if (!self.isShowing) { return; }
    
    if ([self.superview isKindOfClass:[UIWindow class]]) {
        [UIView animateWithDuration:0.3f
                         animations:^{
                             [self updateUIForOrientation];
                         }];
    } else {
        [self updateUIForOrientation];
    }
}


#pragma mark - Super Overrides
- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.hud.frame = self.container.bounds;
}

/*- (void)updateConstraints
{
    [self removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];
    
    if (self != nil) {
        UIView *view = self;
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        
        [self.customConstraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"H:|[view]|" options:0 metrics:nil views:views]];
        [self.customConstraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"V:|[view]|" options:0 metrics:nil views:views]];
        
        [self.containerView addConstraints:self.customConstraints];
    }
    
    [super updateConstraints];
}*/


#pragma mark - Setters and Getters
- (void)setMessageFont:(UIFont *)messageFont
{
    _messageFont = messageFont;
    self.messageLabel.font = _messageFont;
    [self updateMessageConstraints];
}

- (void)setMessageColor:(UIColor *)messageColor
{
    _messageColor = messageColor;
    self.messageLabel.textColor = _messageColor;
}

- (void)setHUDColor:(UIColor *)HUDColor
{
    _HUDColor = HUDColor;
    self.contentView.backgroundColor = _HUDColor;
}

- (void)setBackgroundFadeColor:(UIColor *)backgroundFadeColor
{
    _backgroundFadeColor = backgroundFadeColor;
    self.backgroundColor = self.isFullScreen ? [UIColor clearColor] : _backgroundFadeColor;
}

- (void)setTapToDismiss:(BOOL)tapToDismiss
{
    _tapToDismiss = tapToDismiss;
    [self setupGestures];
}

- (void)setBlurBackground:(BOOL)blurBackground
{
    _blurBackground = blurBackground;
    [self updateBackground];
}

- (void)setProgressCircleColor:(UIColor *)progressCircleColor
{
    if (!progressCircleColor) { return; }
    _progressCircleColor = progressCircleColor;
    [self.radialWaveView setProgressCircleColor:progressCircleColor];
}

- (void)setCheckmarkColor:(UIColor *)checkmarkColor
{
    if (!checkmarkColor) { return; }
    _checkmarkColor = checkmarkColor;
    [self.radialWaveView setCheckmarkColor:checkmarkColor];
}

- (void)setCrossColor:(UIColor *)crossColor
{
    if (!crossColor) { return; }
    _crossColor = crossColor;
    [self.radialWaveView setCrossColor:crossColor];
}

- (void)setDiscoColors:(NSArray *)discoColors
{
    _discoColors = discoColors;
    self.radialWaveView.discoColors = discoColors;
    if (self.atTheDisco) {
        // Remove disco animation:
        [self.radialWaveView disco:NO];
        // Get back to discoing:
        [self.radialWaveView disco:YES];
    }
}

- (void)setDiscoSpeed:(CGFloat)discoSpeed
{
    _discoSpeed = discoSpeed;
    self.radialWaveView.discoSpeed = discoSpeed;
    if (self.atTheDisco) {
        // Remove disco animation:
        [self.radialWaveView disco:NO];
        // Get back to discoing:
        [self.radialWaveView disco:YES];
    }
}


#pragma mark - Setup
- (void)setUpWithContainer:(UIView *)containerView
                fullScreen:(BOOL)fullscreen
           numberOfCircles:(NSInteger)circles
                     color:(UIColor *)circleColor
                      mode:(BFRadialWaveHUDMode)mode
               strokeWidth:(CGFloat)strokeWidth
{
    NSInteger numberOfCircles = circles;
    if (circles < 3) {
        NSLog(@"Must have at least 3 circles! Creating %ld more to accomodate for this...", 3 - (long)circles);
        numberOfCircles = 3;
    }
    
    CGFloat lineWidth = strokeWidth;
    if (lineWidth < 1.f) {
        NSLog(@"Stroke width must fall in the range [1.0, 5.0]. Adjusting to 1.f...");
        lineWidth = 1.f;
    }
    else if (lineWidth > 5.f) {
        NSLog(@"Stroke width must fall in the range [1.0, 5.0]. Adjusting to 5.f...");
        lineWidth = 5.f;
    }
    
    self.frame = containerView.bounds;
    
    self.container = containerView;
    self.circleCount = numberOfCircles;
    self.circleColor = circleColor ? circleColor : [UIColor paperColorGray50];
    self.lineWidth = lineWidth;
    self.mode = mode;
    self.isFullScreen = fullscreen;

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Defaults for visual properties:                                                                                      //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Private:
    self.animationDuration           = 1.f;
    self.messageAnimationDuration    = 0.5f;
    self.message                     = nil;
    self.atTheDisco                  = NO;
    // Public:
    self.messageFont                 = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.f];
    self.messageColor                = self.circleColor;
    self.HUDColor                    = [UIColor colorWithWhite:0.13f alpha:0.85f];
    self.backgroundFadeColor         = [UIColor colorWithWhite:1.f alpha:0.6f];
    self.progressCircleColor         = self.circleColor;
    self.checkmarkColor              = self.circleColor;
    self.crossColor                  = self.circleColor;
    self.tapToDismiss                = NO;
    self.tapToDismissCompletionBlock = nil;
    _isShowing                       = NO;
    self.discoColors                 = nil;
    self.discoSpeed                  = 0.33f;
    self.alpha                       = 0;
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    self.backgroundColor = fullscreen ? [UIColor clearColor] : self.backgroundFadeColor;
    
    [self setupRadialWaveView];
}

- (void)setupUI
{
    [self setupGestures];
    [self setupConstraints];
    [self setupMessage:self.message];
    [self setupBackground];
}

- (void)setupConstraints
{
    CGRect bounds = [self correctedBounds];
    CGFloat messageInset = (self.message.length > 0) ? BFRadialWaveHUD_ContentViewWithStatusInset : BFRadialWaveHUD_ContentViewWithoutStatusInset;
    CGFloat contentWidth;
    
    if (!BFSystemVersionGreaterOrEqual_iOS_8 && [self.superview isKindOfClass:UIWindow.class]) {
        self.transform = CGAffineTransformMakeRotation([self rotationForStatusBarOrientation]);
    } else {
        self.transform = CGAffineTransformIdentity;
    }
    
    if ([self isFullScreen]) {
        contentWidth = CGRectGetWidth(bounds) - (2 * BFRadialWaveHUD_ContentViewFullScreenModeLeadingAndTrailingSpaceConstraintConstant);
    } else {
        if (BFIpad) {
            contentWidth = BFRadialWaveHUD_AlertViewWidth;
        } else {
            contentWidth = CGRectGetWidth(bounds) - (2 * BFRadialWaveHUD_ContentViewNotFullScreenModeLeadingAndTrailingSpaceConstraintConstant);
            
            if (contentWidth > BFRadialWaveHUD_AlertViewWidth) {
                contentWidth = BFRadialWaveHUD_AlertViewWidth;
            }
        }
    }
    
    self.radialViewToContentViewTopVerticalConstraint.constant = messageInset;
    self.messageLabelToContentViewBottomVerticalConstraint.constant = messageInset;
    self.contentViewWidthConstraint.constant = contentWidth;
    
    [self layoutIfNeeded];
}

- (void)setupRadialWaveView
{
    if (self.isShowing) { return; }
    
    // Set up BFRadialWave view:
    [self.radialWaveView setupWithView:self.contentView
                               circles:self.circleCount
                                 color:self.circleColor
                                  mode:(BFRadialWaveViewMode)self.mode
                           strokeWidth:self.lineWidth
                          withGradient:YES];
    
    self.radialWaveView.delegate = self;
}

- (void)setupMessage:(NSString *)message
{
    self.message = message;
    
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = BFRadialWaveHUD_TextUpdateAnimationDuration;
    [self.messageLabel.layer addAnimation:animation forKey:@"kCATransitionFade"];
    
    self.messageLabel.text = self.message;
    self.messageLabel.textColor = self.messageColor;
    self.messageLabel.font = self.messageFont;
    self.messageLabel.hidden = !(self.message.length > 0);
    
    [self updateMessageConstraints];
}

- (void)setupBackground
{
    if (self.isShowing) {
        return; // No reload of background when view is showing
    }
    
    [self updateBackground];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setupMotionEffect];
    });
}

- (void)setupMotionEffect
{
    UIInterpolatingMotionEffect *xAxis = [self motionEffectWithType:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis
                                                            keyPath:@"center.x"];
    UIInterpolatingMotionEffect *yAxis = [self motionEffectWithType:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis
                                                            keyPath:@"center.y"];
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[xAxis, yAxis];
    
    [self.contentView addMotionEffect:group];
}

- (void)setupGestures
{
    for (UIGestureRecognizer *gestureRecognizer in self.gestureRecognizers) {
        [self removeGestureRecognizer:gestureRecognizer];
    }
    
    if (self.tapToDismiss) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(dismissByTap)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
}


#pragma mark - Loading
- (void)show
{
    [self showProgress:0 withMessage:nil];
}

- (void)showWithMessage:(NSString *)message
{
    [self showProgress:0 withMessage:message];
}

#pragma mark - Progress
- (void)showProgress:(CGFloat)progress
{
    [self showProgress:progress withMessage:nil];
}

- (void)showProgress:(CGFloat)progress
         withMessage:(NSString *)message
{
    self.message = message;
    [self appear];
    [self.radialWaveView showProgress:progress];
    [self updateRadialWaveViewConstraints];
}


#pragma mark - Success
- (void)showSuccess
{
    [self showSuccessWithMessage:nil completion:nil];
}

- (void)showSuccessWithCompletion:(void (^)(BOOL finished))completionBlock
{
    [self showSuccessWithMessage:nil completion:completionBlock];
}

- (void)showSuccessWithMessage:(NSString *)message
{
    [self showSuccessWithMessage:message completion:nil];
}

- (void)showSuccessWithMessage:(NSString *)message
                    completion:(void (^)(BOOL finished))completionBlock
{
    self.message = message;
    self.completionBlock = completionBlock;
    [self appear];
    [self updateRadialWaveViewConstraintsManuallyToDiameter:self.radialWaveView.diameter];
    [self.radialWaveView showSuccess];
    [self updateRadialWaveViewConstraints];
}


#pragma mark - Error
- (void)showError
{
    [self showErrorWithMessage:nil completion:nil];
}

- (void)showErrorWithCompletion:(void (^)(BOOL finished))completionBlock
{
    [self showErrorWithMessage:nil completion:completionBlock];
}

- (void)showErrorWithMessage:(NSString *)message
{
    [self showErrorWithMessage:message completion:nil];
}

- (void)showErrorWithMessage:(NSString *)message
                  completion:(void (^)(BOOL finished))completionBlock
{
    self.message = message;
    self.completionBlock = completionBlock;
    [self appear];
    [self updateRadialWaveViewConstraintsManuallyToDiameter:self.radialWaveView.diameter];
    [self.radialWaveView showError];
    [self updateRadialWaveViewConstraints];
}


#pragma mark - Dismiss
- (void)dismiss
{
    [self dismissAfterDelay:0.f withCompletion:nil];
}

- (void)dismissByTap
{
    [self dismissAfterDelay:0.f withCompletion:self.tapToDismissCompletionBlock];
}

- (void)dismissWithCompletion:(void (^)(BOOL finished))completionBlock
{
    [self dismissAfterDelay:0.f withCompletion:completionBlock];
}

- (void)dismissAfterDelay:(CGFloat)delayInSeconds
{
    [self dismissAfterDelay:delayInSeconds withCompletion:nil];
}

- (void)dismissAfterDelay:(CGFloat)delayInSeconds withCompletion:(void (^)(BOOL))completionBlock
{
    dispatch_main_after(delayInSeconds, ^{
        [self disappearWithCompletion:completionBlock];
    });
}


#pragma mark - Update
- (void)updateMessage:(NSString *)message
{
    if (self.isShowing) {
        [UIView animateWithDuration:BFRadialWaveHUD_LayoutAnimationDuration
                         animations:^{
                             [self setupMessage:message];
                         }];
    }
    else {
        [self setupMessage:message];
    }
}

- (void)updateMessageConstraints
{
    BOOL showMessage = (self.message.length > 0);
    
    self.radialViewToMessageLabelVerticalConstraint.constant = (showMessage) ? BFRadialWaveHUD_CircleProgressViewToStatusLabelVerticalSpaceConstraintConstant : 0.0f;
    
    CGSize maximumLabelSize = CGSizeMake(CGRectGetWidth(self.messageLabel.bounds), CGFLOAT_MAX);
    CGSize statusLabelSize = [self.messageLabel sizeThatFits:maximumLabelSize];
    self.messageLabelHeightConstraint.constant = statusLabelSize.height;
    
    [self layoutIfNeeded];
    [self.radialWaveView setNeedsLayout];
    [self.radialWaveView layoutIfNeeded];
}

- (void)updateRadialWaveViewConstraints
{
    // Constraints
    self.radialViewWidthConstraint.constant = self.radialWaveView.diameter + 3.f;
    self.radialViewHeightConstraint.constant = self.radialWaveView.diameter + 3.f;
    
    [self layoutIfNeeded];
}

- (void)updateRadialWaveViewConstraintsManuallyToDiameter:(CGFloat)diameter
{
    // Constraints
    self.radialViewWidthConstraint.constant = diameter + 3.f;
    self.radialViewHeightConstraint.constant = diameter + 3.f;
    
    [self layoutIfNeeded];
}

- (void)updateProgress:(CGFloat)progress
{
    if (progress > self.progress) {
        [self.radialWaveView updateProgress:progress];
        [self updateRadialWaveViewConstraints];
    }
}

- (void)updateUIForOrientation
{
    [self setupConstraints];
    [self updateMessageConstraints];
    [self updateBackgroundConstraints];
}

- (void)updateBackground
{
    UIImage *backgroundImage = nil;
    UIColor *backgroundColor = nil;
    
    if (self.blurBackground) {
        backgroundImage = [self blurredScreenShot];
        backgroundColor = [UIColor clearColor];
    }
    else {
        backgroundImage = [UIImage emptyImage];
        backgroundColor = self.HUDColor;
    }
    
    if (!BFSystemVersionGreaterOrEqual_iOS_8
        && !CGAffineTransformEqualToTransform(self.transform, CGAffineTransformIdentity))
    {
        CIImage *transformedCIImage = backgroundImage.CIImage;
        
        if (!transformedCIImage) {
            transformedCIImage = [CIImage imageWithCGImage:backgroundImage.CGImage];
        }
        
        transformedCIImage = [transformedCIImage imageByApplyingTransform:self.transform];
        backgroundImage = [UIImage imageWithCIImage:transformedCIImage];
    }

    [self updateBackgroundConstraints];
    
    if ([self isFullScreen])
    {
        self.backgroundImageView.image = backgroundImage;
        self.backgroundImageView.backgroundColor = backgroundColor;
        
        self.contentView.layer.cornerRadius = 0.0f;
        self.contentView.layer.masksToBounds = NO;
        self.contentView.image = [UIImage emptyImage];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    else
    {
        self.backgroundImageView.image = [UIImage emptyImage];
        self.backgroundImageView.backgroundColor = self.backgroundFadeColor;//[UIColor colorWithWhite:0.0f alpha:0.35f];
        
        self.contentView.layer.cornerRadius = (self.message) ? BFRadialWaveHUD_ContentViewCornerRadius : BFRadialWaveHUD_ContentViewWithoutStatusCornerRadius;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.contentMode = UIViewContentModeCenter;
        self.contentView.backgroundColor = self.HUDColor;
        
        self.contentView.image = backgroundImage;
    }
}

- (void)updateBackgroundConstraints
{
    if (!self.isFullScreen && self.message.length == 0) {
        self.radialViewToContentViewTopVerticalConstraint.constant = BFRadialWaveHUD_ContentViewWithoutStatusInset;
        self.messageLabelToContentViewBottomVerticalConstraint.constant = BFRadialWaveHUD_ContentViewWithoutStatusInset;
        
        // We sets the width as the height to have a square
        CGSize fittingSize = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        self.contentViewWidthConstraint.constant = fittingSize.height;
    }
}

- (void)updateCircleColor:(UIColor *)color
{
    [self.radialWaveView updateCircleColor:color];
}


#pragma mark Pause and Resume
- (void)pause
{
    [self.radialWaveView pauseAnimation];
}

- (void)resume
{
    [self.radialWaveView resumeAnimation];
}


#pragma mark Fun
- (void)disco:(BOOL)on
{
    self.atTheDisco = on;
    [self.radialWaveView disco:on];
}


#pragma mark - Other
- (void)appear
{
    if (self.isShowing) {
        [UIView animateWithDuration:BFRadialWaveHUD_LayoutAnimationDuration
                         animations:^{
                             [self setupUI];
                         }];
    }
    else {
//        [self updateBackgroundImage];
        [self setupUI];
        [self.container addSubview:self];
        _isShowing = YES;
        [UIView animateWithDuration:0.3f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.alpha = 1;
                         } completion:^(BOOL finished) {
                             // nothing for now
                         }];
    }
}


- (void)disappearWithCompletion:(void (^)(BOOL finished))completionBlock
{
    if (!self.isShowing) { return; }
    
    _isShowing = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.3f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [self removeFromSuperview];
                             if (nil != completionBlock) {
                                 completionBlock(finished);
                             }
                         }
                     }];
}


#pragma mark - Helpers
- (UIImage *)blurredScreenShot
{
    return [self blurredScreenShotWithRect:[UIApplication sharedApplication].keyWindow.frame];
}

- (UIImage *)blurredScreenShotWithRect:(CGRect)rect
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    [keyWindow drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    UIImage *blurredScreenShot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    blurredScreenShot = [self applyTintEffectWithColor:self.HUDColor
                                                 image:blurredScreenShot];
    
    return blurredScreenShot;
}

- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor
                                image:(UIImage *)image
{
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    int componentCount = (int)CGColorGetNumberOfComponents(tintColor.CGColor);
    CGFloat tintAlpha = CGColorGetAlpha(tintColor.CGColor);
    
    if (tintAlpha == 0.0f) {
        return [image applyBlurWithRadius:10.0f
                                tintColor:nil
                    saturationDeltaFactor:1.0f
                                maskImage:nil];
    }
    
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    }
    else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    
    return [image applyBlurWithRadius:10.0f
                            tintColor:effectColor
                saturationDeltaFactor:1.0f
                            maskImage:nil];
}

- (UIImage *)cropImage:(UIImage *)image
                  rect:(CGRect)cropRect
{
    // Create bitmap image from original image data,
    // using rectangle to specify desired crop area
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return image;
}

- (CGRect)correctedBounds
{
    return [self correctedBoundsForBounds:self.bounds];
}

- (CGRect)correctedBoundsForBounds:(CGRect)boundsToCorrect
{
    CGRect bounds = (CGRect){CGPointZero, boundsToCorrect.size};
    
    if (!BFSystemVersionGreaterOrEqual_iOS_8 && [self.superview isKindOfClass:UIWindow.class])
    {
        // landscape orientation but width is smaller than height
        // or portrait orientation but width is larger than height
        if ((UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
             && CGRectGetWidth(bounds) < CGRectGetHeight(bounds))
            || (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)
                && CGRectGetWidth(bounds) > CGRectGetHeight(bounds))) {
                bounds = (CGRect){CGPointZero, {bounds.size.height, bounds.size.width}};
            }
    }
    return bounds;
}

- (UIInterpolatingMotionEffect *)motionEffectWithType:(UIInterpolatingMotionEffectType)motionEffectType
                                              keyPath:(NSString *)keypath
{
    UIInterpolatingMotionEffect *motionEffect = [[UIInterpolatingMotionEffect alloc]
                                                 initWithKeyPath:keypath
                                                 type:motionEffectType];
    motionEffect.minimumRelativeValue = @(-BFRadialWaveHUD_MotionEffectRelativeValue);
    motionEffect.maximumRelativeValue = @(BFRadialWaveHUD_MotionEffectRelativeValue);
    
    return motionEffect;
}

- (CGFloat)rotationForStatusBarOrientation {
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return -M_PI_2;
        case UIInterfaceOrientationLandscapeRight:
            return M_PI_2;
        case UIInterfaceOrientationPortraitUpsideDown:
            return M_PI;
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationUnknown:
            return 0;
    }
}

static void dispatch_main_after(NSTimeInterval delay, void (^block)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}


#pragma mark - BFRadialWaveView Delegate
- (void)successfulCompletionWithRadialWaveView:(BFRadialWaveView *)sender
{
    if (nil != self.completionBlock) {
        self.completionBlock(YES);
    }
}

- (void)errorCompletionWithRadialWaveView:(BFRadialWaveView *)sender
{
    if (nil != self.completionBlock) {
        self.completionBlock(YES);
    }
}
@end
