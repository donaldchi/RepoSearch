//
//  Reposity.h
//  RepoSearch
//
//  Created by chi on 23/12/2016.
//  Copyright © 2016 chi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Define.h"

@interface Repository : NSObject<NSCoding>
@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * stargazer;
@property (nonatomic, retain) NSString * fork;
@property (nonatomic, retain) NSString * update;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * avatar;

+ (Repository*) createRepoRecord: (NSDictionary *) item;
@end
