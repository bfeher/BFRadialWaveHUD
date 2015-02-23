//
//  ViewController.m
//  BFRadialWaveHUD
//
//  Created by Bence Feher on 2/10/15.
//  Copyright (c) 2015 Bence Feher. All rights reserved.
//

#import "ViewController.h"
// Classes:
#import "BFRadialWaveHUD.h"
// Pods:
#import "UIColor+BFPaperColors.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *blurSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *fullScreenSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *discoSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSegmentedControl;
@property NSInteger numberOfCircles;
@property CGFloat circleStrokeWidth;
@property BOOL successFailSwitch;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.numberOfCircles = BFRadialWaveHUD_DefaultNumberOfCircles;
    self.circleStrokeWidth = BFRadialWaveHUD_DefaultCircleStrokeWidth;
    
    [self.modeSegmentedControl setTitle:@"D" forSegmentAtIndex:0];
    [self.modeSegmentedControl setTitle:@"K" forSegmentAtIndex:1];
    [self.modeSegmentedControl setTitle:@"↑\U0000FE0E" forSegmentAtIndex:2];
    [self.modeSegmentedControl setTitle:@"↗\U0000FE0E" forSegmentAtIndex:3];
    [self.modeSegmentedControl setTitle:@"→\U0000FE0E" forSegmentAtIndex:4];
    [self.modeSegmentedControl setTitle:@"↘\U0000FE0E" forSegmentAtIndex:5];
    [self.modeSegmentedControl setTitle:@"↓\U0000FE0E" forSegmentAtIndex:6];
    [self.modeSegmentedControl setTitle:@"↙\U0000FE0E" forSegmentAtIndex:7];
    [self.modeSegmentedControl setTitle:@"←\U0000FE0E" forSegmentAtIndex:8];
    [self.modeSegmentedControl setTitle:@"↖\U0000FE0E" forSegmentAtIndex:9];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Action Handlers
- (IBAction)showBasic:(UIButton *)sender
{
    BFRadialWaveHUD *hud = [[BFRadialWaveHUD alloc] initWithView:self.view
                                                      fullScreen:self.fullScreenSwitch.isOn
                                                         circles:self.numberOfCircles
                                                     circleColor:nil
                                                            mode:(BFRadialWaveHUDMode)self.modeSegmentedControl.selectedSegmentIndex
                                                     strokeWidth:self.circleStrokeWidth];
    [hud setBlurBackground:self.blurSwitch.isOn];
    hud.tapToDismiss = YES;
    [hud show];
    [hud disco:self.discoSwitch.isOn];
}

- (IBAction)showBasicWithStatus:(UIButton *)sender
{
    BFRadialWaveHUD *hud = [[BFRadialWaveHUD alloc] initWithView:self.view
                                                      fullScreen:self.fullScreenSwitch.isOn
                                                         circles:self.numberOfCircles
                                                     circleColor:nil
                                                            mode:(BFRadialWaveHUDMode)self.modeSegmentedControl.selectedSegmentIndex
                                                     strokeWidth:self.circleStrokeWidth];
    [hud setBlurBackground:self.blurSwitch.isOn];
    hud.tapToDismiss = YES;
    [hud showWithMessage:@"Loading..."];
    [hud disco:self.discoSwitch.isOn];
}

- (IBAction)showProgressAndStatus:(UIButton *)sender
{
    self.successFailSwitch = !self.successFailSwitch;
    BFRadialWaveHUD *hud = [[BFRadialWaveHUD alloc] initWithView:self.view
                                                      fullScreen:self.fullScreenSwitch.isOn
                                                         circles:self.numberOfCircles
                                                     circleColor:nil
                                                            mode:(BFRadialWaveHUDMode)self.modeSegmentedControl.selectedSegmentIndex
                                                     strokeWidth:self.circleStrokeWidth];
    [hud setBlurBackground:self.blurSwitch.isOn];
    [hud showProgress:0.f withMessage:@"Loading with progress..."];
    [hud disco:self.discoSwitch.isOn];
    [self updateProgressForHUD:hud];
    
    dispatch_main_after(2.7f, ^{
        [hud updateMessage:[NSString stringWithFormat:@"Loading with progress...\nEnding will show %@", self.successFailSwitch ? @"SUCCESS" : @"FAILURE"]];
    });
    dispatch_main_after(5.5f, ^{
        if (self.successFailSwitch) {
            [hud showSuccessWithMessage:@"Success!" completion:^(BOOL finished) {
                NSLog(@"success handler...");
                [hud dismissAfterDelay:0.6f];
            }];
        }
        else {
            [hud showErrorWithMessage:@"Error!" completion:^(BOOL finished) {
                NSLog(@"Error handler...");
                [hud dismissAfterDelay:0.6f];
            }];
        }
    });

}

- (IBAction)showSuccessAndStatus:(UIButton *)sender
{
    BFRadialWaveHUD *hud = [[BFRadialWaveHUD alloc] initWithView:self.view
                                                      fullScreen:self.fullScreenSwitch.isOn
                                                         circles:self.numberOfCircles
                                                     circleColor:nil
                                                            mode:(BFRadialWaveHUDMode)self.modeSegmentedControl.selectedSegmentIndex
                                                     strokeWidth:self.circleStrokeWidth];
    [hud setBlurBackground:self.blurSwitch.isOn];
    [hud showSuccessWithMessage:@"Success!" completion:^(BOOL finished) {
        NSLog(@"success handler...");
        [hud dismissAfterDelay:1.f];
    }];
}

- (IBAction)showErrorAndStatus:(UIButton *)sender
{
    BFRadialWaveHUD *hud = [[BFRadialWaveHUD alloc] initWithView:self.view
                                                      fullScreen:self.fullScreenSwitch.isOn
                                                         circles:self.numberOfCircles
                                                     circleColor:nil
                                                            mode:(BFRadialWaveHUDMode)self.modeSegmentedControl.selectedSegmentIndex
                                                     strokeWidth:self.circleStrokeWidth];
    [hud setBlurBackground:self.blurSwitch.isOn];
    [hud showErrorWithMessage:@"Error!" completion:^(BOOL finished) {
        NSLog(@"error handler...");
        [hud dismissAfterDelay:0.6f];
    }];
}

- (IBAction)showCustom:(UIButton *)sender
{
    self.successFailSwitch = !self.successFailSwitch;
    
    BFRadialWaveHUD *hud = [[BFRadialWaveHUD alloc] initWithView:self.view
                                                      fullScreen:self.fullScreenSwitch.isOn
                                                         circles:20
                                                     circleColor:[UIColor paperColorGray800]
                                                            mode:(BFRadialWaveHUDMode)self.modeSegmentedControl.selectedSegmentIndex
                                                     strokeWidth:4];
    hud.messageColor = [UIColor paperColorDeepPurpleA200];
    hud.HUDColor = [UIColor colorWithWhite:1.f alpha:0.85f];
    hud.backgroundFadeColor = [UIColor colorWithWhite:0.13f alpha:0.6f];
    [hud setBlurBackground:self.blurSwitch.isOn];
    hud.tapToDismiss = YES;
    [hud showProgress:0.f withMessage:@"Try me in other modes too!\n(and check out my custom disco)"];
    hud.progressCircleColor = [UIColor paperColorLightGreen100];
    [self updateProgressForCustomHUD:hud];
    
    NSArray *discoColors = @[[UIColor paperColorIndigoA100],
                             [UIColor paperColorIndigoA200],
                             [UIColor paperColorIndigoA400],
                             [UIColor paperColorIndigoA700]];
    [hud setDiscoColors:discoColors];
    [hud disco:self.discoSwitch.isOn];
    
    dispatch_main_after(5.5f, ^{
        if (self.successFailSwitch) {
            hud.progressCircleColor = [UIColor paperColorLightBlue];
            hud.checkmarkColor = [UIColor paperColorLightBlueA200];
            [hud showSuccessWithMessage:@"Success!" completion:^(BOOL finished) {
                NSLog(@"success handler...");
                [hud dismissAfterDelay:0.6f];
            }];
        }
        else {
            hud.progressCircleColor = [UIColor paperColorRed];
            hud.crossColor = [UIColor paperColorRedA200];
            [hud showErrorWithMessage:@"Error!" completion:^(BOOL finished) {
                NSLog(@"Error handler...");
                [hud dismissAfterDelay:0.6f];
            }];
        }
    });
}


#pragma mark - Helpers
- (void)updateProgressForHUD:(BFRadialWaveHUD *)hud
{
    dispatch_main_after(2.0f, ^{
        [hud updateProgress:0.3f];
    });
    dispatch_main_after(2.5f, ^{
        [hud updateProgress:0.5f];
    });
    dispatch_main_after(2.8f, ^{
        [hud updateProgress:0.6f];
    });
    dispatch_main_after(3.7f, ^{
        [hud updateProgress:0.93f];
    });
    dispatch_main_after(5.0f, ^{
        [hud updateProgress:0.96f];
    });
}

- (void)updateProgressForCustomHUD:(BFRadialWaveHUD *)hud
{
    dispatch_main_after(2.0f, ^{
        [hud updateProgress:0.3f];
    });
    dispatch_main_after(2.5f, ^{
        [hud updateProgress:0.5f];
        hud.progressCircleColor = [UIColor paperColorLightGreen300];
    });
    dispatch_main_after(2.8f, ^{
        [hud updateProgress:0.6f];
        hud.progressCircleColor = [UIColor paperColorLightGreen600];
    });
    dispatch_main_after(3.7f, ^{
        [hud updateProgress:0.93f];
        hud.progressCircleColor = [UIColor paperColorLightGreen900];
    });
    dispatch_main_after(5.0f, ^{
        [hud updateProgress:0.96f];
    });
}

static void dispatch_main_after(NSTimeInterval delay, void (^block)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}


@end
