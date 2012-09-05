//
//  ViewController.h
//  DisneyInterview
//
//  Created by Clifford Sharp on 9/5/12.
//  Copyright (c) 2012 Clifford Sharp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIAccelerometerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *greetingLbl;
@property (nonatomic, weak) IBOutlet UILabel *directionLbl;
@property (nonatomic, weak) IBOutlet UILabel *whichOneLbl;

@end
