//
//  SecondViewController.h
//  RepoSearch
//
//  Created by chi on 21/12/2016.
//  Copyright © 2016 chi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepoPageViewController.h"
#import "Define.h"
#import "ResultViewCell.h"
#import "Repository.h"

@interface FavoriteViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    UITableView *favView;
    RepoPageViewController * repoPage;
    NSDictionary *repoes;
    int repo_count;
}

@property (nonatomic, retain) IBOutlet RepoPageViewController * repoPage;
@property (nonatomic, retain) IBOutlet UITableView *favView;
@property (nonatomic, retain) IBOutlet NSDictionary *repoes;
@end

