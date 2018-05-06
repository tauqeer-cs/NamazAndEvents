//
//  SearchTextView.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/22/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "SearchTextView.h"

@implementation SearchTextView


-(void)setUpView{
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField // this method get called when you tap "Go"
{
    [textField resignFirstResponder];
    
    [self.delegate textBoxReturnTapped];
    
    return YES;
}

- (IBAction)DidChange:(UITextField *)sender {
    
    
    [self.delegate textDidChange:sender.text];
    
}
- (IBAction)editingChange:(UITextField *)sender {
    [self.delegate textEditingChange:sender.text];
    
}

@end
