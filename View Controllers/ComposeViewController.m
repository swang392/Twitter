//
//  ComposeViewController.m
//  twitter
//
//  Created by Sarah Wang on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *postView;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;


@end

@implementation ComposeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.postView.delegate = self;
    self.postView.layer.borderWidth = 2.0f;
    self.postView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.postView.layer.cornerRadius = 8;
}
- (IBAction)didTweet:(UIBarButtonItem *)sender {
    [[APIManager shared] postStatusWithText:(self.postView.text) completion:^(Tweet * tweet, NSError * error){
        if (error != nil){
            NSLog(@"😫😫😫 Error posting tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"😎😎😎 Successfully posted tweet");
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
    
}

- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    int characterLimit = 140;
    
    NSString *newText = [self.postView.text stringByReplacingCharactersInRange:range withString:text];
    
    if(newText.length >= characterLimit)
    {
        self.characterCountLabel.text = @"exceeded maximum characters";
    }
    else {
        self.characterCountLabel.text = [NSString stringWithFormat:@"%d", newText.length];
    }
    
    return newText.length < characterLimit;
}
 
@end 
 
