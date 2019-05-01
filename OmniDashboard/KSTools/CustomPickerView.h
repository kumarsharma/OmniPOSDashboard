//
//  PickerView.h
//  ImOK
//
//  Created by Kumar Sharma on 04/06/11.
//  Copyright 2011 MSIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomPickerObjectDelegate <NSObject>

@optional

- (void)willSelectObject:(id)selectedObject withRow:(NSInteger)row;
- (void)didSelectObject:(id)selectedObject withRow:(NSInteger)row;

- (void)didSelectDate:(NSDate *)date;
- (void)pickerDidCancel;
@end




@interface CustomPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
{
	UIPickerView		*pickerView;
	NSArray				*pickerObjects;
	__weak id <CustomPickerObjectDelegate> pickerDelegate;
	NSInteger selectedIndex;
	id selectedObject;
	UIToolbar *kbToolbar;
}

@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) NSArray *pickerObjects;
@property (nonatomic, weak) id <CustomPickerObjectDelegate> pickerDelegate;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, retain) id selectedObject;
@property (nonatomic, retain) UIToolbar *kbToolbar;
@property (nonatomic, assign) BOOL isDatePicker;

- (id)initWithFrame:(CGRect)frame isDatePicker:(BOOL)isDate;

- (void)selectSelectedObjectAnimated:(BOOL)animated;

-(void)doneBtnAction;

@end

