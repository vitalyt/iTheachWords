//
//  AddWordWebViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 12/6/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import "AddWordWebViewController.h"
#import "AddNewWordViewController.h"
#import "TextViewController.h"

@implementation AddWordWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createMenu];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithTitle:NSLocalizedString(@"Add word", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(showAddWordView)] autorelease];
    [self addWebView];
}

- (void)addWebView{
    if (!wordsView) {
        wordsView = [[AddNewWordViewController alloc] initWithNibName:@"AddNewWordViewController" bundle:nil];
        [wordsView setDelegate:self];
    }        
    CGRect frame = CGRectMake(10, -wordsView.view.frame.size.height, self.view.frame.size.width - 20, wordsView.view.frame.size.height);
    [wordsView.view setFrame:frame];
    [self.view addSubview:wordsView.view];
    isWordsViewShowing = NO;
}

- (void)showAddWordView{
    CGRect frame = CGRectMake(10, 0, self.view.frame.size.width - 20, wordsView.view.frame.size.height);
    if (isWordsViewShowing) {
        frame = CGRectMake(10, -wordsView.view.frame.size.height, self.view.frame.size.width - 20, wordsView.view.frame.size.height);
        //[self saveData];
        [wordsView closeAllKeyboard];
    }
    [UIView beginAnimations:@"MoveWebView" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [wordsView.view setFrame:frame];
    [UIView commitAnimations];
    
    isWordsViewShowing = !isWordsViewShowing;
}

#pragma mark create menu

- (void)createMenu{
    [self becomeFirstResponder];
    NSMutableArray *menuItemsMutableArray = [NSMutableArray new];
    UIMenuItem *menuItem = [[[UIMenuItem alloc] initWithTitle:@"Add word"
                                                       action:@selector(parceTranslateWord)] autorelease];
    UIMenuItem *menuTextParseItem = [[[UIMenuItem alloc] initWithTitle:@"Parse text"
                                                                action:@selector(parseText)] autorelease];
    UIMenuItem *menuTextTranslateItem = [[[UIMenuItem alloc] initWithTitle:@"Translate"
                                                                action:@selector(translateText)] autorelease];
    [menuItemsMutableArray addObject:menuItem];
    [menuItemsMutableArray addObject:menuTextParseItem];
    [menuItemsMutableArray addObject:menuTextTranslateItem];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect: self.webView.frame
                           inView:self.view];
    menuController.menuItems = menuItemsMutableArray;
    [menuController setMenuVisible:YES
                          animated:YES];
    [[UIMenuController sharedMenuController] setMenuItems:menuItemsMutableArray];
    [menuItemsMutableArray release];
}

- (void)parceTranslateWord{
    if (!isWordsViewShowing) {
        [self showAddWordView];
    }
    NSString *selectedText = [webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    [wordsView setText:selectedText];
    [wordsView setTranslate:[selectedText translateString]];
}

- (void)parseText{
    NSString *selectedText = [webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    if (selectedText.length > 0) {
        TextViewController *myTextView = [[TextViewController alloc] initWithNibName:@"TextViewController" bundle:nil];
        [self.navigationController pushViewController:myTextView animated:YES];
        [myTextView setText:selectedText];
        [myTextView release];
    }
}

-(void) translateText{
    NSString *selectedText = [webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    if (selectedText.length > 0) {
        NSString* translate = [selectedText translateString];
        [UIAlertView displayMessage:translate];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void) saveData{
	if (!wordsView.flgSave) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Do you want save word?", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cansel", @"") destructiveButtonTitle:NSLocalizedString(@"Delete canges", @"") otherButtonTitles: NSLocalizedString(@"Save changes", @""), nil];
        [actionSheet showInView:self.view];
	}
}

#pragma mark Alert functions

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1) {
		[wordsView save];
	}
	else if (buttonIndex == 0){
        [wordsView removeChanges];
	}
	else if (buttonIndex == 2){
		return;
	}
}

- (void)dealloc{
    [wordsView release];
    [super dealloc];
}

@end
