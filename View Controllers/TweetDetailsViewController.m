//
//  TweetDetailsViewController.m
//  twitter
//
//  Created by Sarah Wang on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"
#import "NSDate+DateTools.h"
#import "TweetCell.h"

@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pfpView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteIconView;
@property (weak, nonatomic) IBOutlet UIButton *retweetIconView;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;

@end


@implementation TweetDetailsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshData];
}

- (void)refreshData {
    //MARK: setting everything inside the tweet cell
    //profile image
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.pfpView.image = nil;           //clear previous image if it takes too long to load
    [self.pfpView setImageWithURL:url];
    
    //username
    self.usernameLabel.text = self.tweet.user.name;
    
    //username handle
    self.usernameHandleLabel.text = [@"@" stringByAppendingString: self.tweet.user.screenName];
    
    //timestamp/date published
    //self.timestampLabel.text = self.tweet.createdAtString;
    NSString *timestampString = self.tweet.createdAtString;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"E MMM d HH:mm:ss Z y"];
    NSDate *newTimestamp = [format dateFromString:timestampString];
    
    self.timestampLabel.text = newTimestamp.shortTimeAgoSinceNow;
    //the actual tweet
    self.tweetTextLabel.text = self.tweet.text;
    
    //retweets
    UIImage *retweeticon = [UIImage imageNamed:@"retweet-icon"];
    if(self.tweet.retweeted) {
        retweeticon = [UIImage imageNamed:@"retweet-icon-green"];
    }
    [self.retweetIconView setImage:retweeticon forState:UIControlStateNormal];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
    //favorite
    UIImage *favoriteicon = [UIImage imageNamed:@"favor-icon"];
    if(self.tweet.favorited) {
        favoriteicon = [UIImage imageNamed:@"favor-icon-red"];
    }
    [self.favoriteIconView setImage:favoriteicon forState:UIControlStateNormal];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
}
- (IBAction)didTapRetweet:(id)sender {
    NSLog(@"tapped retweet");
    if(self.tweet.retweeted)
    {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        // TODO: Send a POST request to the POST favorites/create endpoint
         [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unretweeting the following Tweet: %@", tweet.text);
             }
         }];
    }
    else
    {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        // TODO: Send a POST request to the POST favorites/create endpoint
         [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error retweet tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully retweet the following Tweet: %@", tweet.text);
             }
         }];
    }
    [self refreshData];
}

- (IBAction)didTapFavorite:(id)sender {
    NSLog(@"tapped favorite");
    if(self.tweet.favorited)
    {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        // TODO: Send a POST request to the POST favorites/create endpoint
         [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unfavoriting the following Tweet: %@", tweet.text);
             }
         }];
    }
    else
    {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        // TODO: Send a POST request to the POST favorites/create endpoint
         [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favoriting the following Tweet: %@", tweet.text);
             }
         }];
    }
    [self refreshData];
}


@end
