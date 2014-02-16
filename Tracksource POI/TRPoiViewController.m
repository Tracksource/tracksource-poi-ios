//
//  TRPoiViewController.m
//  Tracksource POI
//
//  Created by Paulo Luis Franchini Casaretto on 2/2/14.
//  Copyright (c) 2014 Paulo Luis Franchini Casaretto. All rights reserved.
//

#import "TRPoiViewController.h"
#import <MessageUI/MessageUI.h>

@interface TRPoiViewController (){
	NSArray *categories;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

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
	categories = [NSArray arrayWithObjects:@"Categoria 1", @"Categoria 2", @"Categoria 3", nil];
	[self.categoryPickerView selectRow:2 inComponent:0 animated:NO];
	
	RAC(self.sendButton, enabled) = [RACSignal
	 combineLatest:@[self.nomeTextField.rac_textSignal,self.streetTextField.rac_textSignal, self.numberTextField.rac_textSignal, self.bairroTextField.rac_textSignal, self.phoneTextField.rac_textSignal]
		reduce:^(NSString *nome, NSString *street,NSString *bairro, NSString *phone) {
		return @(nome.length > 0 && street.length > 0 && bairro.length > 0 && phone.length > 0);
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
	NSString *mensagem = [NSString stringWithFormat:
												@"<categoria>%@</categoria>\
												<nomepoi>%@</nomepoi>\
												<latitude>%f</latitude>\
												<longitude>%f</longitude>\
												<accuracy>%f</accuracy>\
												<endereco_rua>%@</endereco_rua>\
												<endereco_numero>%@</endereco_numero>\
												<endereco_bairro>%@</endereco_bairro>\
												<endereco_telefone>%@</endereco_telefone>\
												Enviado via iPhone",
												[categories objectAtIndex:[self.categoryPickerView selectedRowInComponent:0]],
												self.nomeTextField.text,
												self.location.coordinate.latitude,
												self.location.coordinate.longitude,
												self.location.horizontalAccuracy,
												self.streetTextField.text,
												self.numberTextField.text,
												self.bairroTextField.text,
												self.phoneTextField.text
//												];
//	if ([MFMailComposeViewController canSendMail]) {
//		MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
//		[controller setSubject:<#(NSString *)#>]
//	}
	
//	"<categoria>%@</categoria>";
//	mensagem += "\n<nomepoi>" + nomePoi.getText() + "</nomepoi>";
//	mensagem += "\n<latitude>" + latitude.getText() + "</latitude>";
//	mensagem += "\n<longitude>" + longitude.getText() + "</longitude>";
//	mensagem += "\n<accuracy>" + accuracy.getText() + "</accuracy>";
//	mensagem += "\n<endereco_rua>" + enderecoRua.getText() + "</endereco_rua>";
//	mensagem += "\n<endereco_numero>" + enderecoNumero.getText() + "</endereco_numero>";
//	mensagem += "\n<endereco_bairro>" + enderecoBairro.getText() + "</endereco_bairro>";
//	mensagem += "\n<endereco_telefone>" + enderecoTelefone.getText() + "</endereco_telefone>";
//	mensagem += "\n\nEnviado via Android";
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

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [categories objectAtIndex:row];
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[self.view endEditing:YES];
}

@end
