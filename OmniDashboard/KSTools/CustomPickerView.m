//
//  PickerView.m
//  ImOK
//
//  Created by Kumar Sharma on 04/06/11.
//  Copyright 2011 MSIT. All rights reserved.
//

#import "CustomPickerView.h"


@interface CustomPickerView()

-(void)cancelBtnAction;
-(void)configureViews;

@end

@implementation CustomPickerView
@synthesize pickerView;
@synthesize pickerObjects;
@synthesize pickerDelegate;
@synthesize selectedIndex;
@synthesize selectedObject;
@synthesize kbToolbar;
@synthesize isDatePicker;
@synthesize datePicker;

- (id)initWithFrame:(CGRect)frame
{    
	frame = CGRectMake(frame.origin.x, frame.origin.y, 260, 60);
    self = [super initWithFrame:frame];
    if (self) 
	{
		self.backgroundColor = [UIColor clearColor];
		[self configureViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame isDatePicker:(BOOL)isDate
{
	frame = CGRectMake(frame.origin.x, frame.origin.y, 260, 60);
    self = [super initWithFrame:frame];
    if (self)
	{
        self.isDatePicker = isDate;
		self.backgroundColor = [UIColor clearColor];
		[self configureViews];
    }
    return self;
}

-(void)configureViews
{
    if(!isDatePicker)
    {
        UIPickerView *aPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
        self.pickerView = aPickerView;
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.showsSelectionIndicator = YES;
        [self addSubview:pickerView];
        
        [self addSubview:kbToolbar];
    }
    else
    {
        UIDatePicker *dPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
        self.datePicker = dPicker;
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        
        [self.datePicker addTarget:self action:@selector(dateDidChange:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:self.datePicker];
    }
	
	
	if(!self.kbToolbar)
	{
		UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
		[toolbar setTintColor:[UIColor colorWithRed:(99.0f/255.0f) green:(150.0f/255.0f) blue:(161.0f/255.0f) alpha:1.0f]];
//		UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered																		target:self action:@selector(cancelBtnAction)];
		
		UIBarButtonItem *doneBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone
																	  target:self action:@selector(doneBtnAction)];
		
		UIBarButtonItem *fxble = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																			   target:nil action:nil];
		
		UIBarButtonItem *titleBar = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain
																	target:self action:nil];
		UIBarButtonItem *fxble2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																				target:nil action:nil];
		
		toolbar.items = [NSArray arrayWithObjects:fxble, titleBar, fxble2, doneBarBtn, nil];
		

		self.kbToolbar = toolbar;
        
        [self addSubview:self.kbToolbar];
	}
}

- (void)selectSelectedObjectAnimated:(BOOL)animated
{
    if(self.isDatePicker)
    {
        if([self.pickerDelegate respondsToSelector:@selector(didSelectDate:)])
            [self.pickerDelegate didSelectDate:self.datePicker.date];
    }
    else
    {
        if([self.pickerObjects containsObject:self.selectedObject])
        {
            [self.pickerView selectRow:[self.pickerObjects indexOfObject:self.selectedObject] inComponent:0 animated:animated];
        }
        else
        {
            if([self.pickerDelegate respondsToSelector:@selector(willSelectObject:withRow:)])
                [pickerDelegate willSelectObject:[self.pickerObjects objectAtIndex:0] withRow:selectedIndex];
        }
    }
}


-(void)cancelBtnAction
{	
	if([pickerDelegate respondsToSelector:@selector(pickerDidCancel)])
		[pickerDelegate pickerDidCancel];
}

-(void)doneBtnAction
{
	if([self.pickerDelegate respondsToSelector:@selector(didSelectObject:withRow:)])
		[pickerDelegate didSelectObject:[self.pickerObjects objectAtIndex:selectedIndex] withRow:selectedIndex];
}


- (void)dateDidChange:(UIDatePicker *)sender
{
    if([self.pickerDelegate respondsToSelector:@selector(didSelectDate:)])
        [self.pickerDelegate didSelectDate:sender.date];
}

#pragma mark -
#pragma mark UIPickerViewDelegates

- (void)pickerView:(UIPickerView *)_pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	selectedIndex = row;
	
	if([self.pickerDelegate respondsToSelector:@selector(willSelectObject:withRow:)])
		[pickerDelegate willSelectObject:[self.pickerObjects objectAtIndex:selectedIndex] withRow:selectedIndex];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;	
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return self.pickerObjects.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	return [self.pickerObjects objectAtIndex:row];	
}

- (void)dealloc 
{
	self.pickerView = nil;
	self.pickerObjects = nil;
}


@end
