//
//  InputTableController.m
//  SOS
//
//  Created by Yalantis on 17.06.10.
//  Copyright 2010 Yalantis Software. All rights reserved.
//

#import "InputTableController.h"
#import "TextFieldCell.h"
#import "TextFieldCell.h"

@implementation InputTableController

@synthesize values,titles;
@synthesize responder;

- (void) dealloc
{
	[responder release];
	[self.values release];
    [titles release];
	[super dealloc];
}

#pragma mark -
#pragma mark InputCellDelegate

-(void)cellDidBeginEditing:(TextFieldCell *)cell {
	self.responder = [cell textField];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.2f];
	[UIView setAnimationDelegate:self];
	
	CGRect rect = cell.frame;
	if (rect.origin.y > 100.0f) {
		rect.origin.y -= 100.0f;
		[table setContentOffset:rect.origin];
	}
	
	UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, 280.0f, 0.0f);
	[table setContentInset:insets];
	[UIView commitAnimations];
	
}

-(void)cellDidEndEditing:(UITableViewCell *)cell {
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.2f];
	[UIView setAnimationDelegate:self];
	[table setContentInset:UIEdgeInsetsZero];
	[UIView commitAnimations];
}

- (NSString *)getKeyByIndex:(NSIndexPath *)indexPath{
    NSString *key = @"";
    return key;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.values) {
        self.values = [NSMutableDictionary dictionary];
    }
    if (self.titles) {
        self.titles = [NSArray array];
    }
    // Do any additional setup after loading the view from its nib.
}

@end
