//
//  FirstViewController.h
//  RepoSearch
//
//  Created by chi on 26/12/2016.
//  Copyright © 2016 chi. All rights reserved.
//

#import "MenuView.h"

@interface MenuView ()

@property (assign, nonatomic, readwrite) BOOL isMenuOpen;

@end

@implementation MenuView
@synthesize language;
@synthesize compareOptions;
@synthesize compareOrder;

#pragma mark - UIView methods

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSLog(@"awakeFromNib");
    
    // set initial value
    self.isMenuOpen = NO;
    language = @"";
    compareOrder=@"";
    compareOptions=@"";
    
    //set dropdown menu list
    [self setUpDropDownMenu];
}

-(void) setUpDropDownMenu {
    //compute position in order to put the button in the center of view
    int x = SCREEN_WIDTH/2 - 135;
    int y1 = SCREEN_WIDTH/6-50;
    int y2 = y1 + 50;
    int y3 = y2+50;
    
    //programming languages
    VisionPicker *language = [[VisionPicker alloc] initWithFrame:CGRectMake(x, y1, 270, 40)
                        data:[@[[CboDataMODEL modelWithValue:@""
                                    name:@"Language"],

                            [CboDataMODEL modelWithValue:@"c++" name:@"C++"],
                                
                            [CboDataMODEL modelWithValue:@"java" name:@"Java"],
                                
                            [CboDataMODEL modelWithValue:@"objective-c" name:@"Objective-c"],
                            
                            [CboDataMODEL modelWithValue:@"php" name:@"PHP"],
                            
                            [CboDataMODEL modelWithValue:@"python" name:@"Python"],
                                
                            [CboDataMODEL modelWithValue:@"R" name:@"R"],
                                
                            [CboDataMODEL modelWithValue:@"" name:@"No Selection"],
                                ] mutableCopy]];
    language.delegate = self;
    [self addSubview:language];
    language.tag = 1;
    
    // compare options
    VisionPicker *compare = [[VisionPicker alloc] initWithFrame:CGRectMake(x, y2, 270, 40)
                    data:[@[[CboDataMODEL modelWithValue:@""
                        name:@"Compare"],
                            
                        [CboDataMODEL modelWithValue:@"forks" name:@"Forks"],
                        
                        [CboDataMODEL modelWithValue:@"stars" name:@"Stargazers"],
                        
                        [CboDataMODEL modelWithValue:@"updated" name:@"Updatetime"],
                        ] mutableCopy]];
    compare.delegate = self;
    [self addSubview:compare];
    compare.tag = 2;
    
    //  compare order
    VisionPicker *compareOrder = [[VisionPicker alloc] initWithFrame:CGRectMake(x, y3, 270, 40)
                        data:[@[[CboDataMODEL modelWithValue:@""
                            name:@"Order"],
                                
                                [CboDataMODEL modelWithValue:@"asc" name:@"Ascending"],
                                
                                [CboDataMODEL modelWithValue:@"desc" name:@"Descending"],
                                ] mutableCopy]];
    compareOrder.delegate = self;
    [self addSubview:compareOrder];
    compareOrder.tag = 3;
}

#pragma mark - public methods

- (void)tappedMenuButton : (int) height
{
    NSLog(@"MenuView - tappedMenuButton");
    
    if (self.isMenuOpen) {
        [self closeMenuView: height];
    } else {
        [self openMenuView: height];
    }
}

#pragma mark - private methods

/**
 *  close MenuView
 */
- (void)closeMenuView : (int) height
{
    // Set new origin of menu
    CGRect menuFrame = self.frame;
    menuFrame.origin.y = menuFrame.origin.y - height;
    
    [UIView animateWithDuration:0.5f
                          delay:0.05f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = menuFrame;
                     }
                     completion:^(BOOL finished){
                         self.isMenuOpen = NO;
                     }];
    [UIView commitAnimations];
}

/**
 *  open MenuView
 */
- (void)openMenuView : (int) height
{
    // Set new origin of menu
    CGRect menuFrame = self.frame;
    
    menuFrame.origin.y = menuFrame.origin.y + height;
    
    [UIView animateWithDuration:0.5f
                          delay:0.05f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = menuFrame;
                     }
                     completion:^(BOOL finished){
                         self.isMenuOpen = YES;
                     }];
    [UIView commitAnimations];
}

#pragma mark - delegate
- (void)visionPicker:(VisionPicker *)picker selectedItem:(CboDataMODEL *)item index:(NSInteger)index{
    
    switch (picker.tag) {
        case 1:
            language = item.value;
            break;
        case 2:
            compareOptions = item.value;
            break;
        case 3:
            compareOrder = item.value;
            break;
        default:
            break;
    }

//    NSLog(@"tag: %d", picker.tag);
//    NSLog(@"SelectedValue:%@ - Name %@ - Index:%zi",item.value,item.name,index);
//    NSLog(@"SelectedValue: %@",item.value);
}

@end
