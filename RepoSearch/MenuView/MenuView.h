//
//  FirstViewController.h
//  RepoSearch
//
//  Created by chi on 26/12/2016.
//  Copyright © 2016 chi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "VisionPicker.h"

@class MenuView;

@protocol MenuViewDelegate <NSObject, VisionPickerDelegate>

@end

@interface MenuView : UIView
@property (weak, nonatomic) id<MenuViewDelegate> delegate;
@property (assign, nonatomic, readonly) BOOL isMenuOpen;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * compareOptions;
@property (nonatomic, retain) NSString * compareOrder;
- (void)tappedMenuButton:(int) height;

@end
