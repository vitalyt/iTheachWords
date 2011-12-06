//
//  AddWordWebViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 12/6/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import "AddWordWebViewController.h"
#import "AddNewWordViewController.h"

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
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
    UIMenuItem *menuItem = [[[UIMenuItem alloc] initWithTitle:@"add new words"
                                                       action:@selector(parceTranslateWord)] autorelease];
    [menuItemsMutableArray addObject:menuItem];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect: CGRectMake(0, 0, 320, 200)
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
