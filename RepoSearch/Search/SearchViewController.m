//
//  FirstViewController.m
//  RepoSearch
//
//  Created by chi on 21/12/2016.
//  Copyright © 2016 chi. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize searchBar;
@synthesize resultView;
@synthesize menu;

#pragma mark -
#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    searchBar.delegate = self;
    searchBar.placeholder = @"Please Input Keyword!";
    
    resultView.delegate = self;
    resultView.dataSource = self;
    
    UIImage * bgImg = [UIImage imageNamed:@"background.jpg"];
    resultView.backgroundColor = [UIColor colorWithPatternImage:bgImg];
    
    self.title = @"Search";
    
    repo_count = 12;
    
    menuView = [[[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:self options:nil] lastObject];
    menuView.delegate = self;
    
    searchBarHeight = searchBar.frame.size.height;
    navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    menuView.frame = CGRectMake(0, -1*SCREEN_HEIGHT/3 + navigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT/3);
    [self.view addSubview:menuView];
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    fav_repoes = [[ud objectForKey:@"favorites"] mutableCopy];
    [resultView reloadData];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar*) searchBar{
    LOG_CURRENT_METHOD;
    [searchBar endEditing:YES];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText{
    NSLog(@"change");
    //入力を検知し、遅延実行することで結果を表示する
    dispatch_time_t *show_time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100*NSEC_PER_MSEC));
    dispatch_after(show_time, dispatch_get_main_queue(), ^(void){
        [self searchRepo];
    });
}

- (void) searchRepo {
    BM_START(searchRepo);
    NSString *keyword = searchBar.text;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //入力がある度にthreadを生成し、非同期で検索処理を行う
//    NSLog(@"main thread: %@", [NSThread currentThread]);
    __block NSDictionary *result; //各threadの結果を格納する
    dispatch_block_t block = ^{
        result = [self search: keyword];
//    NSLog(@"thread: %@, key: %@", [NSThread currentThread], keyword);
    };
    
    dispatch_group_async(group, queue, block);
    
    //処理が終わった時に通知を受け、結果を表示する
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"result: %@, thread: %@, key: %@", result,[NSThread currentThread], keyword);
//        NSLog(@"thread: %@, key: %@, count: %d",[NSThread currentThread], keyword, result[@"total_count"]);
        [self createRepoRecords:result];
    });
    BM_END(searchRepo);
}

- (NSDictionary *) search: (NSString *) keyword {
    LOG_CURRENT_METHOD;
    //NSURLSessionは非同期処理であるため、disppath_semaphore_tを使って同期処理にする
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
//    NSString * url = [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@", keyword]   ;
    
    NSURL * url = [self createURL:keyword];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    
    __block NSDictionary *jsonResponse = nil;
    //ephemeralSessionConfiguration: NSURLSessionが破棄されたタイミングで全てのデータが消去
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        if (!error) {
            // Success
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSError *jsonError;
                jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                if (jsonError) {
                    // Error Parsing JSON
                    NSLog(@"Json Error!");
                    
                } else {
                    // Success Parsing JSON
                     NSLog(@"Got results successfully!");
                }
            }  else {
                //Web server is returning an error
                NSLog(@"Web Server Error!");
            }
        } else {
            // Fail
            NSLog(@"error : %@", error.description);
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    [task resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return jsonResponse;
}

-  (NSURL *) createURL : (NSString *) keyword {
    NSString * url = [NSString stringWithFormat: @"https://api.github.com/search/repositories?q=%@",keyword];
    if(menuView.language!=@"") {
        url = [NSString stringWithFormat:@"%@+language:%@",url, menuView.language];
    }
    
    if(menuView.compareOptions!=@"") {
        NSLog(@"order: %@", menuView.compareOrder);
        
        if([menuView.compareOrder isEqualToString:@"asc"]) {
            NSLog(@"ascending");
            url = [NSString stringWithFormat:@"%@&sort=%@&order=asc", url,menuView.compareOptions];
        } else if ([menuView.compareOrder isEqualToString:@"desc"]) {
            url = [NSString stringWithFormat:@"%@&sort=%@&order=desc", url,menuView.compareOptions];
        } else {
           url = [NSString stringWithFormat:@"%@&sort=%@", url,menuView.compareOptions];
        }
    }
    
    NSLog(@"Final URL: %@", url);
    return [NSURL URLWithString:url];
}

- (void) createRepoRecords : (NSDictionary *) results {
    LOG_CURRENT_METHOD;
    
    if([results[@"message"] containsString:@"API rate limit"]) {
        NSLog(@"Limit Error!");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!!" message:@"API rate limit exceeded for 106.184.21.27. (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details. URL: https://developer.github.com/v3/#rate-limiting)" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        repoes = nil;
        [resultView reloadData];
        return;
    }
    
    NSArray * items = results[@"items"];
    if(items != nil) {
        repoes = [[NSMutableArray alloc] init];
        for (id item in items) {
            Repository *repo = [Repository createRepoRecord:item];
            [repoes addObject:repo];
        }
        
        [resultView reloadData];
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if([repoes count] < 12)
//        repo_count = [repoes count];
    return repo_count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LOG_CURRENT_METHOD;
    BM_START(initTable);
    // Create an instance of ItemCell
    ResultViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"ResultViewCell"];
    [cell setAlpha:1];
    NSLog(@"%d", [repoes count]);
    if(repoes!=nil && [repoes count] > indexPath.row) {
        NSLog(@"in cell");
        Repository * repo = [repoes objectAtIndex:indexPath.row];
        cell.user.text = repo.user;
        cell.filename.text = repo.filename;
        cell.description.text = repo.desc;
        cell.lan.text = repo.language;
        cell.star.text = repo.stargazer;
        cell.fork.text = repo.fork;
        
        cell.update.text = repo.update;
        
        //download user pic in async way
        [cell.user_pic setImage:nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // retrive image on global queue
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:repo.avatar]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                ResultViewCell * cell = (ResultViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                
                // assign cell image on main thread
                [cell.user_pic setImage:img];
            });
        });
        
        UIImage * lan_img = [UIImage imageNamed:@"code.png"];
        [cell.lan_pic setImage:lan_img];
        
        UIImage * fork_img = [UIImage imageNamed:@"fork.png"];
        [cell.fork_pic setImage:fork_img];
        
        UIImage * star_img = [UIImage imageNamed:@"star.png"];
        [cell.star_pic setImage:star_img];
        
        NSString * key = [NSString stringWithFormat:@"%@%@", repo.user, repo.filename];
        UIImage * fav_img;
        if ([fav_repoes.allKeys containsObject:key]) {
            fav_img =[UIImage imageNamed:@"fav_selected.png"];
        } else {
            fav_img =[UIImage imageNamed:@"fav.png"];
        }
        
        [cell.favorite setImage:fav_img];
    } else {
        //検索結果がない場合
        cell.user.text = nil;
        cell.filename.text = nil;
        cell.description.text = nil;
        cell.lan.text = nil;
        cell.star.text = nil;
        cell.fork.text = nil;
        cell.update.text = nil;
        [cell.user_pic setImage:nil];
        [cell.lan_pic setImage:nil];
        [cell.fork_pic setImage:nil];
        [cell.star_pic setImage:nil];
        [cell.favorite setImage:nil];
        
    }
    BM_END(initTable);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LOG_CURRENT_METHOD;
    if(repoes!=nil) {
        Repository * repo = [repoes objectAtIndex:indexPath.row];
        repoPage = [[RepoPageViewController alloc] initWithNibName:@"RepoPageViewController" bundle:nil];
        repoPage.repo = repo;
        [self.navigationController pushViewController:repoPage animated:YES];
    } else {
        ResultViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        [resultView reloadData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    LOG_CURRENT_METHOD;
    
    //一番下までスクロールしたかどうか
    if(resultView.contentOffset.y >= (resultView.contentSize.height - resultView.bounds.size.height)) {
        //まだ表示するコンテンツが存在するか判定し存在するなら○件分を取得して表示更新する
        NSLog(@"YES");
        
        int record_count = [repoes count];
        if(repo_count!=0 && record_count!=0) {
            repo_count = repo_count + 12;
            if(repo_count > record_count) {
                repo_count = record_count;
                return;
            }
            NSLog(@"repo_count: %d, repoes.count: %d", repo_count, [repoes count]);
            [resultView reloadData];
        }
    }
}

#pragma mark -
#pragma mark - menu management
- (IBAction)menuPressed:(id)sender {
    LOG_CURRENT_METHOD;
    if (menuView.isMenuOpen) {
        [self hiddenOverlayView];
        NSLog(@"hide menu");
        [searchBar setUserInteractionEnabled:YES];
        [resultView setUserInteractionEnabled:YES];
        [self searchRepo]; //option選択が終わった時点でもう一度検索し直す
        
    } else {
        [self showOverlayView];
        NSLog(@"show menu");
        [searchBar setUserInteractionEnabled:NO];
        [resultView setUserInteractionEnabled:NO];
    }
    
    [menuView tappedMenuButton:(searchBarHeight+navigationBarHeight+SCREEN_HEIGHT/3)];
}

- (void)showOverlayView
{
    overlayView.hidden = NO;
    overlayView.alpha = 0.0;
    
    [UIView animateWithDuration:0.3f
                          delay:0.05f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         overlayView.alpha = 0.5;
                     }
                     completion:^(BOOL finished){
                     }];
    
    [UIView commitAnimations];
}

- (void)hiddenOverlayView
{
    overlayView.alpha = 0.5;
    
    [UIView animateWithDuration:0.3f
                          delay:0.05f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         overlayView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         overlayView.hidden = YES;
                     }];
    
    [UIView commitAnimations];
}
@end
