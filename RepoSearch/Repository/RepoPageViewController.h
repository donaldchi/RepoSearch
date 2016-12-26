//
//  RepoPageViewController.h
//  RepoSearch
//
//  Created by chi on 24/12/2016.
//  Copyright © 2016 chi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "Repository.h"

@interface RepoPageViewController : UIViewController
{
    UIWebView * repoPage;
    Repository * repo;
    BOOL is_favorited;
}

@property (nonatomic, retain) IBOutlet UIWebView * repoPage;
@property (nonatomic, retain) IBOutlet Repository * repo;
@end
