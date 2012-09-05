//
//  ViewController.m
//  DisneyInterview
//
//  Created by Clifford Sharp on 9/5/12.
//  Copyright (c) 2012 Clifford Sharp. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kAccelFrequency  5.0 //Hz
#define kFilteringFactor 0.1

#define kBorderRadius   7.0f;
#define kBorderWidth    3.0f

@interface ViewController ()
@property (nonatomic, strong) UIColor *landingColor;
@property (nonatomic, strong) UIColor *transitionColor;
@property (nonatomic, strong) UIAccelerometer *accel;
@property BOOL isTransitioning;
//
- (void)startAccelerometer;
- (void)stopAccelerometer;
- (void)transitionBackgroundColorAnimation:(float)duration;
- (void)showLandingLabels;
- (void)hideLandingLabels;
@end

@implementation ViewController

@synthesize greetingLbl = m_greetingLbl;
@synthesize directionLbl = m_directionLbl;
@synthesize whichOneLbl = m_whichOneLbl;
// private
@synthesize landingColor = m_landingColor;
@synthesize transitionColor = m_transitionColor;
@synthesize accel = m_accel;
@synthesize isTransitioning;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.greetingLbl.text = @"RattleIt\nby Cliff Sharp\nfor Disney Interview";
    self.greetingLbl.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    self.greetingLbl.layer.borderColor = [[UIColor blackColor] CGColor];
    self.greetingLbl.layer.borderWidth = kBorderWidth;
    self.greetingLbl.layer.cornerRadius = kBorderRadius;
    
    self.directionLbl.layer.borderColor = [[UIColor blackColor] CGColor];
    self.directionLbl.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    self.directionLbl.layer.borderWidth = kBorderWidth;
    self.directionLbl.layer.cornerRadius = kBorderRadius;
    
    self.whichOneLbl.text = @"";
    self.whichOneLbl.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    self.whichOneLbl.layer.borderColor = [[UIColor blackColor] CGColor];
    self.whichOneLbl.layer.borderWidth = kBorderWidth;
    self.whichOneLbl.layer.cornerRadius = kBorderRadius;
    self.whichOneLbl.hidden = YES;
    
    self.landingColor = [UIColor blueColor];
    self.transitionColor = [UIColor greenColor];
    
    isTransitioning = NO;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
	[self becomeFirstResponder];
    [self startAccelerometer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self resignFirstResponder];
    [self stopAccelerometer];
}

#pragma mark - Responder for Shake

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - Acclerometer Methods

UIAccelerationValue rollingX, rollingY, rollingZ;

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    // Subtract the low-pass value from the current value to get a simplified high-pass filter
    rollingX = (acceleration.x * kFilteringFactor) + (rollingX * (1.0 - kFilteringFactor));
    rollingY = (acceleration.y * kFilteringFactor) + (rollingY * (1.0 - kFilteringFactor));
    rollingZ = (acceleration.z * kFilteringFactor) + (rollingZ * (1.0 - kFilteringFactor));
    
    float accelX = acceleration.x - rollingX;
    float accelY = acceleration.y - rollingY;
    float accelZ = acceleration.z - rollingZ;
    
    if (!isTransitioning) {
        if ((accelX > 0.2f && accelX < 0.7f) || (accelX < -0.2f && accelX > -0.7f)) {
            isTransitioning = YES;
            [self hideLandingLabels];
            self.whichOneLbl.text = @"Soft...";
            [self transitionBackgroundColorAnimation:5.0f];
            
            // for testing
            NSLog(@"Soft Shake: x: %f  y: %f  z: %f", accelX, accelY, accelZ);
            
        } else if ((accelX > 0.8f && accelX < 1.5f) || (accelX < -0.8f && accelX > -1.5f)) {
            isTransitioning = YES;
            [self hideLandingLabels];
            self.whichOneLbl.text = @"Heavy...";
            [self transitionBackgroundColorAnimation:2.0f];
            
            // for testing
            NSLog(@"Heavy Shake: x: %f  y: %f  z: %f", accelX, accelY, accelZ);
        }
    }
}

- (void)startAccelerometer {
    self.accel = [UIAccelerometer sharedAccelerometer];
    self.accel.delegate = self;
    self.accel.updateInterval = 1.0 / kAccelFrequency;
}

- (void)stopAccelerometer {
    self.accel = [UIAccelerometer sharedAccelerometer];
    self.accel.delegate = nil;
}

#pragma mark - BackgroundColor Animation

- (void)transitionBackgroundColorAnimation:(float)duration {
    
    self.view.backgroundColor = self.landingColor;
    [UIView animateWithDuration:duration
                     animations:^{
                         self.view.backgroundColor = self.transitionColor;
                     }
                     completion:^(BOOL finished) {
                         [self showLandingLabels];
                         isTransitioning = NO;
                     }];
}

#pragma mark - Landing Labels

- (void)showLandingLabels {
    self.greetingLbl.hidden = NO;
    self.directionLbl.hidden = NO;
    self.whichOneLbl.hidden = YES;
}

- (void)hideLandingLabels {
    self.greetingLbl.hidden = YES;
    self.directionLbl.hidden = YES;
    self.whichOneLbl.hidden = NO;
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"ERROR - ViewController - low memory warning.");
}

@end
