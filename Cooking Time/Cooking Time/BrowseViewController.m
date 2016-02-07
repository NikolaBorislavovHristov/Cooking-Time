//
//  BrowseViewController.m
//  Cooking Time
//
//  Created by Nikola Hristov on 3/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "BrowseViewController.h"
#import "BrowseResultViewController.h"
#import "NHToastService.h"
#import "NHRecipeServices.h"
#import "CZPickerView.h"
#import "Cooking_Time-Swift.h"

@interface BrowseViewController () <UITextFieldDelegate, CZPickerViewDataSource, CZPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phraseField;
@property (weak, nonatomic) IBOutlet UISwitch *requirePicture;
@property (weak, nonatomic) IBOutlet UISlider *durationSlider;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
- (IBAction)removeIngredientOnClick;
- (IBAction)addIngredientOnClick;
- (IBAction)listIngredientOnClick;
- (IBAction)durationSliderOnChange:(UISlider *)sender;
@property NSMutableArray *ingredients;

@end

@implementation BrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ingredients = [[NSMutableArray alloc] init];
    self.phraseField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [self.phraseField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches
              withEvent:event];
    [self.phraseField resignFirstResponder];
}

- (IBAction)removeIngredientOnClick {
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Remove ingredients"
                                                   cancelButtonTitle:@"Cancel"
                                                  confirmButtonTitle:@"Confirm"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.allowMultipleSelection = YES;
    [picker show];
}

- (IBAction)addIngredientOnClick {
    UIAlertController * alert = [UIAlertController
                                  alertControllerWithTitle:@"Add ingredient"
                                  message:@""
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   NSString* newIngredient = [alert.textFields objectAtIndex:0].text;
                                                   if ([newIngredient length] != 0) {
                                                       [self.ingredients addObject:newIngredient];
                                                   }
                                                   
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter ingredient";
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)listIngredientOnClick {
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Ingredients"
                                                   cancelButtonTitle:@"Cancel"
                                                  confirmButtonTitle:@"Ok"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = NO;
    [picker show];
}

- (NSAttributedString *)czpickerView:(CZPickerView *)pickerView
               attributedTitleForRow:(NSInteger)row {
    NSLog(@"xxx");
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:self.ingredients[row]];
    return att;
}

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    return self.ingredients.count;
}

-(void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSArray *)rows{
    NSMutableArray* ingredientsToRemove = [NSMutableArray array];
    for(NSNumber *n in rows){
        NSInteger row = [n integerValue];
        [ingredientsToRemove addObject:self.ingredients[row]];
    }
    
    [self.ingredients removeObjectsInArray:ingredientsToRemove];
}

- (IBAction)durationSliderOnChange:(UISlider *)sender {
    self.durationLabel.text = [NSString stringWithFormat:@"%d min", [[NSNumber numberWithFloat:sender.value] intValue]];
}

- (IBAction)unwindForSegue:(UIStoryboardSegue *)unwindSegue {
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSearchResults"]){
        NSDictionary *params = @{
                                     @"phrase": self.phraseField.text,
                                     @"requirePicture": [NSNumber numberWithBool: self.requirePicture.isOn],
                                     @"ingredients": self.ingredients,
                                     @"duration": [NSNumber numberWithFloat: self.durationSlider.value]
                                };
        
        BrowseResultViewController *resultController = (BrowseResultViewController *)segue.destinationViewController;
        resultController.doReloading = YES;
        resultController.params = params;
    }
}

@end


























