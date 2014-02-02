//
//  TRViewController.h
//  Tracksource POI
//
//  Created by Paulo Luis Franchini Casaretto on 2/2/14.
//  Copyright (c) 2014 Paulo Luis Franchini Casaretto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TRViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *streetTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;

@end
