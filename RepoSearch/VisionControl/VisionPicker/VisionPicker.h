//
//  VisionPicker.h
//  VisionControls
//
//  Created by Vision on 16/3/15.
//  Copyright © 2016年 VIIIO. All rights reserved.
//

#import "DownPicker.h"
#import "CboDataMODEL.h"

/**
 基於DownPicker(MIT License)的二次封裝Picker
 結構：textfield + downPicker(含pickerview)
 */
@class VisionPicker;
@protocol VisionPickerDelegate <NSObject>
@optional
- (void)visionPicker:(VisionPicker *)picker selectedItem:(CboDataMODEL *)item index:(NSInteger)index;

@end
@interface VisionPicker : UIControl

@property (weak,nonatomic) id<VisionPickerDelegate> delegate;
@property (strong,nonatomic) DownPicker *downPicker;
@property (strong,nonatomic) UITextField *textField;
/**
 數據源 NSMutableArray<CboDataMODEL>,不能有重複value&name 否則可能出現數據混亂;雖然使用dictionary可以解決但是dictionary是無序的
 */
@property (strong,nonatomic) NSMutableArray *dataSource;
@property (strong,nonatomic,readonly) CboDataMODEL *selectedItem;
@property (strong,nonatomic,readonly) NSString *selectedText;
@property (strong,nonatomic,readonly) NSString *selectedValue;
@property (strong,nonatomic) NSString *placeholderWhileSelecting;
@property (strong,nonatomic) NSString *toolbarDoneButtonText;
- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame data:(NSMutableArray *)dataSource;
- (void)selectItemAtIndex:(NSInteger)index;
- (void)selectItemValue:(NSString *)value;
@end
