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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    searchBar.delegate = self;
    searchBar.prompt = @"Github Repository Search";
    searchBar.placeholder = @"Please Input Keyword!";
    
    resultView.delegate = self;
}

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
//    __block NSString *result; //各threadの結果を格納する
    dispatch_block_t block = ^{
        [self search: keyword];
//    NSLog(@"thread: %@, key: %@", [NSThread currentThread], keyword);
    };
    
    dispatch_group_async(group, queue, block);
    
    //処理が終わった時に通知を受け、結果を表示する
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"result: %@, thread: %@, key: %@", result,[NSThread currentThread], keyword);
    });
}

- (void) search: (NSString *) keyword {
    LOG_CURRENT_METHOD;
    NSString * url = [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@", keyword];
    
    
//    return [NSThread currentThread];
//    return [NSString stringWithFormat:@"key: %@", keyword];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
