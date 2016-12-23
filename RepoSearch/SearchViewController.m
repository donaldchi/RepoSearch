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

#pragma mark -
#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    searchBar.delegate = self;
    searchBar.placeholder = @"Please Input Keyword!";
    
    resultView.delegate = self;
    resultView.dataSource = self;
    
    self.title = @"Search";
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
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText{
    //入力を検知し、遅延実行することで結果を表示する
    dispatch_time_t *show_time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_MSEC));
    dispatch_after(show_time, dispatch_get_main_queue(), ^(void){
        [self searchRepo];
    });
}

- (void) searchRepo {
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
}

- (NSDictionary *) search: (NSString *) keyword {
    LOG_CURRENT_METHOD;
    //NSURLSessionは非同期処理であるため、disppath_semaphore_tを使って同期処理にする
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSString * url = [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@", keyword]   ;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    
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

- (void) createRepoRecords : (NSDictionary *) results {
    repoes = [[NSMutableArray alloc] init];
    
    repo_count = results[@"total_count"];
    NSLog(@"Count: %d", repo_count);
    
    NSArray * items = results[@"items"];
    int count=1;
    for (id item in items) {
        Repository *repo = [Repository createRepoRecord:item];
        [repoes addObject:repo];
        if(count==12) break;
        count++;
    }
    [self.resultView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 12;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // Create an instance of ItemCell
    ResultViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"ResultViewCell"];
    
    if(repoes!=nil) {
        Repository * repo = [repoes objectAtIndex:indexPath.row];
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
        
        NSString * key = [NSString stringWithFormat:@"%@%@", repo.user, repo.filename];
        UIImage * fav_img;
        if ([fav_repoes.allKeys containsObject:key]) {
            fav_img =[UIImage imageNamed:@"fav_selected.png"];
        } else {
            fav_img =[UIImage imageNamed:@"fav.png"];
        }
        
        [cell.favorite setImage:fav_img];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LOG_CURRENT_METHOD;
    if(repoes!=nil) {
        Repository * repo = [repoes objectAtIndex:indexPath.row];
        repoPage = [[RepoPageViewController alloc] initWithNibName:@"RepoPageViewController" bundle:nil];
        repoPage.repo = repo;
        [self.navigationController pushViewController:repoPage animated:YES];
    }
}
@end
