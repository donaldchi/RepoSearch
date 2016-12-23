//
//  SecondViewController.m
//  RepoSearch
//
//  Created by chi on 21/12/2016.
//  Copyright © 2016 chi. All rights reserved.
//

#import "FavoriteViewController.h"

@interface FavoriteViewController ()

@end

@implementation FavoriteViewController
@synthesize repoPage;
@synthesize favView;
@synthesize repoes;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    LOG_CURRENT_METHOD;
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    favView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    favView.delegate = self;
    favView.dataSource = self;
    
//    self.navigationController.navigationBar.hidden = YES;
    self.title = @"Favorites";
    
}

- (void) viewWillAppear:(BOOL)animated {
    LOG_CURRENT_METHOD;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    repoes = [[ud objectForKey:@"favorites"] mutableCopy];
    repo_count = [repoes count];
    NSLog(@"repo_count: %d", repo_count);
    [favView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return repo_count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Create an instance of ItemCell
    ResultViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"ResultViewCell"];

    NSArray *keys = [repoes allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id anObject = [repoes objectForKey:aKey];
    Repository *repo = [NSKeyedUnarchiver unarchiveObjectWithData:anObject];
    if(repo!=nil) {
        cell.user.text = repo.user;
        cell.filename.text = repo.filename;
        cell.description.text = repo.desc;
        cell.lan.text = repo.language;
        cell.star.text = repo.stargazer;
        cell.fork.text = repo.fork;
        cell.update.text = repo.update;
        
        NSURL *userPicURL = [NSURL URLWithString:repo.avatar];
        NSData * myData = [NSData dataWithContentsOfURL:userPicURL];
        UIImage *myImage = [UIImage imageWithData:myData];
        [cell.user_pic setImage:myImage];
    
        UIImage * lan_img = [UIImage imageNamed:@"code.png"];
        [cell.lan_pic setImage:lan_img];
    
        UIImage * fork_img = [UIImage imageNamed:@"fork.png"];
        [cell.fork_pic setImage:fork_img];
        
        UIImage * star_img = [UIImage imageNamed:@"star.png"];
        [cell.star_pic setImage:star_img];
        
        UIImage * fav_img = [UIImage imageNamed:@"fav_cell_selected.png"];
        [cell.favorite setImage:fav_img];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LOG_CURRENT_METHOD;
    
    if(repoes!=nil) {
        NSArray *keys = [repoes allKeys];
        id aKey = [keys objectAtIndex:indexPath.row];
        id anObject = [repoes objectForKey:aKey];
        Repository *repo = [NSKeyedUnarchiver unarchiveObjectWithData:anObject];
        
        NSLog(@"nav controller = %@", self.navigationController);
        repoPage = [[RepoPageViewController alloc] initWithNibName:@"RepoPageViewController" bundle:nil];
        
            NSLog(@"Repository: \
                  file: %@ \
                  user: %@ \
                  stargazer: %@ \
                  update: %@ \
                  url: %@ \
                  avatar: %@ \
                  desc: %@ \
                  ", repo.filename, repo.user, repo.stargazer, repo.update, \
                  repo.url, repo.avatar, repo.desc);
        
        repoPage.repo = repo;
        [self.navigationController pushViewController:repoPage animated:YES];
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
