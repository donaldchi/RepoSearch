//
//  AppDelegate.h
//  RepoSearch
//
//  Created by chi on 21/12/2016.
//  Copyright © 2016 chi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UINavigationController *navigationController;
    UIWindow *window;
    UIImageView *logoImage;
}
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@end

