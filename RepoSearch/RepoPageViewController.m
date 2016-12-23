//
//  RepoPageViewController.m
//  RepoSearch
//
//  Created by chi on 24/12/2016.
//  Copyright © 2016 chi. All rights reserved.
//

#import "RepoPageViewController.h"

@interface RepoPageViewController ()

@end

@implementation RepoPageViewController
@synthesize repoPage;
@synthesize repo;


#pragma mark - view lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    repoPage.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    repoPage.scalesPageToFit = true;
    self.title = @"Repository Page";
    self.navigationController.navigationBar.hidden = NO;
    
    is_favorited = NO;
    [self addFavCopyButton];
    [self showRepoPage];
}

- (void) addFavCopyButton {
    LOG_CURRENT_METHOD;
    UIBarButtonItem *copyBtn;
    SEL sel = @selector(copyBtnPressed:);
    UIImage * copy_img = [[UIImage imageNamed:@"copy.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    copyBtn = [[UIBarButtonItem alloc] initWithImage:copy_img style:UIBarButtonItemStylePlain target:self action:sel];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    NSMutableDictionary *defaults = [[ud objectForKey:@"favorites"]mutableCopy];
    NSString * key = [NSString stringWithFormat:@"%@%@", repo.user, repo.filename];
    NSLog(@"key: %@", key);
    UIImage * fav_img;
    if ([defaults.allKeys containsObject:key]) {
        fav_img =[[UIImage imageNamed:@"fav_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        is_favorited = YES;
    } else {
        fav_img =[[UIImage imageNamed:@"fav.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        is_favorited = NO;
    }
    
    UIBarButtonItem *favBtn;
    sel = @selector(favBtnPressed:);
    favBtn = [[UIBarButtonItem alloc] initWithImage:fav_img style:UIBarButtonItemStylePlain target:self action:sel];
    
    NSArray* items = [[NSArray alloc] initWithObjects:copyBtn, favBtn, nil];
    self.navigationItem.rightBarButtonItems = items;
}

- (void) copyBtnPressed:(id)sender {
    //copy url
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = repo.url;
    
    //change copy icon
    UIImage * copy_img = [[UIImage imageNamed:@"copy_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *copyBtn = [self.navigationItem.rightBarButtonItems objectAtIndex:0];
    [copyBtn setImage:copy_img];
    UIBarButtonItem *favBtn = [self.navigationItem.rightBarButtonItems objectAtIndex:1];
    NSArray* items = [[NSArray alloc] initWithObjects:copyBtn, favBtn, nil];
    self.navigationItem.rightBarButtonItems = items;
}

- (void) favBtnPressed:(id)sender {
    LOG_CURRENT_METHOD;
    UIImage * fav_img;
    UIBarButtonItem *copyBtn = [self.navigationItem.rightBarButtonItems objectAtIndex:0];
    UIBarButtonItem *favBtn = [self.navigationItem.rightBarButtonItems objectAtIndex:1];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    NSString * key = [NSString stringWithFormat:@"%@%@", repo.user, repo.filename];
    NSMutableDictionary *defaults = [[ud objectForKey:@"favorites"] mutableCopy];
    if(is_favorited) {
        // NSDataへ変換する
        [defaults removeObjectForKey:key];
        
        fav_img = [[UIImage imageNamed:@"fav.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        is_favorited = NO;
    } else {
        // NSDataへ変換する
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:repo];
        [defaults setObject:data forKey:key];
        
        fav_img = [[UIImage imageNamed:@"fav_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        is_favorited = YES;
    }
    
    [ud setObject:defaults forKey:@"favorites"];
    [ud synchronize];
    
    [favBtn setImage:fav_img];
    NSArray* items = [[NSArray alloc] initWithObjects:copyBtn, favBtn, nil];
    self.navigationItem.rightBarButtonItems = items;

}

-(void) showRepoPage {
    NSLog(@"URL: %@", repo.url);
    NSURL * theURL = [[NSURL alloc] initWithString:repo.url];
    [repoPage loadRequest:[NSURLRequest requestWithURL:theURL]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - memory management
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
