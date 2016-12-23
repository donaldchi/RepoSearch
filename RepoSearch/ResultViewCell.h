//
//  ResultViewCell.h
//  RepoSearch
//
//  Created by chi on 22/12/2016.
//  Copyright © 2016 chi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewCell : UITableViewCell {
    UILabel * filename;
    UIImageView * user_pic;
    UILabel * user;
    UILabel * description;
    UIImageView * lan_pic;
    UILabel * lan;
    UIImageView * star_pic;
    UILabel * star;
    UIImageView * fork_pic;
    UILabel * fork;
    UIImageView * favorite;
    UILabel * update;
}

@property (nonatomic, retain) IBOutlet UILabel * filename;
@property (nonatomic, retain) IBOutlet UIImageView * user_pic;
@property (nonatomic, retain) IBOutlet UILabel * user;
@property (nonatomic, retain) IBOutlet UILabel * description;
@property (nonatomic, retain) IBOutlet UIImageView * lan_pic;
@property (nonatomic, retain) IBOutlet UILabel * lan;
@property (nonatomic, retain) IBOutlet UIImageView * star_pic;
@property (nonatomic, retain) IBOutlet UILabel * star;
@property (nonatomic, retain) IBOutlet UIImageView * fork_pic;
@property (nonatomic, retain) IBOutlet UILabel * fork;
@property (nonatomic, retain) IBOutlet UIImageView * favorite;
@property (nonatomic, retain) IBOutlet UILabel * update;
@end
