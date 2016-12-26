//
//  VisionPicker.m
//  VisionControls
//
//  Created by Vision on 16/3/15.
//  Copyright © 2016年 VIIIO. All rights reserved.
//

#import "VisionPicker.h"

@interface VisionPicker()

@property (strong,nonatomic) NSMutableArray *dataText;//純描述數據

@end

@implementation VisionPicker
#pragma mark - 初始化
- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame data:nil];
}
- (instancetype)initWithFrame:(CGRect)frame data:(NSMutableArray *)dataSource{
    self = [super initWithFrame:frame];
    if (self) {
        //init params
        _dataText = [[NSMutableArray alloc] init];
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textField.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        _textField.clearButtonMode = UITextFieldViewModeNever;
        _textField.textColor=[UIColor blackColor];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.tintColor = [UIColor clearColor];//Hide Cursor
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        
        _downPicker = [[DownPicker alloc] initWithTextField:self.textField];
        [_downPicker setPlaceholder:@"Select options"];//請選擇
        self.dataSource = dataSource;
        self.placeholderWhileSelecting = @"Select options";
        if (_dataSource.count > 0) {
            [_downPicker setValueAtIndex:0];
        }
        [_downPicker setToolbarDoneButtonText:@"完成"];
        [_downPicker addTarget:self
                        action:@selector(downPickerValueChanged:)
              forControlEvents:UIControlEventValueChanged];
        [self addSubview:_textField];
    }
    return self;
}

#pragma mark - getter & setter
- (void)setPlaceholderWhileSelecting:(NSString *)placeholderWhileSelecting{
    _placeholderWhileSelecting = placeholderWhileSelecting;
    if (self.downPicker) {
        [self.downPicker setPlaceholderWhileSelecting:placeholderWhileSelecting];
    }
}
- (void)setToolbarDoneButtonText:(NSString *)toolbarDoneButtonText{
    _toolbarDoneButtonText = toolbarDoneButtonText;
    if (self.downPicker) {
        [self.downPicker setToolbarDoneButtonText:toolbarDoneButtonText];
    }
}
- (void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = dataSource ? dataSource : [[NSMutableArray alloc] init];
    [self.dataText removeAllObjects];
    for (CboDataMODEL *item in _dataSource) {
        [self.dataText addObject:item.name];
    }
    if (self.downPicker) {
        [self.downPicker setData:self.dataText];
    }
}

- (void)setSelectedItem:(CboDataMODEL *)selectedItem{
    _selectedItem = selectedItem;
    if (selectedItem) {
        _selectedText = selectedItem.name;
        _selectedValue = selectedItem.value;
    }
}
#pragma mark - 觸發事件
- (void)selectItemAtIndex:(NSInteger)index{
    if (self.dataSource && self.dataSource.count > index) {
        if (self.downPicker) {
            self.selectedItem = self.dataSource[index];
            [self.downPicker setValueAtIndex:index];
        }
    }
}

- (void)selectItemValue:(NSString *)value{
    if (self.dataSource) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"value = %@",value];
        NSArray *arr = [self.dataSource filteredArrayUsingPredicate:predicate];
        if (arr && arr.count > 0) {
            [self selectItemAtIndex:[self.dataSource indexOfObject:arr[0]]];
        }
    }
}

- (void)downPickerValueChanged:(id)sender{
    [self performSelector:@selector(changeText) withObject:nil afterDelay:0.1];//determined by pickerview animation delay
}

- (void)changeText{
    if (self.textField.text) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@",self.textField.text];
        NSArray *arr_filter = [self.dataSource filteredArrayUsingPredicate:predicate];
        if (arr_filter.count > 0) {
            self.selectedItem = arr_filter[0];
            if ([self.delegate respondsToSelector:@selector(visionPicker:selectedItem:index:)]) {
                [self.delegate visionPicker:self selectedItem:self.selectedItem index:[self.dataSource indexOfObject:self.selectedItem]];
            }
        }
    }
}
@end
