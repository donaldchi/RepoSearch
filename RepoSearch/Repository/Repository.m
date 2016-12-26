//
//  Reposity.m
//  RepoSearch
//
//  Created by chi on 23/12/2016.
//  Copyright © 2016 chi. All rights reserved.
//

#import "Repository.h"

@implementation Repository
@synthesize filename;
@synthesize user;
@synthesize language;
@synthesize desc;
@synthesize stargazer;
@synthesize fork;
@synthesize update;
@synthesize url;
@synthesize avatar;

// シリアライズ
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:filename forKey:@"filename"];
    [coder encodeObject:user forKey:@"user"];
    [coder encodeObject:language forKey:@"language"];
    [coder encodeObject:desc forKey:@"desc"];
    [coder encodeObject:stargazer forKey:@"stargazer"];
    [coder encodeObject:fork forKey:@"fork"];
    [coder encodeObject:update forKey:@"update"];
    [coder encodeObject:url forKey:@"url"];
    [coder encodeObject:avatar forKey:@"avatar"];
}

// デシリアライズ
- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    if (self) {
        filename = [coder decodeObjectForKey:@"filename"];
        user = [coder decodeObjectForKey:@"user"];
        language = [coder decodeObjectForKey:@"language"];
        desc = [coder decodeObjectForKey:@"desc"];
        stargazer = [coder decodeObjectForKey:@"stargazer"];
        fork = [coder decodeObjectForKey:@"fork"];
        update = [coder decodeObjectForKey:@"update"];
        url = [coder decodeObjectForKey:@"url"];
        avatar = [coder decodeObjectForKey:@"avatar"];
    }
    return self;
}

+ (Repository*) createRepoRecord: (NSDictionary *) item {
    Repository *repo=[[Repository alloc] init];
    LOG_CURRENT_METHOD;
    if(![item[@"full_name"] isEqual:[NSNull null]])
        repo.filename = item[@"full_name"];
    else
        repo.filename = @"";
    
    if(![item[@"owner"][@"login"] isEqual:[NSNull null]])
        repo.user = item[@"owner"][@"login"];
    else
        repo.user = @"";
        
    if(![item[@"owner"][@"avatar_url"] isEqual:[NSNull null]])
        repo.avatar = item[@"owner"][@"avatar_url"];
    else
        repo.avatar = @"";
    
    if(![item[@"html_url"] isEqual:[NSNull null]])
        repo.url = item[@"html_url"];
    else
        repo.url = @"";

    if(![item[@"updated_at"] isEqual:[NSNull null]]) {
        repo.update = item[@"updated_at"];
        repo.update = [repo.update substringToIndex:10];
        repo.update = [repo.update stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    }
    else
        repo.update = @"";
    
    if(![item[@"language"] isEqual:[NSNull null]])
        repo.language = item[@"language"];
    else
        repo.language = @"";
    
    if(![item[@"description"] isEqual:[NSNull null]])
        repo.desc = item[@"description"];
    else
        repo.desc = @"";
    
    int star_count = item[@"stargazers_count"];
    int fork_count = item[@"forks_count"];
    repo.stargazer = [NSString stringWithFormat:@"%d", star_count];
    repo.fork = [NSString stringWithFormat:@"%d", fork_count];

    NSLog(@"Repository: \
          file: %@ \
          user: %@ \
          stargazer: %@ \
          updatetime: %@ \
          url: %@ \
          avatar: %@ \
          desc: %@ \
          ", repo.filename, repo.user, repo.stargazer, repo.update, \
          repo.url, repo.avatar, repo.desc);
    return repo;
}

@end
