//
//  Define.h
//  RepoSearch
//
//  Created by chi on 21/12/2016.
//  Copyright © 2016 chi. All rights reserved.
//


#define DEBUG

#define FAV @"favorites";
// デバッグ用マクロ
#ifdef DEBUG
#  define LOG(...) NSLog(__VA_ARGS__)
#  define LOG_CURRENT_METHOD NSLog(@"%@/%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#else
#  define LOG(...) ;
#  define LOG_CURRENT_METHOD ;
#endif

// 時間計測に使用
#define BM_START(name) NSDate *name##_start = [NSDate new]
#define BM_END(name)   NSDate *name##_end = [NSDate new];\
NSLog(@"%s interval: %f", #name, [name##_end timeIntervalSinceDate:name##_start])
//NSLog(@"%s interval: %f", #name, [name##_end timeIntervalSinceDate:name##_start]);\
//[name##_start release];[name##_end release]

//画面サイズ取得マクロ
#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)
