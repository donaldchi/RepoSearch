//
//  FirstViewController.h
//  RepoSearch
//
//  Created by chi on 21/12/2016.
//  Copyright © 2016 chi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "ResultViewCell.h"
#import "Repository.h"
#import "RepoPageViewController.h"

@interface SearchViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{
    UISearchBar *searchBar;
    UITableView *resultView;
    NSMutableArray * repoes;
    NSMutableDictionary * fav_repoes;
    RepoPageViewController * repoPage;
    int repo_count;
}

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *resultView;
@end

