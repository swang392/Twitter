//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "DateTools.h"
#import "NSDate+DateTools.h"
#import "TweetDetailsViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchTweets];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchTweets {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = tweets;
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *temp in tweets)
            {
                NSString *text = temp.text;
                NSLog(@"%@", text);
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)didTweet:(Tweet *)tweet{
    if(!self.arrayOfTweets) {
        self.arrayOfTweets = [[NSMutableArray alloc] init];
    }
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}
 
 

- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];               //clear out access tokens
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];

    cell.pfpView.image = nil;
    [cell.pfpView setImageWithURL:url];
    
    cell.usernameLabel.text = tweet.user.name;
    
    cell.usernameHandleLabel.text = [@"@" stringByAppendingString: tweet.user.screenName];
    
    NSString *timestampString = tweet.createdAtString;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"E MMM d HH:mm:ss Z y"];
    NSDate *newTimestamp = [format dateFromString:timestampString];
    
    cell.timestampLabel.text = newTimestamp.shortTimeAgoSinceNow;

    cell.tweetTextLabel.text = tweet.text;
    
    UIImage *retweeticon = [UIImage imageNamed:@"retweet-icon"];
    if(tweet.retweeted) {
        retweeticon = [UIImage imageNamed:@"retweet-icon-green"];
    }
    [cell.retweetIconView setImage:retweeticon forState:UIControlStateNormal];
    cell.retweetCountLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    
    UIImage *favoriteicon = [UIImage imageNamed:@"favor-icon"];
    if(tweet.favorited) {
        favoriteicon = [UIImage imageNamed:@"favor-icon-red"];
    }
    [cell.favoriteIconView setImage:favoriteicon forState:UIControlStateNormal];
    cell.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    
    cell.tweet = tweet;
    
    return cell;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([sender isKindOfClass:[UIBarButtonItem class]]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    } else {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];

        TweetDetailsViewController *tweetViewController = [segue destinationViewController];
        tweetViewController.tweet = tweet;
    }
    
}



@end
