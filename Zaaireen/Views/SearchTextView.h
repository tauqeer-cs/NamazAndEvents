//
//  SearchTextView.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/22/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchTextView


-(void)textBoxReturnTapped;

-(void)textDidChange:(NSString *)newText;

-(void)textEditingChange:(NSString *)newText;

@optional


@end

@interface SearchTextView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;

@property (nonatomic,strong) id<SearchTextView> delegate;


@end
