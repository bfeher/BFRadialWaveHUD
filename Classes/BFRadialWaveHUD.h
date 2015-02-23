//
//  BFRadialWaveHUD.h
//  BFRadialWaveHUD
//
//  Created by Bence Feher on 2/10/15.
//  Copyright (c) 2015 Bence Feher. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, BFRadialWaveHUDMode) {
    BFRadialWaveHUDMode_Default,
    BFRadialWaveHUDMode_KuneKune,
    BFRadialWaveHUDMode_North,
    BFRadialWaveHUDMode_NorthEast,
    BFRadialWaveHUDMode_East,
    BFRadialWaveHUDMode_SouthEast,
    BFRadialWaveHUDMode_South,
    BFRadialWaveHUDMode_SouthWest,
    BFRadialWaveHUDMode_West,
    BFRadialWaveHUDMode_NorthWest,
};

extern NSInteger const BFRadialWaveHUD_DefaultNumberOfCircles;
extern CGFloat const BFRadialWaveHUD_DefaultCircleStrokeWidth;
extern CGFloat const BFRadialWaveHUD_CircleProgressViewToStatusLabelVerticalSpaceConstraintConstant;


@class BFRadialWaveView;

@interface BFRadialWaveHUD : UIView

#pragma mark - Initializers
- (instancetype)initWithView:(UIView *)containerView
                  fullScreen:(BOOL)fullscreen
                     circles:(NSInteger)numberOfCircles
                 circleColor:(UIColor *)circleColor
                        mode:(BFRadialWaveHUDMode)mode
                 strokeWidth:(CGFloat)strokeWidth;


#pragma mark - Loading
- (void)show;

- (void)showWithMessage:(NSString *)message;


#pragma mark - Progress
- (void)showProgress:(CGFloat)progress;

- (void)showProgress:(CGFloat)progress
         withMessage:(NSString *)message;


#pragma mark - Success
- (void)showSuccess;

- (void)showSuccessWithCompletion:(void (^)(BOOL finished))completionBlock;

- (void)showSuccessWithMessage:(NSString *)message;

- (void)showSuccessWithMessage:(NSString *)message
                    completion:(void (^)(BOOL finished))completionBlock;


#pragma mark - Error
- (void)showError;

- (void)showErrorWithCompletion:(void (^)(BOOL finished))completionBlock;

- (void)showErrorWithMessage:(NSString *)message;

- (void)showErrorWithMessage:(NSString *)message
                  completion:(void (^)(BOOL finished))completionBlock;


#pragma mark - Dismiss
- (void)dismiss;

- (void)dismissWithCompletion:(void (^)(BOOL finished))completionBlock;

- (void)dismissAfterDelay:(CGFloat)delayInSeconds;

- (void)dismissAfterDelay:(CGFloat)delayInSeconds
           withCompletion:(void (^)(BOOL finished))completionBlock;


#pragma mark - Update
- (void)updateMessage:(NSString *)message;

- (void)updateProgress:(CGFloat)progress;

- (void)updateCircleColor:(UIColor *)color;

- (void)updateProgressCircleColor:(UIColor *)color;


#pragma mark - Fun
- (void)disco:(BOOL)on;


#pragma mark - Properties
#pragma Message
@property (nonatomic) UIFont *messageFont;
@property (nonatomic) UIColor *messageColor;

#pragma mark HUD
@property (nonatomic) UIColor *HUDColor;
@property (nonatomic) UIColor *backgroundFadeColor;

#pragma mark Success and Error
@property UIColor *checkmarkColor;
@property UIColor *crossColor;

#pragma mark Behavior
@property (nonatomic) BOOL tapToDismiss;
@property (readonly) BOOL isShowing;
@property (nonatomic) BOOL blurBackground;

#pragma mark Disco
@property (nonatomic) NSArray *discoColors;
@property (nonatomic) CGFloat discoSpeed;

@end
