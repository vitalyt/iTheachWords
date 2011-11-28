//
//  SettingsViewController.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 10/3/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "SettingsViewController.h"
#import "LanguagePickerController.h"
#import "TextFieldLanguagesCell.h"

#define FONT_OF_HEAD_LABEL [UIFont fontWithName:@"Helvetica-Bold" size:16]

@implementation SettingsViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization 
        self.title = NSLocalizedString(@"Settings", @"");
//        UIBarButtonItem *item = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)] autorelease];
//        [self.navigationItem setRightBarButtonItem:item]; 
    }
    return self;
}

- (void)dealloc
{
    [barItem release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    barItem.frame = CGRectMake(0, self.view.frame.size.height+barItem.frame.size.height, barItem.frame.size.width, barItem.frame.size.height);
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isSettingsMessage"]) {
        [UIAlertView displayMessage:NSLocalizedString(@"You are for the first time registering a card.\n Please make your self known in order for us to be able to E-mail address validate your membership.", @"")];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSettingsMessage"];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [barItem release];
    barItem = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) loadData{
    NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:@"Language"];
    NSString *fontName = DEFAULT_FONT_NAME;
    int fontSize = DEFAULT_FONT_SIZE;
    if (language) {
        [self.values setObject:language forKey:@"Language"];
    }
    if (fontName) {
        [self.values setObject:fontName forKey:@"fontName"];
    }
    if (fontSize) {
        [self.values setObject:[NSString stringWithFormat:@"%d",fontSize] forKey:@"fontSize"];
    }
    
    titles = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"Fill in the following fields in order to validate added cards to your wallet", @""), nil];
    NSArray *elements = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Language",@""),NSLocalizedString(@"Font size",@""),NSLocalizedString(@"Font name",@""),NSLocalizedString(@"Password",@""), nil];
    NSArray *elements1 = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Password",@""), nil];
    self.data = [NSArray arrayWithObjects:elements, nil];
    [elements release];
    [elements1 release];
    [self.table reloadData];
}

- (NSString*)keyForIndexPath:(NSIndexPath*)indexPath{
    NSString *key = @"";
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                key = @"Language";
                break;
            case 1:
                key = @"fontSize";
                break;
            case 2:
                key = @"fontName";
                break;
            case 3:
                key = @"Password";
                break;
                
            default:
                break;
        }
    }
    return key;
}

#pragma mark table view delegate
- (NSString*) tableView: (UITableView*)tableView cellIdentifierForRowAtIndexPath: (NSIndexPath*)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return @"TextFieldLanguagesCell";
                break;
            case 2:
            case 3:
                return @"TextFieldCell";
                break;
            default:
                break;
        }
    }
    return @"TextFieldCell";   
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 88;
    }
    return 44;
}

- (NSInteger) numberOfSectionsInTableView: (UITableView*)tableView {
    return [titles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    if (section == 1 && !switchPass.on) {
    //        return 0;
    //    }
    return [[data objectAtIndex:section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    if (section == 1) {
    UIView *v=[[[UIView alloc] init] autorelease];
    v.backgroundColor = [UIColor clearColor];
    NSString *tite = [titles objectAtIndex:section];
    float width ;
    width = self.view.frame.size.width - 40;
    if (section == 1) {
        width = self.view.frame.size.width - 140;
    }
    CGSize detailSize = [tite sizeWithFont:FONT_OF_HEAD_LABEL constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    UILabel *header = [[UILabel alloc] initWithFrame: CGRectMake(20, 10.0, width, detailSize.height)];
    header.numberOfLines = 3;
    header.backgroundColor = [UIColor clearColor];
    header.textColor = [UIColor colorWithRed:0.29f green:0.33f blue:0.42f alpha:1.0f];
    header.font = FONT_OF_HEAD_LABEL; 
    header.text = tite;
    [v addSubview:header];
    [header release];
    return v;
    //    }
    //    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	NSString *tite = [titles objectAtIndex:section];
    float width = self.view.frame.size.width - 40;
    if (section == 1) {
        width = self.view.frame.size.width - 140;
    }
	CGSize detailSize = [tite sizeWithFont:FONT_OF_HEAD_LABEL constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
	return detailSize.height + 15;//+titleSize.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[TextFieldCell class]]) {
        [((TextFieldCell *)cell).textField becomeFirstResponder];
    }
}

- (void) configureCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath {
    if ([cell isKindOfClass:[TextFieldCell class]]) {
        TextFieldCell* _cell = (TextFieldCell *)cell;
        _cell.textField.placeholder = NSLocalizedString(@"Touch to change", @""); 
        [_cell setDelegate:self];
        NSString *title = [[data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [_cell.titleLabel setText:title];
        NSString *value = [self.values objectForKey:[self keyForIndexPath:indexPath]];
        if (value) {
            _cell.textField.text = value;
        } 
        
        switch (indexPath.row) {
            case 1:
                _cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                break;
            case 2:
            {
                [_cell.textField setText:DEFAULT_FONT_NAME];
                [_cell.textField setFont:FONT_TEXT];
            }
                break;
            case 3:
                _cell.textField.secureTextEntry = YES;
                break;
                
            default:
                break;
        }
    }
    if ([cell isKindOfClass:[TextFieldLanguagesCell class]]) {
        TextFieldLanguagesCell* _cell = (TextFieldLanguagesCell *)cell;
        _cell.textField.placeholder = NSLocalizedString(@"Touch to change", @""); 
        _cell.textField2.placeholder = NSLocalizedString(@"Touch to change", @""); 
        _cell.textField.text = [[NSUserDefaults standardUserDefaults] stringForKey:NATIVE_COUNTRY];
        _cell.textField2.text = [[NSUserDefaults standardUserDefaults] stringForKey:TRANSLATE_COUNTRY];
        _cell.titleLabel.text = NSLocalizedString(@"Native language", @""); 
        _cell.titleLabel2.text = NSLocalizedString(@"Diffrent language", @"");
        [self setImageFlagInCell:_cell];
    }
}

- (void) setImageFlagInCell:(TextFieldLanguagesCell *)_cell{
    NSString *path = [NSString stringWithFormat:@"%@.png", [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE]];
	UIImageView *objImageEng = [[UIImageView alloc]initWithImage:[UIImage imageNamed:path]];
    [objImageEng setFrame:CGRectMake(0.0, 0.0, 20, 20)];
    path = [NSString stringWithFormat:@"%@.png", [[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE]];
	UIImageView *objImageRus = [[UIImageView alloc]initWithImage:[UIImage imageNamed:path]];
    [objImageRus setFrame:CGRectMake(0.0, 0.0, 20, 18)];
	[_cell.textField2 setLeftView:objImageEng];
	[_cell.textField2 setLeftViewMode:UITextFieldViewModeAlways];
	[_cell.textField setLeftView:objImageRus];
	[_cell.textField setLeftViewMode:UITextFieldViewModeAlways];
    objImageEng.layer.cornerRadius = 10.0;
    objImageRus.layer.cornerRadius = 5.0;
	[objImageRus release];
	[objImageEng release];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [titles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark Cells protocol functions

-(void)cellDidEndEditing:(TextFieldCell *)cell {
    //backgroundView.hidden = YES;
    NSIndexPath *indexPath = [table indexPathForCell:cell];
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self showToolbar];
        [table reloadData];
    }
	[super cellDidEndEditing:cell];
}

-(void)cellDidBeginEditing:(TextFieldCell *)cell {
    currentTextField = cell.textField;
    NSIndexPath *indexPath = [table indexPathForCell:cell];
    if ([cell isKindOfClass:[TextFieldLanguagesCell class]] ) {
        [self showDatePickerView:cell];
        [currentTextField resignFirstResponder];
        return;
    }else if (indexPath.row == 2){
        [self showFontPicker:nil];
        [currentTextField resignFirstResponder];
        return;
    }else if (indexPath.row == 1){
        [self showToolbar];
    }
    [super cellDidBeginEditing:cell];
}

-(void)cellChanged:(UITableViewCell *)cell {
	NSIndexPath *indexPath = [table indexPathForCell:cell];
	if (nil == indexPath) {
		return;
	}
    NSString *key;
    NSString *value;
    if ([cell isKindOfClass:[TextFieldCell class]]) {
        TextFieldCell *_cell = (TextFieldCell*)cell;
        value = _cell.textField.text;
        
        if (indexPath.section == 0) {
            key = [self keyForIndexPath:indexPath];
            [self.values setObject:value forKey:key];
            if (indexPath.row == 1) {
                [[NSUserDefaults standardUserDefaults] setInteger:[value intValue] forKey:@"defaultFontZise"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
}   

- (void) showDatePickerView:(TextFieldCell *)cell{
    [currentTextField resignFirstResponder];
    LanguagePickerController *languagePicker = [[LanguagePickerController alloc]initWithNibName:@"LanguagePickerController" bundle:nil];   
    [self.navigationController pushViewController:languagePicker animated:YES];
    [languagePicker release];
}

- (void)done{
    if (![self.values objectForKey:@"Name"] || ![self.values objectForKey:@"id"] || ![self.values objectForKey:@"luid"] || ![self.values objectForKey:@"Password"]) {
        [UIAlertView displayError:NSLocalizedString(@"Data is not completly", @"")];
        return;
    }
}

- (void)showToolbar{
    CGRect frame = barItem.frame; 
    if (!isKeyboardShowing) {
        frame = CGRectMake(0, self.view.frame.size.height-260, barItem.frame.size.width, barItem.frame.size.height);
    }else{
        frame = CGRectMake(0, self.view.frame.size.height+barItem.frame.size.height, barItem.frame.size.width, barItem.frame.size.height);
    }
    [UIView beginAnimations:@"MoveAndStrech" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [barItem setFrame:frame];
    [UIView commitAnimations];
    
    isKeyboardShowing = !isKeyboardShowing;
}

- (IBAction)changeSize:(id)sender {
    [currentTextField resignFirstResponder];
}

#pragma mark Font functions

- (void)showFontPicker:(id)sender {
    [currentTextField resignFirstResponder];
	ARFontPickerViewController *controller = [[ARFontPickerViewController alloc] initWithStyle:UITableViewStylePlain];
	controller.delegate = self;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

- (void)fontPickerViewController:(ARFontPickerViewController *)fontPicker didSelectFont:(NSString *)fontName {
	[fontPicker dismissModalViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setValue:fontName forKey:@"defaultFontName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [currentTextField setFont:FONT_TEXT];
	//[table reloadData];
}

@end
