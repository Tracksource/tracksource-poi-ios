//
//  TRPoiViewController.h
//  Tracksource POI
//
//  Created by Paulo Luis Franchini Casaretto on 2/2/14.
//  Copyright (c) 2014 Paulo Luis Franchini Casaretto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <CoreLocation/CoreLocation.h>

@interface TRPoiViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) CLLocation *location;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPickerView;

@property (weak, nonatomic) IBOutlet UITextField *nomeTextField;
@property (weak, nonatomic) IBOutlet UITextField *streetTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *bairroTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)sendButtonPressed:(id)sender;

@end
