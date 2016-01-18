BFRadialWaveHUD
=============
[![CocoaPods](https://img.shields.io/cocoapods/v/BFRadialWaveHUD.svg?style=flat)](https://github.com/bfeher/BFRadialWaveHUD)

> A progress HUD using [BFRadialWaveView](https://github.com/bfeher/BFRadialWaveView).
> Huge thanks to github user [@kevin-hirsch](https://github.com/kevin-hirsch) for making his amazing [KVNProgress](https://github.com/kevin-hirsch/KVNProgress) HUD available under the MIT license! Most of the actual HUD code, as well as ALL of the image processing code is from that project. Thanks again! 
<br />

>_Click the screenshot below for an animated gifv!_<br />
[![Animated Screenshot](https://raw.githubusercontent.com/bfeher/BFRadialWaveHUD/master/BFRadialWaveHUDDemoFrame1.png)](http://i.imgur.com/0A3E1aQ.gifv)




About
---------
_BFRadialWaveHUD_ is a fully customizable progress HUD that supports fullscreen, background blurring, dynaically changing message text, and disco time.
The purpose of _BFRadialWaveViewHUD_ is to mesmerize and hypnotize your users into forgetting that they were waiting for something to load. Seriously, just stare at it for a while. Also to give glory to the hypnotoad. <br />
_BFRadialWaveHUD_ uses [BFRadialWaveView](https://github.com/bfeher/BFRadialWaveView).


Changes
---------
Please refer to this [CHANGELOG.md](https://github.com/bfeher/BFRadialWaveHUD/blob/master/CHANGELOG.md).


To do:
---------
+ ~~Restart animations on app wake-up. (Note, this is something to fix for [BFRadialWaveView](https://github.com/bfeher/BFRadialWaveView))~~
+ ~~Move resources into a resource directory, reflecting this change in the cocoapod. (Fix file structure)~~


Modes
---------
```objective-c
BFRadialWaveHUDMode_Default       // Default: A swirly looking thing.
BFRadialWaveHUDMode_KuneKune      // Kune Kune: A creepy feeler looking thing.
BFRadialWaveHUDMode_North         // North: Points upwards.
BFRadialWaveHUDMode_NorthEast     // North East: Points upwards to the right.
BFRadialWaveHUDMode_East          // East: Points right.
BFRadialWaveHUDMode_SouthEast     // South East: Points downwards to the right.
BFRadialWaveHUDMode_South         // South: Points down.
BFRadialWaveHUDMode_SouthWest     // South West: Points downwards to the left.
BFRadialWaveHUDMode_West          // West: Points left.
BFRadialWaveHUDMode_NorthWest     // North West: Points at Kanye.
```

Methods
---------
## Initializer
>Use this when you make a BFRadialWaveHUD in code.
```objective-c
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
```

### Loading
```objective-c
/**
 *  Show an indeterminate HUD.
 */
- (void)show;
```
```objective-c
/**
 *  Show an indeterminate HUD with a message.
 *
 *  @param message NSString message to display below the spinning BFRadialWaveView.
 */
- (void)showWithMessage:(NSString *)message;
```

### Progress
```objective-c
/**
 *  Show a BFRadialWaveHUD with an extra circle for progress.
 *
 *  @param progress CGFloat progress (range [0.f, 1.f]) to show.
 */
- (void)showProgress:(CGFloat)progress;
```
```objective-c
/**
 *  Show a BFRadialWaveHUD with an extra circle for progress with a message.
 *
 *  @param progress CGFloat progress (range [0.f, 1.f]) to show.
 *  @param message NSString message to display below the spinning BFRadialWaveView.
 */
- (void)showProgress:(CGFloat)progress
         withMessage:(NSString *)message;
```

### Success
```objective-c
/**
 *  Show a success checkmark, indicating success.
 */
- (void)showSuccess;
```
```objective-c
/**
 *  Show a success checkmark and run a block of code after it completes.
 *
 *  @param completionBlock A block of code to run on completion.
 */
- (void)showSuccessWithCompletion:(void (^)(BOOL finished))completionBlock;
```
```objective-c
/**
 *  Show a success checkmark with a message.
 *
 *  @param message NSString message to display below the spinning BFRadialWaveView.
 */
- (void)showSuccessWithMessage:(NSString *)message;
```
```objective-c
/**
 *  Show a success checkmark with a message and run a block of code after it completes.
 *
 *  @param message NSString message to display below the spinning BFRadialWaveView.
 *  @param completionBlock A block of code to run on completion.
 */
- (void)showSuccessWithMessage:(NSString *)message
                    completion:(void (^)(BOOL finished))completionBlock;
```

### Error
```objective-c
/**
 *  Show an error 'X', indicating failure/error.
 */
- (void)showError;
```
```objective-c
/**
 *  Show an error 'X' and run a block of code after it completes.
 *
 *  @param completionBlock A block of code to run on completion.
 */
- (void)showErrorWithCompletion:(void (^)(BOOL finished))completionBlock;
```
```objective-c
/**
 *  Show an error 'X' with a message.
 *
 *  @param message NSString message to display below the spinning BFRadialWaveView.
 */
- (void)showErrorWithMessage:(NSString *)message;
```
```objective-c
/**
 *  Show an error 'X' with a message and run a block of code after it completes.
 *
 *  @param message NSString message to display below the spinning BFRadialWaveView.
 *  @param completionBlock A block of code to run on completion.
 */
- (void)showErrorWithMessage:(NSString *)message
                  completion:(void (^)(BOOL finished))completionBlock;
```

### Dismiss
```objective-c
/**
 *  Dimiss a BFRadialWaveHUD.
 */
- (void)dismiss;
```
```objective-c
/**
 *  Dimiss a BFRadialWaveHUD and run a block of code after it completes.
 *
 *  @param completionBlock A block of code to run on completion.
 */
- (void)dismissWithCompletion:(void (^)(BOOL finished))completionBlock;
```
```objective-c
/**
 *  Dimiss a BFRadialWaveHUD after a delay has passed.
 *
 *  @param delayInSeconds CGFloat of seconds to delay before fading away.
 */
- (void)dismissAfterDelay:(CGFloat)delayInSeconds;
```
```objective-c
/**
 *  Dismiss a BFRadialWaveHUD after a delay has passed and run a block of code after it completes.
 *
 *  @param delayInSeconds CGFloat of seconds to delay before fading away.
 *  @param completionBlock A block of code to run on completion.
 */
- (void)dismissAfterDelay:(CGFloat)delayInSeconds
           withCompletion:(void (^)(BOOL finished))completionBlock;
```

### Update
```objective-c
/**
 *  Update the message written below the BFRadialWaveView spinner.
 *
 *  @param message NSString message to display.
 */
- (void)updateMessage:(NSString *)message;
```
```objective-c
/**
 *  Update the progress to display.
 *
 *  @param progress CGFloat progress (range [0.f, 1.f]) to display.
 */
- (void)updateProgress:(CGFloat)progress;
```

### Pause and Resume  
```objective-c
/** Pause the animation. */
- (void)pause;

/** Resume the animation. */
- (void)resume;
```

### Fun
```objective-c
/**
 *  Activate of Deactivate disco mode! This will rapidly cycle colors through your BFRadialWaveView. Without setting the colors explicitly, a rainbow is used.
 *
 *  @param on BOOL flag to turn disco mode on (YES) or off (NO).
 */
- (void)disco:(BOOL)on;
```



Properties
---------
### Message
```objective-c
/** UIFont for the message label below the BFRadialWaveView spinner. */
@property (nonatomic) UIFont *messageFont;
```
```objective-c
/** UIColor for the textColor of the message label below the BFRadialWaveView spinner. */
@property (nonatomic) UIColor *messageColor;
```

### HUD
```objective-c
/** UIColor for the HUD. This is also the color used when in fullscreen. Colors with high alpha values are recommended to help block out the content behind the HUD. */
@property (nonatomic) UIColor *HUDColor;
```
```objective-c
/** UIColor for the background of non-fullscreen HUDs. Colors with high alpha values are recommended to help block out the content behind the HUD. */
@property (nonatomic) UIColor *backgroundFadeColor;
```
```objective-c
/** The UIColor to set the progress circle to. Default is the same as the circleColor passed into the initializer or the setup. */
@property (nonatomic) UIColor *progressCircleColor;
```

### Success and Error
```objective-c
/** The color to set the success checkmark to. By default it is the same as the circleColor passed into the initializer or the setup. */
@property (nonatomic) UIColor *checkmarkColor;
```
```objective-c
/** The color to set the failure cross to. By default it is the same as the circleColor passed into the initializer or the setup. */
@property (nonatomic) UIColor *crossColor;
```

### Behavior
```objective-c
/** BOOL flag to set whether to dismiss on tap (YES) or ignore taps (NO). */
@property (nonatomic) BOOL tapToDismiss;
```
```objective-c
/** Block to run after dismissal via tap. */
@property (nonatomic, copy) void (^tapToDismissCompletionBlock)(BOOL finished);
```
```objective-c
/** A READONLY BOOL flag for your convenience. Returns YES when the HUD is showing, and NO when it is not. */
@property (readonly) BOOL isShowing;
```
```objective-c
/** BOOL flag to set whether to blur the background (YES) or not (NO). */
@property (nonatomic) BOOL blurBackground;
```

### Disco
```objective-c
/** An NSArray of colors to use for disco mode. By default it is the rainbow. */
@property (nonatomic) NSArray *discoColors;
```
```objective-c
/** CGFloat speed for the disco animation. Default is 0.33f. */
@property (nonatomic) CGFloat discoSpeed;
```


Usage
---------
>Be sure the check out the included demo app to see examples on how to use BFRadialWaveHUD.
Add the contents of the three directories, `Categories`, `Classes`, and `Resources` to your project either manually or via cocoapods.


### Working Example
```objective-c
// Create a HUD with default number of circles, default color, default mode, and default circle stroke width:
BFRadialWaveHUD *hud = [[BFRadialWaveHUD alloc] initWithView:self.view
                                                  fullScreen:NO
                                                     circles:BFRadialWaveHUD_DefaultNumberOfCircles
                                                 circleColor:nil
                                                        mode:BFRadialWaveHUDMode_Default
                                                 strokeWidth:BFRadialWaveHUD_DefaultCircleStrokeWidth];
[hud show];
```

### Customized Example
```objective-c
// Create a HUD with default number of circles, default color, default mode, and default circle stroke width:
BFRadialWaveHUD *hud = [[BFRadialWaveHUD alloc] initWithView:self.view
                                                  fullScreen:YES
                                                     circles:10
                                                 circleColor:[UIColor whiteColor]
                                                        mode:BFRadialWaveHUDMode_South
                                                 strokeWidth:4.f];
hud.blurBackground = YES; // default is NO
hud.tapToDismiss = YES; // default is NO
hud.progressCircleColor = [UIColor paperColorLightBlue];
hud.checkmarkColor = [UIColor paperColorGreen];
hud.crossColor = [UIColor paperColorRed];
hud.HUDColor = [UIColor colorWithWhite:1.f alpha:0.85f];
hud.backgroundFadeColor = [UIColor colorWithWhite:0.13f alpha:0.6f];
NSArray *discoColors = @[[UIColor paperColorIndigoA100],
                             [UIColor paperColorIndigoA200],
                             [UIColor paperColorIndigoA400],
                             [UIColor paperColorIndigoA700]];
[hud setDiscoColors:discoColors];
[hud showProgress:0.f withMessage:@"Downloading..."];
```

Cocoapods
-------

CocoaPods are the best way to manage library dependencies in Objective-C projects.
Learn more at http://cocoapods.org

Add this to your podfile to add BFRadialWaveHUD to your project.
```ruby
platform :ios, '7.1'
pod 'BFRadialWaveHUD', '~> 1.5.4'
```


License
--------
_BFRadialWaveHUD_ uses the MIT License:

> Please see included [LICENSE file](https://raw.githubusercontent.com/bfeher/BFRadialWaveHUD/master/LICENSE.md).
