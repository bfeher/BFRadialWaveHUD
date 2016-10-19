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
    hud.tapToDismissCompletionBlock = ^void(BOOL finished) {
        NSLog(@"running tapToDismissCompletionBlock...");
        if (finished) {
            NSLog(@"...finished running tapToDismissCompletionBlock.");
        }
    };
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
    hud.tapToDismissCompletionBlock = ^void(BOOL finished) {
        NSLog(@"running tapToDismissCompletionBlock...");
        if (finished) {
            NSLog(@"...finished running tapToDismissCompletionBlock.");
        }
    };
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
                                                     circleColor:[UIColor colorWithRed:66.f/255.f green:66.f/255.f blue:66.f/255.f alpha:1]
                                                            mode:(BFRadialWaveHUDMode)self.modeSegmentedControl.selectedSegmentIndex
                                                     strokeWidth:4];
    hud.messageColor = [UIColor colorWithRed:124.f/255.f green:77.f/255.f blue:1 alpha:1];
    hud.HUDColor = [UIColor colorWithWhite:1.f alpha:0.85f];
    hud.backgroundFadeColor = [UIColor colorWithWhite:0.13f alpha:0.6f];
    [hud setBlurBackground:self.blurSwitch.isOn];
    [hud showProgress:0.f withMessage:@"Try me in other modes too!\n(and check out my custom disco)"];
    hud.progressCircleColor = [UIColor colorWithRed:220.f/255.f green:237.f/255.f blue:200.f/255.f alpha:1];
    [self updateProgressForCustomHUD:hud];
    
    NSArray *discoColors = @[[UIColor colorWithRed:140.f/255.f green:158.f/255.f blue:1 alpha:1],
                             [UIColor colorWithRed:83.f/255.f green:109.f/255.f blue:254.f/255.f alpha:1],
                             [UIColor colorWithRed:61.f/255.f green:90.f/255.f blue:254.f/255.f alpha:1],
                             [UIColor colorWithRed:48.f/255.f green:79.f/255.f blue:254.f/255.f alpha:1]];
    [hud setDiscoColors:discoColors];
    [hud disco:self.discoSwitch.isOn];
    
    dispatch_main_after(5.5f, ^{
        if (self.successFailSwitch) {
            hud.progressCircleColor = [UIColor colorWithRed:3.f/255.f green:169.f/255.f blue:244.f/255.f alpha:1];
            hud.checkmarkColor = [UIColor colorWithRed:64.f/255.f green:196.f/255.f blue:1 alpha:1];
            [hud showSuccessWithMessage:@"Success!" completion:^(BOOL finished) {
                NSLog(@"success handler...");
                [hud dismissAfterDelay:0.6f];
            }];
        }
        else {
            hud.progressCircleColor = [UIColor colorWithRed:244.f/255.f green:67.f/255.f blue:54.f/255.f alpha:1];
            hud.crossColor = [UIColor colorWithRed:1 green:82.f/255.f blue:82.f/255.f alpha:1];
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
        hud.progressCircleColor = [UIColor colorWithRed:174.f/255.f green:213.f/255.f blue:129.f/255.f alpha:1];
    });
    dispatch_main_after(2.8f, ^{
        [hud updateProgress:0.6f];
        hud.progressCircleColor = [UIColor colorWithRed:124.f/255.f green:179.f/255.f blue:66.f/255.f alpha:1];
    });
    dispatch_main_after(3.7f, ^{
        [hud updateProgress:0.93f];
        hud.progressCircleColor = [UIColor colorWithRed:51.f/255.f green:105.f/255.f blue:30.f/255.f alpha:1];
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
