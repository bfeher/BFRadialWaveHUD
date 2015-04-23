//
//  BFRadialWaveHUD.h
//  BFRadialWaveHUD
//
//  Created by Bence Feher on 2/10/15.
//  Copyright (c) 2015 Bence Feher. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, BFRadialWaveHUDMode) {
    BFRadialWaveHUDMode_Default,    // Default: A swirly looking thing.
    BFRadialWaveHUDMode_KuneKune,   // Kune Kune: A creepy feeler looking thing.
    BFRadialWaveHUDMode_North,      // North: Points upwards.
    BFRadialWaveHUDMode_NorthEast,  // North East: Points upwards to the right.
    BFRadialWaveHUDMode_East,       // East: Points right.
    BFRadialWaveHUDMode_SouthEast,  // South East: Points downwards to the right.
    BFRadialWaveHUDMode_South,      // South: Points down.
    BFRadialWaveHUDMode_SouthWest,  // South West: Points downwards to the left.
    BFRadialWaveHUDMode_West,       // West: Points left.
    BFRadialWaveHUDMode_NorthWest,  // North West: Points at Kanye.
};

extern NSInteger const BFRadialWaveHUD_DefaultNumberOfCircles;
extern CGFloat const BFRadialWaveHUD_DefaultCircleStrokeWidth;
extern CGFloat const BFRadialWaveHUD_CircleProgressViewToStatusLabelVerticalSpaceConstraintConstant;


@class BFRadialWaveView;

@interface BFRadialWaveHUD : UIView

#pragma mark - Initializers
/**
 *  Custom initializer. Use this when you make a BFRadialWaveHUD in code.
 *
 *  @param containerView   The UIView to place the HUD in.
 *  @param fullscreen      BOOL flag to display in fullscreen or not.
 *  @param numberOfCircles NSInteger number of circles. Min = 3, Max = 20.
 *  @param circleColor     UIColor to set the circles' strokeColor to.
 *  @param mode            BFRadialWaveHUDMode
 *  @param strokeWidth     CGFloat stroke width of the circles.
 *
 *  @return Returns a BFRadialWaveHUD! Aww yiss!
 */
- (instancetype)initWithView:(UIView *)containerView
                  fullScreen:(BOOL)fullscreen
                     circles:(NSInteger)numberOfCircles
                 circleColor:(UIColor *)circleColor
                        mode:(BFRadialWaveHUDMode)mode
                 strokeWidth:(CGFloat)strokeWidth;


#pragma mark - Loading
/**
 *  Show an indeterminate HUD.
 */
- (void)show;

/**
 *  Show an indeterminate HUD with a message.
 *
 *  @param message NSString message to display below the spinning BFRadialWaveView.
 */
- (void)showWithMessage:(NSString *)message;


#pragma mark - Progress
/**
 *  Show a BFRadialWaveHUD with an extra circle for progress.
 *
 *  @param progress CGFloat progress (range [0.f, 1.f]) to show.
 */
- (void)showProgress:(CGFloat)progress;

/**
 *  Show a BFRadialWaveHUD with an extra circle for progress with a message.
 *
 *  @param progress CGFloat progress (range [0.f, 1.f]) to show.
 *  @param message NSString message to display below the spinning BFRadialWaveView.
 */
- (void)showProgress:(CGFloat)progress
         withMessage:(NSString *)message;


#pragma mark - Success
/**
 *  Show a success checkmark, indicating success.
 */
- (void)showSuccess;

/**
 *  Show a success checkmark and run a block of code after it completes.
 *
 *  @param completionBlock A block of code to run on completion.
 */
- (void)showSuccessWithCompletion:(void (^)(BOOL finished))completionBlock;

/**
 *  Show a success checkmark with a message.
 *
 *  @param message NSString message to display below the spinning BFRadialWaveView.
 */
- (void)showSuccessWithMessage:(NSString *)message;

/**
 *  Show a success checkmark with a message and run a block of code after it completes.
 *
 *  @param message NSString message to display below the spinning BFRadialWaveView.
 *  @param completionBlock A block of code to run on completion.
 */
- (void)showSuccessWithMessage:(NSString *)message
                    completion:(void (^)(BOOL finished))completionBlock;


#pragma mark - Error
/**
 *  Show an error 'X', indicating failure/error.
 */
- (void)showError;

/**
 *  Show an error 'X' and run a block of code after it completes.
 *
 *  @param completionBlock A block of code to run on completion.
 */
- (void)showErrorWithCompletion:(void (^)(BOOL finished))completionBlock;

/**
 *  Show an error 'X' with a message.
 *
 *  @param message NSString message to display below the spinning BFRadialWaveView.
 */
- (void)showErrorWithMessage:(NSString *)message;

/**
 *  Show an error 'X' with a message and run a block of code after it completes.
 *
 *  @param message NSString message to display below the spinning BFRadialWaveView.
 *  @param completionBlock A block of code to run on completion.
 */
- (void)showErrorWithMessage:(NSString *)message
                  completion:(void (^)(BOOL finished))completionBlock;


#pragma mark - Dismiss
/**
 *  Dimiss a BFRadialWaveHUD.
 */
- (void)dismiss;

/**
 *  Dimiss a BFRadialWaveHUD and run a block of code after it completes.
 *
 *  @param completionBlock A block of code to run on completion.
 */
- (void)dismissWithCompletion:(void (^)(BOOL finished))completionBlock;

/**
 *  Dimiss a BFRadialWaveHUD after a delay has passed.
 *
 *  @param delayInSeconds CGFloat of seconds to delay before fading away.
 */
- (void)dismissAfterDelay:(CGFloat)delayInSeconds;

/**
 *  Dismiss a BFRadialWaveHUD after a delay has passed and run a block of code after it completes.
 *
 *  @param delayInSeconds CGFloat of seconds to delay before fading away.
 *  @param completionBlock A block of code to run on completion.
 */
- (void)dismissAfterDelay:(CGFloat)delayInSeconds
           withCompletion:(void (^)(BOOL finished))completionBlock;


#pragma mark - Update
/**
 *  Update the message written below the BFRadialWaveView spinner.
 *
 *  @param message NSString message to display.
 */
- (void)updateMessage:(NSString *)message;

/**
 *  Update the progress to display.
 *
 *  @param progress CGFloat progress (range [0.f, 1.f]) to display.
 */
- (void)updateProgress:(CGFloat)progress;

/**
 *  Update the color of all of the circles.
 *
 *  @param color UIColor to set the circles' strokeColor to.
 */
- (void)updateCircleColor:(UIColor *)color;


#pragma mark - Pause and Resume
/** 
 * Pause the animation. 
 */
- (void)pause;

/** 
 * Resume the animation. 
 */
- (void)resume;


#pragma mark - Fun
/**
 *  Activate of Deactivate disco mode! This will rapidly cycle colors through your BFRadialWaveView. Without setting the colors explicitly, a rainbow is used.
 *
 *  @param on BOOL flag to turn disco mode on (YES) or off (NO).
 */
- (void)disco:(BOOL)on;


#pragma mark - Properties
#pragma Message
/** UIFont for the message label below the BFRadialWaveView spinner. */
@property (nonatomic) UIFont *messageFont;

/** UIColor for the textColor of the message label below the BFRadialWaveView spinner. */
@property (nonatomic) UIColor *messageColor;

#pragma mark HUD
/** UIColor for the HUD. This is also the color used when in fullscreen. Colors with high alpha values are recommended to help block out the content behind the HUD. */
@property (nonatomic) UIColor *HUDColor;

/** UIColor for the background of non-fullscreen HUDs. Colors with high alpha values are recommended to help block out the content behind the HUD. */
@property (nonatomic) UIColor *backgroundFadeColor;

/** The UIColor to set the progress circle to. Default is the same as the circleColor passed into the initializer or the setup. */
@property (nonatomic) UIColor *progressCircleColor;

#pragma mark Success and Error
/** The color to set the success checkmark to. By default it is the same as the circleColor passed into the initializer or the setup. */
@property (nonatomic) UIColor *checkmarkColor;

/** The color to set the failure cross to. By default it is the same as the circleColor passed into the initializer or the setup. */
@property (nonatomic) UIColor *crossColor;

#pragma mark Behavior
/** BOOL flag to set whether to dismiss on tap (YES) or ignore taps (NO). */
@property (nonatomic) BOOL tapToDismiss;

/** Block to run after dismissal via tap. */
@property (nonatomic, copy) void (^tapToDismissCompletionBlock)(BOOL finished);

/** A READONLY BOOL flag for your convenience. Returns YES when the HUD is showing, and NO when it is not. */
@property (readonly) BOOL isShowing;

/** BOOL flag to set whether to blur the background (YES) or not (NO). */
@property (nonatomic) BOOL blurBackground;

#pragma mark Disco
/** An NSArray of colors to use for disco mode. By default it is the rainbow. */
@property (nonatomic) NSArray *discoColors;

/** CGFloat speed for the disco animation. Default is 0.33f. */
@property (nonatomic) CGFloat discoSpeed;

@end
