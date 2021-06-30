//
//  ComposeViewController.m
//  twitter
//
//  Created by Sarah Wang on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *postView;

@end

@implementation ComposeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)tweetButton:(id)sender {
    
}

- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
