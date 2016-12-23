//
//  ResultViewCell.m
//  RepoSearch
//
//  Created by chi on 22/12/2016.
//  Copyright © 2016 chi. All rights reserved.
//

#import "ResultViewCell.h"

@implementation ResultViewCell
@synthesize filename;
@synthesize user_pic;
@synthesize user;
@synthesize description;
@synthesize lan_pic;
@synthesize lan;
@synthesize star_pic;
@synthesize star;
@synthesize fork_pic;
@synthesize fork;
@synthesize favorite;
@synthesize update;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
