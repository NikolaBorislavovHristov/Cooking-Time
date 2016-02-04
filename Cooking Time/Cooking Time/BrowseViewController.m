//
//  BrowseViewController.m
//  Cooking Time
//
//  Created by Nikola Hristov on 3/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "BrowseViewController.h"
#import "UIKit/UIKit.h"
#import "CZPickerView.h"
#import "Cooking_Time-Swift.h"

@interface BrowseViewController () <UITextFieldDelegate, CZPickerViewDataSource, CZPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phraseField;
- (IBAction)removeIngredientOnClick;
- (IBAction)addIngredientOnClick;
- (IBAction)listIngredientOnClick;

@property NSMutableArray *ingredients;

@end

@implementation BrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ingredients = [NSMutableArray array];
    self.phraseField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.phraseField) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [LoadingServices hide];
    [super touchesBegan:touches withEvent:event];
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
               attributedTitleForRow:(NSInteger)row{
    
    NSAttributedString *att = [[NSAttributedString alloc]
                               initWithString:self.ingredients[row]];
    return att;
}

- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    return self.ingredients[row];
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
@end


























