//
//  TRPoiViewController.m
//  Tracksource POI
//
//  Created by Paulo Luis Franchini Casaretto on 2/2/14.
//  Copyright (c) 2014 Paulo Luis Franchini Casaretto. All rights reserved.
//

#import "TRPoiViewController.h"
#import <MessageUI/MessageUI.h>
#import <AFNetworking/AFNetworking.h>

@interface TRPoiViewController (){
	NSArray *categories;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) NSDictionary *selectedCategory;

@end

@implementation TRPoiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
			
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	categories = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Categories" ofType:@"plist"]];
	[self.categoryPickerView selectRow:2 inComponent:0 animated:NO];
	
	self.sendButton.enabled = false;
	
	RACSignal *enderecoEnabled = [[RACObserve(self, selectedCategory) filter:^BOOL(NSDictionary *dict){
		return [dict objectForKey:@"endereco"] != NULL ;
	}]map:^(NSDictionary *dict) {
		return [dict objectForKey:@"endereco"];
	}];
	
	RAC(self.streetTextField, enabled) = enderecoEnabled;
	RAC(self.numberTextField, enabled) = enderecoEnabled;
	RAC(self.bairroTextField, enabled) = enderecoEnabled;
	RAC(self.phoneTextField, enabled)  = enderecoEnabled;
	
	RAC(self.sendButton, enabled) = [RACSignal
	 combineLatest:@[enderecoEnabled, self.nomeTextField.rac_textSignal,self.streetTextField.rac_textSignal, self.numberTextField.rac_textSignal, self.bairroTextField.rac_textSignal, self.phoneTextField.rac_textSignal]
		reduce:^(NSNumber *enderecoEnabledVal, NSString *nome, NSString *number, NSString *street,NSString *bairro, NSString *phone) {
			BOOL enderecoEnabled = [enderecoEnabledVal boolValue];
			return @(nome.length > 0 && (!enderecoEnabled  || (street.length > 0 && number.length > 0 && bairro.length > 0 && phone.length > 0)));
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendButtonPressed:(id)sender {
	return;
	NSString *category = [[categories objectAtIndex: [self.categoryPickerView  selectedRowInComponent:0]] objectForKey:@"codigoSite"];
	NSDictionary *params =  @{
														@"nome":                         self.nomeTextField.text,
														@"latitude":                     [NSNumber numberWithFloat:self.location.coordinate.latitude],
														@"longitude":                    [NSNumber numberWithFloat:self.location.coordinate.longitude ],
														@"rua":                          self.nomeTextField.text,
														@"numero":                       self.nomeTextField.text,
														@"bairro":                       self.nomeTextField.text,
														@"telefone":                     self.nomeTextField.text,
														@"id_tracksource_pois_padrao":   category
														
		};

	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager GET:@"http://www.tracksource.org.br/desenv/pois_cadastra2.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
	}];

}

#pragma mark -
#pragma mark UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return categories.count;
}
#pragma mark -
#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	NSLog(@"didSelectRow");
	self.selectedCategory = [categories objectAtIndex:row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [(NSDictionary *)[categories objectAtIndex:row] objectForKey:@"nome"];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
	UILabel* tView = (UILabel*)view;
	if (!tView){
		tView = [[UILabel alloc] init];
		tView.adjustsFontSizeToFitWidth = YES;
	}
	tView.text = [self pickerView:pickerView titleForRow:row forComponent:component];
	tView.textAlignment = UIBaselineAdjustmentAlignCenters;
	return tView;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[self.view endEditing:YES];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}
@end
