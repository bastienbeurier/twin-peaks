//
//  ViewController.m
//  dale
//
//  Created by Bastien Beurier on 12/6/14.
//  Copyright (c) 2014 ghbb. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSMutableArray *coffeeSounds;
@property (nonatomic, strong) NSMutableArray *pieSounds;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shareButton.layer.cornerRadius = self.shareButton.frame.size.width/2;
    self.shareButton.clipsToBounds = YES;
    self.shareButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    self.pieSounds = [[NSMutableArray alloc] initWithObjects:@"pie3", @"pie5", @"pie2", @"pie4", @"pie1", nil];
    self.coffeeSounds = [[NSMutableArray alloc] initWithObjects: @"coffee4", @"coffee2", @"coffee3", @"coffee1", nil];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGFloat buttonSize = 150;
    
    CGRect frame1 = CGRectMake((screenWidth - buttonSize)/2, (screenHeight - 2 * buttonSize)/2, buttonSize, buttonSize);
    UIButton *button1 = [[UIButton alloc] initWithFrame:frame1];
    [button1 setImage:[UIImage imageNamed:@"coffee"] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:120];
    [button1 addTarget:self action:@selector(coffee) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    CGRect frame2 = CGRectMake((screenWidth - buttonSize)/2, (screenHeight - 2 * buttonSize)/2 + buttonSize, buttonSize, buttonSize);
    UIButton *button2 = [[UIButton alloc] initWithFrame:frame2];
    [button2 setImage:[UIImage imageNamed:@"pie"] forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:120];
    [button2 addTarget:self action:@selector(pie) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}

- (void)pie
{
    NSString *sound = [self.pieSounds lastObject];
    [self.pieSounds removeLastObject];
    [self.pieSounds insertObject:sound atIndex:0];
    
    [self playSound:sound];
}

- (void)coffee {
    NSString *sound = [self.coffeeSounds lastObject];
    [self.coffeeSounds removeLastObject];
    [self.coffeeSounds insertObject:sound atIndex:0];
    
    [self playSound:sound];
}

- (void)playSound:(NSString *)sound
{
    if (self.player) {
        [self.player stop];
    }
    
    NSError* error;
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:sound ofType:@".mp4"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    if (error || ![self.player prepareToPlay]) {
        NSLog(@"%@",error);
    } else {
        [self.player play];
    }
}

- (IBAction)shareButtonClicked:(id)sender {
    NSString *shareString = @"This is, excuse me, a damn fine cup of coffee!";
    
    NSURL *shareUrl = [NSURL URLWithString:@"http://itunes.apple.com/app/id949255429"];
    
    NSArray *activityItems = [NSArray arrayWithObjects:shareString, shareUrl, [UIImage imageNamed:@"AppIcon"], nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList, UIActivityTypeAirDrop];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
