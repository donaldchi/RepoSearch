//
//  FirstViewController.h
//  RepoSearch
//
//  Created by chi on 21/12/2016.
//  Copyright © 2016 chi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"

@interface SearchViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate>{
    UISearchBar *searchBar;
    UITableView *resultView;
}

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *resultView;
@end

